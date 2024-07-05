import 'package:planup/tmc/data/models/models_model.dart';

abstract class GetModelsListRepo {
  Future<List<GoodsModelsModel>> getModelsList({required String urlRoute});
}
