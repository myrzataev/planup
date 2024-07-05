part of 'create_new_manifacture_bloc.dart';

@immutable
sealed class CreateNewManifactureState {}

final class CreateNewManifactureInitial extends CreateNewManifactureState {}

final class CreateNewManifactureLoading extends CreateNewManifactureState {}

final class CreateNewManifactureSuccess extends CreateNewManifactureState {
  final ManufactureModel model;
  CreateNewManifactureSuccess({required this.model});
}

final class CreateNewManifactureError extends CreateNewManifactureState {
  final String errorText;
  CreateNewManifactureError({required this.errorText});
}
