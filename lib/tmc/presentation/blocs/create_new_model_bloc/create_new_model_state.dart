part of 'create_new_model_bloc.dart';

@immutable
sealed class CreateNewModelState {}

final class CreateNewModelInitial extends CreateNewModelState {}

final class CreateNewModelLoading extends CreateNewModelState {}

final class CreateNewModelSuccess extends CreateNewModelState {
  final GoodsModelsModel model;
   CreateNewModelSuccess({required this.model});
}

final class CreateNewModelError extends CreateNewModelState {
  final String errorText;
  CreateNewModelError({required this.errorText});
}
