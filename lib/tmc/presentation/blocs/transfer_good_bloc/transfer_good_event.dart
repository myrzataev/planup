part of 'transfer_good_bloc.dart';

@immutable
class TransferGoodEvent {
  final String sourceUserId;
  final String destinationUserId;
  final String goodID;
  final String tradeStatusId;

  const TransferGoodEvent(
      {required this.sourceUserId,
      required this.destinationUserId,
      required this.goodID,
      required this.tradeStatusId});
}
