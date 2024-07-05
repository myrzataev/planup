import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:planup/tmc/data/models/category_model.dart';
import 'package:planup/tmc/data/repositories/get_categories_content_impl.dart';

part 'get_categories_content_event.dart';
part 'get_categories_content_state.dart';

class GetCategoriesContentBloc
    extends Bloc<GetCategoriesContentEvent, GetCategoriesContentState> {
  GetCategoriesContentImpl repoImpl;
  GetCategoriesContentBloc({required this.repoImpl})
      : super(GetCategoriesContentInitial()) {
    on<GetCategoriesContentEvent>((event, emit) async {
      emit(GetCategoriesContentLoading());
      try {
        final result =
            await repoImpl.getCategoriesContent(urlRoute: event.urlRoute);
        emit(GetCategoriesContentSuccess(categoryModelList: result));
      } on DioException catch (e) {
        if (e.response?.statusCode == 403) {
          emit(GetCategoriesContentError(errorText: "У вас нет доступа"));
        } else {
          emit(GetCategoriesContentError(
              errorText: "Произошла ошибка: ${e.message}"));
        }
      } catch (e) {
        emit(GetCategoriesContentError(errorText: e.toString()));
      }
    });
  }
}
