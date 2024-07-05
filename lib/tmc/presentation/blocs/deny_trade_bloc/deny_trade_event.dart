part of 'deny_trade_bloc.dart';

@immutable
class DenyTradeEvent {
  final String id;
  final String comment;
  const DenyTradeEvent({required this.comment, required this.id});
}
