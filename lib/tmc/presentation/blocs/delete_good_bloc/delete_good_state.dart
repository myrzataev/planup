part of 'delete_good_bloc.dart';

@immutable
sealed class DeleteGoodState {}

final class DeleteGoodInitial extends DeleteGoodState {}

final class DeleteGoodLoading extends DeleteGoodState {}

final class DeleteGoodSuccess extends DeleteGoodState {}

final class DeleteGoodError extends DeleteGoodState {
  final String errorText;
  DeleteGoodError({required this.errorText});
}
