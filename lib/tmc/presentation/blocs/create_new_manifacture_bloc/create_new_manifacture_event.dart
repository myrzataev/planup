part of 'create_new_manifacture_bloc.dart';

@immutable
class CreateNewManifactureEvent {
  final String urlRoute;
  final String nameOfManifacture;
  const CreateNewManifactureEvent(
      {required this.nameOfManifacture, required this.urlRoute});
}
