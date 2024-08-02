part of 'get_categories_bloc.dart';

@immutable
sealed class GetCategoriesState {}

final class GetCategoriesInitial extends GetCategoriesState {}
final class GetCategoriesLoading extends GetCategoriesState {}
final class GetCategoriesSuccess extends GetCategoriesState {
  final List<CategoriesCardModel> modelList;
  GetCategoriesSuccess({required this.modelList});
}
final class GetCategoriesError extends GetCategoriesState {
  final String errorText;
  GetCategoriesError({required this.errorText});
}
