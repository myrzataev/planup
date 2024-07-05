part of 'create_new_good_bloc.dart';

@immutable
sealed class CreateNewGoodState {}

final class CreateNewGoodInitial extends CreateNewGoodState {}

final class CreateNewGoodLoading extends CreateNewGoodState {}

final class CreateNewGoodSuccess extends CreateNewGoodState {
  final SingleGoodModel model;
  CreateNewGoodSuccess({required this.model});
}

final class CreateNewGoodError extends CreateNewGoodState {
  final String errorText;
  CreateNewGoodError({required this.errorText});
}
