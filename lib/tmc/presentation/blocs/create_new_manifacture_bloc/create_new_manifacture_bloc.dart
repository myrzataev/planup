import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:planup/tmc/data/models/manufacture_model.dart';
import 'package:planup/tmc/data/repositories/create_new_manifacture_impl.dart';

part 'create_new_manifacture_event.dart';
part 'create_new_manifacture_state.dart';

class CreateNewManifactureBloc
    extends Bloc<CreateNewManifactureEvent, CreateNewManifactureState> {
  CreateNewManifactureImpl repoImpl;

  CreateNewManifactureBloc({required this.repoImpl})
      : super(CreateNewManifactureInitial()) {
    on<CreateNewManifactureEvent>((event, emit) async {
      emit(CreateNewManifactureLoading());
      try {
        final result = await repoImpl.createNewManifacture(
            nameOfManifacture: event.nameOfManifacture,
            urlRouteForCategory: event.urlRoute);

        emit(CreateNewManifactureSuccess(model: result));
      } on DioException catch (e) {
        if (e.response?.statusCode == 403) {
          emit(CreateNewManifactureError(errorText: "У вас нет доступа"));
        } else {
          emit(CreateNewManifactureError(
              errorText: "Произошла ошибка: ${e.message}"));
        }
      } catch (e) {
        emit(CreateNewManifactureError(errorText: e.toString()));
      }
    });
  }
}
