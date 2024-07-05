import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:planup/tmc/data/models/create_goods_model.dart';
import 'package:planup/tmc/data/repositories/create_category_impl.dart';

part 'create_category_event.dart';
part 'create_category_state.dart';

class CreateCategoryBloc
    extends Bloc<CreateCategoryEvent, CreateCategoryState> {
  CreateCategoryImpl repositoryImpl;
  CreateCategoryBloc({required this.repositoryImpl})
      : super(CreateCategoryInitial()) {
    on<CreateCategoryEvent>((event, emit) async {
      emit(CreateCategoryLoading());
     
      try {
        final result = await repositoryImpl.createCategory(
            urlRoute: event.urlRoute,
            productManufactureId: event.productManufactureId,
            cost: int.parse(event.cost).toString(),
            productModelId: event.productModelId);
       
        emit(CreateCategorySuccess(model: result));
      } on DioException catch (e) {
        if (e.response?.statusCode == 403) {
          emit(CreateCategoryError(errorText: "У вас нет доступа"));
        } else {
          emit(
              CreateCategoryError(errorText: "Произошла ошибка: ${e.message}"));
        }
      } catch (e) {
        print("error state");
        CreateCategoryError(errorText: e.toString());
      }
    });
  }
}
