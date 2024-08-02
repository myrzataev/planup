part of 'get_deleted_goods_list_bloc.dart';

@immutable
sealed class GetDeletedGoodsListState {}

final class GetDeletedGoodsListInitial extends GetDeletedGoodsListState {}

final class GetDeletedGoodsListLoading extends GetDeletedGoodsListState {}

final class GetDeletedGoodsListSuccess extends GetDeletedGoodsListState {
  final List<DeletedGoodsModel> modelList;
  GetDeletedGoodsListSuccess({required this.modelList});
}

final class GetDeletedGoodsListError extends GetDeletedGoodsListState {
  final String errorText;
  GetDeletedGoodsListError({required this.errorText});
}
