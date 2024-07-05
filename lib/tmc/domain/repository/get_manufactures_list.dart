import 'package:planup/tmc/data/models/manufacture_model.dart';

abstract class GetManufacturesListRepo {
  Future<List<ManufactureModel>> getManufacturesList({required String urlRoute});
}
