
import 'package:dio/dio.dart';
import 'package:planup/study/data/models/video_list_model.dart';

class VideoListDataSource {
  final Dio dio;
  VideoListDataSource({required this.dio});
  Future<VideoListModel> getListOfVideos() async {
    // var auth = 'Basic ${base64Encode(utf8.encode('admin:admin'))}';
    final Response response = await dio.get("/tutorial_list/",
        data: {"username": "admin", "password": "hjvfirf"});
    // options: Options(headers: {"Authorization": auth}));
    return VideoListModel.fromJson(response.data);
  }
}
