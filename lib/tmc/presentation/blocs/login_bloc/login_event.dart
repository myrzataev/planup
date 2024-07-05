part of 'login_bloc.dart';

@immutable
class LoginEvent {
  final String userName;
  final String password;
  const LoginEvent({required this.password, required this.userName});
}
