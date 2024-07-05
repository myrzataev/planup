import 'package:planup/tmc/data/data_source/create_new_model_ds.dart';
import 'package:planup/tmc/data/models/models_model.dart';
import 'package:planup/tmc/domain/repository/create_new_model_repo.dart';

class CreateNewModelImpl implements CreateNewModelRepo {
  CreateNewModelDs dataSource;
  CreateNewModelImpl({required this.dataSource});
  @override
  Future<GoodsModelsModel> createNewModel(
      {required String urlRoute, required String nameOfModel}) async {
    return await dataSource.createNewModel(
        urlRoute: urlRoute, nameOfModel: nameOfModel);
  }
}
