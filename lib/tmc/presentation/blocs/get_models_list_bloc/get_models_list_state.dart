part of 'get_models_list_bloc.dart';

@immutable
sealed class GetModelsListState {}

final class GetModelsListInitial extends GetModelsListState {}

final class GetModelsListLoading extends GetModelsListState {}

final class GetModelsListSuccess extends GetModelsListState {
  final List<GoodsModelsModel> modelsList;
  GetModelsListSuccess({required this.modelsList});
}

final class GetModelsListError extends GetModelsListState {
  final String errorText;
  GetModelsListError({required this.errorText});
}
