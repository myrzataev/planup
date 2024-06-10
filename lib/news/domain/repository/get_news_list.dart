import 'package:planup/news/data/models/news_list_model.dart';

abstract class NewsListRepo{
  Future<NewsListModel> getNewsList();
}
 