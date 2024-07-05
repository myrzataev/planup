import 'package:planup/tmc/data/data_source/get_manufactures_list_ds.dart';
import 'package:planup/tmc/data/models/manufacture_model.dart';
import 'package:planup/tmc/domain/repository/get_manufactures_list.dart';

class GetManufacturesListRepoImpl implements GetManufacturesListRepo {
  GetManufacturesListDataSource dataSource;
  GetManufacturesListRepoImpl({required this.dataSource});
  @override
  Future<List<ManufactureModel>> getManufacturesList(
      {required String urlRoute}) async {
    return await dataSource.getManufacturesList(urlRoute: urlRoute);
  }
}
