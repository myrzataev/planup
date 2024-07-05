import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:planup/tmc/data/models/users_model.dart';
import 'package:planup/tmc/data/repositories/get_users_repo_impl.dart';

part 'get_users_event.dart';
part 'get_users_state.dart';

class GetUsersBloc extends Bloc<GetUsersEvent, GetUsersState> {
  GetUsersRepoImpl repoImpl;
  GetUsersBloc({required this.repoImpl}) : super(GetUsersInitial()) {
    on<GetUsersEvent>((event, emit) async {
      emit(GetUsersLoading());
      try {
        final result = await repoImpl.getUsers();
        emit(GetUsersSuccess(model: result));
      }
       on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        emit(GetUsersError(errorText: "У вас нет доступа"));
      } else {
        emit(GetUsersError(errorText: "Произошла ошибка: ${e.message}"));
      }
    } catch (e) {
        emit(GetUsersError(errorText: e.toString()));
      }
    });
  }
}
