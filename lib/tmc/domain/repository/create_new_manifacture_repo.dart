import 'package:planup/tmc/data/models/manufacture_model.dart';

abstract class CreateNewManiFactureRepo{
  Future<ManufactureModel> createNewManifacture({required String nameOfManifacture, required String urlRouteForCategory
   });
}