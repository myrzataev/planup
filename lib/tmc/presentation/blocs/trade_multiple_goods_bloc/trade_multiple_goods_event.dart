part of 'trade_multiple_goods_bloc.dart';

@immutable
 class TradeMultipleGoodsEvent {
  final MakeMultipleTradeModel model;
  const TradeMultipleGoodsEvent({required this.model});
 }
