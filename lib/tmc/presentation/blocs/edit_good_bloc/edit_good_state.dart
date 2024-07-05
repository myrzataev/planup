part of 'edit_good_bloc.dart';

@immutable
sealed class EditGoodState {}

final class EditGoodInitial extends EditGoodState {}

final class EditGoodLoading extends EditGoodState {}

final class EditGoodSuccess extends EditGoodState {
  final SingleGoodModel model;
  EditGoodSuccess({required this.model});
}

final class EditGoodError extends EditGoodState {
  final String errorText;
  EditGoodError({required this.errorText});
}
