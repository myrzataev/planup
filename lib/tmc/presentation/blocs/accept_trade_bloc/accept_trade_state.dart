part of 'accept_trade_bloc.dart';

@immutable
sealed class AcceptTradeState {}

final class AcceptTradeInitial extends AcceptTradeState {}

final class AcceptTradeLoading extends AcceptTradeState {}

final class AcceptTradeSuccess extends AcceptTradeState {
  final TransferGoodModel model;
  AcceptTradeSuccess({required this.model});
}

final class AcceptTradeError extends AcceptTradeState {
  final String errorText;
  AcceptTradeError({required this.errorText});
}
