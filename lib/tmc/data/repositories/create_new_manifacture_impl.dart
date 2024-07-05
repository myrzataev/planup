import 'package:planup/tmc/data/data_source/create_new_manifacture_ds.dart';
import 'package:planup/tmc/data/models/manufacture_model.dart';
import 'package:planup/tmc/domain/repository/create_new_manifacture_repo.dart';

class CreateNewManifactureImpl implements CreateNewManiFactureRepo {
  CreateNewManifactureDs dataSource;
  CreateNewManifactureImpl({required this.dataSource});
  @override
  Future<ManufactureModel> createNewManifacture(
      {required String nameOfManifacture,
      required String urlRouteForCategory}) async {
    return await dataSource.createNewManifacture(
        name: nameOfManifacture, urlRouteForCategory: urlRouteForCategory);
  }
}
