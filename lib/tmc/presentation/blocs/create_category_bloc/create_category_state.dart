part of 'create_category_bloc.dart';

@immutable
sealed class CreateCategoryState {}

final class CreateCategoryInitial extends CreateCategoryState {}

final class CreateCategoryLoading extends CreateCategoryState {}

final class CreateCategorySuccess extends CreateCategoryState {
  final CreateCategoryModel model;
  CreateCategorySuccess({required this.model});
}

final class CreateCategoryError extends CreateCategoryState {
  final String errorText;
  CreateCategoryError({required this.errorText});
}
