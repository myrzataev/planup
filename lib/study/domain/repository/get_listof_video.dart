import 'package:planup/study/data/models/video_list_model.dart';

abstract class ListOFVideosRepo{
  Future<VideoListModel> getVideoList();
}