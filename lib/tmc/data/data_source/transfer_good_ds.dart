import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:planup/tmc/data/models/transfer_good_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransferGoodDs {
  final Dio dio;
  final SharedPreferences preferences;
  TransferGoodDs({required this.dio, required this.preferences});
  Future<Either<String, TransferGoodModel>> transferGood({
    required String sourceUserId,
    required int destinationUserId,
    required String goodID,
    required String tradeStatusId,
    required String comment,
    // required String statusId
  }) async {
    try {
      final Response response = await dio.post("trades/",
          data: {
            "source_user_id": sourceUserId,
            "destination_user_id": destinationUserId,
            "good_id": goodID,
            "create_date": "string",
            "approved_date": "string",
            "comment": comment,
            "trade_status_id": "1",
            "is_deleted": false
          },
          options: Options(headers: {
            "Authorization": "Bearer ${preferences.getString("bearerToken")}"
          }));
      return Right(TransferGoodModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(e.response?.data["detail"] ?? e.message);
    } catch (_) {
      return const Left("Произошла ошибка");
    }
  }
}
