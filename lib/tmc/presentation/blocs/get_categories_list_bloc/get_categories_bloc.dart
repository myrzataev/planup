import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:planup/tmc/data/mock_data/card_categories_model.dart';
import 'package:planup/tmc/data/repositories/get_categories_list_impl.dart';

part 'get_categories_event.dart';
part 'get_categories_state.dart';

class GetCategoriesBloc extends Bloc<GetCategoriesEvent, GetCategoriesState> {
  GetCategoriesListImpl repoImpl;
  GetCategoriesBloc({required this.repoImpl}) : super(GetCategoriesInitial()) {
    on<GetCategoriesEvent>((event, emit) async {
      emit(GetCategoriesLoading());
      try {
        final result = await repoImpl.getCategoriesList();
        emit(GetCategoriesSuccess(modelList: result));
      } on DioException catch (e) {
        if (e.response?.statusCode == 403) {
          emit(GetCategoriesError(errorText: "У вас нет доступа"));
        } else if (e.type == DioExceptionType.sendTimeout) {
          emit(GetCategoriesError(errorText: "Проверьте интернет подключение"));
        } else if (e.type == DioExceptionType.connectionError) {
          emit(GetCategoriesError(errorText: "Проверьте интернет подключение"));
        } else if (e.type == DioExceptionType.receiveTimeout) {
          emit(GetCategoriesError(errorText: "Проверьте интернет подключение"));
        } else {
          emit(GetCategoriesError(errorText: "Произошла ошибка: ${e.message}"));
        }
      } catch (e) {
        emit(GetCategoriesError(errorText:"Что то пошло не так, попробуйте снова"));
      }
    });
  }
}
