import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:planup/study/data/models/video_list_model.dart';
import 'package:planup/study/data/repository/video_list_repoimpl.dart';

part 'video_list_event.dart';
part 'video_list_state.dart';

class VideoListBloc extends Bloc<VideoListEvent, VideoListState> {
  VideoListRepoimpl repoimpl;
  VideoListBloc({required this.repoimpl}) : super(VideoListInitial()) {
    on<VideoListEvent>((event, emit) async {
      emit(VideoListLoading());
      try {
        final result = await repoimpl.getVideoList();

        emit(VideoListSuccess(model: result));
      } catch (e) {
        emit(VideoListError(errorText: e.toString()));
      }
    });
  }
}
