part of 'get_all_goods_bloc.dart';

@immutable
sealed class GetAllGoodsState {}

final class GetAllGoodsInitial extends GetAllGoodsState {}

final class GetAllGoodsLoading extends GetAllGoodsState {}

final class GetAllGoodsSuccess extends GetAllGoodsState {
  final AllGoodsModel allGoodsModelList;
  GetAllGoodsSuccess({required this.allGoodsModelList});
}

final class GetAllGoodsError extends GetAllGoodsState {
  final String errorText;
  GetAllGoodsError({required this.errorText});
}
