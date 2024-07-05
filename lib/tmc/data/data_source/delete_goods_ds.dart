import 'package:dio/dio.dart';

class DeleteGoodsDs {
  final Dio dio;
  DeleteGoodsDs({required this.dio});
  Future<void> deleteGoods({required String id}) async {
    await dio.delete("goods/$id");
  }
}
