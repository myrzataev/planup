import 'package:planup/study/data/datasource/video_list_ds.dart';
import 'package:planup/study/data/models/video_list_model.dart';
import 'package:planup/study/domain/repository/get_listof_video.dart';

class VideoListRepoimpl implements ListOFVideosRepo{
  VideoListDataSource dataSource;
  VideoListRepoimpl({required this.dataSource});
  @override
  Future<VideoListModel> getVideoList()async {
    return dataSource.getListOfVideos();
  }
}