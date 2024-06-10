import 'package:dio/dio.dart';
import 'package:planup/news/data/models/news_list_model.dart';

class NewsListDataSource {
  final Dio dio;
  NewsListDataSource({required this.dio});
  Future<NewsListModel> getNewsList() async {
    final Response response = await dio
        .get("/news_list/", data: {"username": "admin", "password": "hjvfirf"});
    return NewsListModel.fromJson(response.data);
  }
}
