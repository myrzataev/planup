part of 'transfer_good_bloc.dart';

@immutable
sealed class TransferGoodState {}

final class TransferGoodInitial extends TransferGoodState {}

final class TransferGoodLoading extends TransferGoodState {}

final class TransferGoodSuccess extends TransferGoodState {
  final  TransferGoodModel model;
  TransferGoodSuccess({required this.model});
}

final class TransferGoodError extends TransferGoodState {
  final String errorText;
  TransferGoodError({required this.errorText});
}
