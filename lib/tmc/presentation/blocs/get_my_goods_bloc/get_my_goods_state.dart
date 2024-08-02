part of 'get_my_goods_bloc.dart';

@immutable
sealed class GetMyGoodsState {}

final class GetMyGoodsInitial extends GetMyGoodsState {}

final class GetMyGoodsLoading extends GetMyGoodsState {}

final class GetMyGoodsSuccess extends GetMyGoodsState {
  final List<MyGoodsModel> modelList;
  GetMyGoodsSuccess({required this.modelList});
}

final class GetMyGoodsError extends GetMyGoodsState {
  final String errorText;
  GetMyGoodsError({required this.errorText});
}
