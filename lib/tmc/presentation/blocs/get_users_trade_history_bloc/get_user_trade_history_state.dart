part of 'get_user_trade_history_bloc.dart';

@immutable
sealed class GetUserTradeHistoryState {}

final class GetUserTradeHistoryInitial extends GetUserTradeHistoryState {}

final class GetUserTradeHistoryLoading extends GetUserTradeHistoryState {}

final class GetUserTradeHistorySuccess extends GetUserTradeHistoryState {
  final TransferGoodModel modelList;
  GetUserTradeHistorySuccess({required this.modelList});
}

final class GetUserTradeHistoryError extends GetUserTradeHistoryState {
  final String errorText;
  GetUserTradeHistoryError({required this.errorText});
}
