import 'package:bloc/bloc.dart';
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
      } catch (e) {
        emit(LoginError(errorText: e.toString()));
      }
    });
  }
}
