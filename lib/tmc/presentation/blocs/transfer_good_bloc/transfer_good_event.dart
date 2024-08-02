part of 'transfer_good_bloc.dart';

@immutable
class TransferGoodEvent {
  final String sourceUserId;
  final int destinationUserId;
  final String goodID;
  final String tradeStatusId;
  final String comment;

  const TransferGoodEvent(
      {required this.sourceUserId,
      required this.destinationUserId,
      required this.goodID,
      required this.comment,
      required this.tradeStatusId});
}
