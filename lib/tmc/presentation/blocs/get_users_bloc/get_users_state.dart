part of 'get_users_bloc.dart';

@immutable
sealed class GetUsersState {}

final class GetUsersInitial extends GetUsersState {}

final class GetUsersLoading extends GetUsersState {}

final class GetUsersSuccess extends GetUsersState {
  final List<UsersModel> model;
  GetUsersSuccess({required this.model});
}

final class GetUsersError extends GetUsersState {
  final String errorText;
  GetUsersError({required this.errorText});
}
