part of 'trade_multiple_goods_bloc.dart';

@immutable
sealed class TradeMultipleGoodsState {}

final class TradeMultipleGoodsInitial extends TradeMultipleGoodsState {}

final class TradeMultipleGoodsLoading extends TradeMultipleGoodsState {}

final class TradeMultipleGoodsSuccess extends TradeMultipleGoodsState {
  final List<MultipleTradesModel> model;
  TradeMultipleGoodsSuccess({required this.model});
}

final class TradeMultipleGoodsError extends TradeMultipleGoodsState {
  final String errorText;
  TradeMultipleGoodsError({required this.errorText});
}
