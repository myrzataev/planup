import 'package:planup/tmc/data/models/models_model.dart';

abstract class CreateNewModelRepo {
  Future<GoodsModelsModel> createNewModel(
      {required String urlRoute, required String nameOfModel});
}
