import 'package:planup/news/data/datasource/news_list_ds.dart';
import 'package:planup/news/data/models/news_list_model.dart';
import 'package:planup/news/domain/repository/get_news_list.dart';

class NewsListRepoImpl implements NewsListRepo {
  NewsListDataSource dataSource;
  NewsListRepoImpl({required this.dataSource});
  @override
  Future<NewsListModel> getNewsList() async {
    return await dataSource.getNewsList();
  }
}
