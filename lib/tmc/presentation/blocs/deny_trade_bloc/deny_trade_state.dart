part of 'deny_trade_bloc.dart';

@immutable
sealed class DenyTradeState {}

final class DenyTradeInitial extends DenyTradeState {}

final class DenyTradeLoading extends DenyTradeState {}

final class DenyTradeSuccess extends DenyTradeState {
  final TransferGoodModel model;
  DenyTradeSuccess({required this.model});
}

final class DenyTradeError extends DenyTradeState {
  final String errorText;
  DenyTradeError({required this.errorText});
}
