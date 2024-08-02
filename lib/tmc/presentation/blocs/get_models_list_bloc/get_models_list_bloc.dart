import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:planup/tmc/data/models/models_model.dart';
import 'package:planup/tmc/data/repositories/get_models_list.dart';

part 'get_models_list_event.dart';
part 'get_models_list_state.dart';

class GetModelsListBloc extends Bloc<GetModelsListEvent, GetModelsListState> {
  GetModelsListRepoImpl repoImpl;
  GetModelsListBloc({required this.repoImpl}) : super(GetModelsListInitial()) {
    on<GetModelsListEvent>((event, emit) async {
      emit(GetModelsListLoading());
      try {
        final result = await repoImpl.getModelsList(urlRoute: event.urlRoute);
        emit(GetModelsListSuccess(modelsList: result));
      } on DioException catch (e) {
        if (e.response?.statusCode == 403) {
          emit(GetModelsListError(errorText: "У вас нет доступа"));
        } else if (e.type == DioExceptionType.sendTimeout) {
          emit(GetModelsListError(errorText: "Проверьте интернет подключение"));
        } else if (e.type == DioExceptionType.connectionError) {
          emit(GetModelsListError(errorText: "Проверьте интернет подключение"));
        } else if (e.type == DioExceptionType.receiveTimeout) {
          emit(GetModelsListError(errorText: "Проверьте интернет подключение"));
        } else {
          emit(GetModelsListError(errorText: "Произошла ошибка: ${e.message}"));
        }
      } catch (e) {
        emit(GetModelsListError(errorText:"Что то пошло не так, попробуйте снова"));
      }
    });
  }
}
