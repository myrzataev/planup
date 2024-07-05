part of 'create_new_model_bloc.dart';

@immutable
class CreateNewModelEvent {
  final String urlRoute;
  final String nameOfNewModel;
  const CreateNewModelEvent(
      {required this.nameOfNewModel, required this.urlRoute});
}
