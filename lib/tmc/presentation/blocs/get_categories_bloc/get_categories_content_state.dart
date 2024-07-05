part of 'get_categories_content_bloc.dart';

@immutable
sealed class GetCategoriesContentState {}

final class GetCategoriesContentInitial extends GetCategoriesContentState {}

final class GetCategoriesContentLoading extends GetCategoriesContentState {}

final class GetCategoriesContentSuccess extends GetCategoriesContentState {
  final List<CategoryModel> categoryModelList;
  GetCategoriesContentSuccess({required this.categoryModelList});
}

final class GetCategoriesContentError extends GetCategoriesContentState {
  final String errorText;
  GetCategoriesContentError({required this.errorText});
}
