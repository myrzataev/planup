part of 'news_list_bloc.dart';

@immutable
sealed class NewsListState {}

final class NewsListInitial extends NewsListState {}
final class NewsListLoading extends NewsListState {}
final class NewsListSuccess extends NewsListState {
  final NewsListModel model;
  NewsListSuccess({required this.model});
}
final class NewsListError extends NewsListState {
  final String errorText;
  NewsListError({required this.errorText});
}
