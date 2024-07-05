part of 'get_trades_history_bloc.dart';

@immutable
sealed class GetTradesHistoryState {}

final class GetTradesHistoryInitial extends GetTradesHistoryState {}

final class GetTradesHistoryLoading extends GetTradesHistoryState {}

final class GetTradesHistorySuccess extends GetTradesHistoryState {
  final List<TransferGoodModel> modelList;
  GetTradesHistorySuccess({required this.modelList});
}

final class GetTradesHistoryError extends GetTradesHistoryState {
  final String errorText;
  GetTradesHistoryError({required this.errorText});
}
