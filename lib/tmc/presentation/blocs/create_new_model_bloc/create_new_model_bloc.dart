import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:planup/tmc/data/models/models_model.dart';
import 'package:planup/tmc/data/repositories/create_new_model_impl.dart';

part 'create_new_model_event.dart';
part 'create_new_model_state.dart';

class CreateNewModelBloc
    extends Bloc<CreateNewModelEvent, CreateNewModelState> {
  CreateNewModelImpl repoImpl;
  CreateNewModelBloc({required this.repoImpl})
      : super(CreateNewModelInitial()) {
    on<CreateNewModelEvent>((event, emit) async {
      emit(CreateNewModelLoading());
      try {
        final result = await repoImpl.createNewModel(
            urlRoute: event.urlRoute, nameOfModel: event.nameOfNewModel);

        emit(CreateNewModelSuccess(model: result));
      }
       on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        emit(CreateNewModelError(errorText: "У вас нет доступа"));
      } else {
        emit(CreateNewModelError(errorText: "Произошла ошибка: ${e.message}"));
      }
    }
       catch (e) {
        emit(CreateNewModelError(errorText: e.toString()));
      }
    });
  }
}
