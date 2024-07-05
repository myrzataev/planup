part of 'get_my_trades_bloc.dart';

@immutable
sealed class GetMyTradesState {}

final class GetMyTradesInitial extends GetMyTradesState {}

final class GetMyTradesLoading extends GetMyTradesState {}

final class GetMyTradesSuccess extends GetMyTradesState {
  final TransferGoodModel modelList;
  GetMyTradesSuccess({required this.modelList});
}

final class GetMyTradesError extends GetMyTradesState {
  final String errorText;
  GetMyTradesError({required this.errorText});
}
