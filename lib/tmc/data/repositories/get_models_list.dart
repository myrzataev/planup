import 'package:planup/tmc/data/data_source/get_models_list_ds.dart';
import 'package:planup/tmc/data/models/models_model.dart';
import 'package:planup/tmc/domain/repository/get_models_list.dart';

class GetModelsListRepoImpl implements GetModelsListRepo {
  GetModelsListDs dataSource;
  GetModelsListRepoImpl({required this.dataSource});
  @override
  Future<List<GoodsModelsModel>> getModelsList(
      {required String urlRoute}) async {
    return await dataSource.getModelsList(urlRoute: urlRoute);
  }
}
