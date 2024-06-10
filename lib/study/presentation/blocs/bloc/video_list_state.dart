part of 'video_list_bloc.dart';

@immutable
sealed class VideoListState {}

final class VideoListInitial extends VideoListState {}

final class VideoListLoading extends VideoListState {}

final class VideoListSuccess extends VideoListState {
  final VideoListModel model;
  VideoListSuccess({required this.model});
}

// ignore: must_be_immutable
final class VideoListError extends VideoListState {
  String errorText;
  VideoListError({required this.errorText});
}
