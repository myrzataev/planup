import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:planup/tmc/data/models/authorization_model.dart';
import 'package:planup/tmc/data/repositories/login_repo_impl.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginRepoImpl repoImpl;
  LoginBloc({required this.repoImpl}) : super(LoginInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(LoginLoading());
      try {
        final result = await repoImpl.login(
            userName: event.userName, password: event.password);
        emit(LoginSuccess(model: result));
      } on DioException catch (e) {
        if (e.response?.statusCode == 403) {
          emit(LoginError(errorText: "У вас нет доступа"));
        } else if (e.type == DioExceptionType.sendTimeout) {
          emit(LoginError(errorText: "Проверьте интернет подключение"));
        } else if (e.type == DioExceptionType.connectionError) {
          emit(LoginError(errorText: "Проверьте интернет подключение"));
        } else if (e.type == DioExceptionType.receiveTimeout) {
          emit(LoginError(errorText: "Проверьте интернет подключение"));
        } else {
          emit(LoginError(errorText: "Произошла ошибка: ${e.message}"));
        }
      } catch (e) {
       emit(LoginError(errorText: "Что то пошло не так, попробуйте снова"));
      }
    });
  }
}
