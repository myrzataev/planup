import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:planup/news/data/models/news_list_model.dart';
import 'package:planup/news/data/repository/news_list_model.dart';

part 'news_list_event.dart';
part 'news_list_state.dart';

class NewsListBloc extends Bloc<NewsListEvent, NewsListState> {
  NewsListRepoImpl repoImpl;
  NewsListBloc({required this.repoImpl}) : super(NewsListInitial()) {
    on<NewsListEvent>((event, emit)async {
      emit(NewsListLoading());
      try{
        final result = await repoImpl.getNewsList();
        emit(NewsListSuccess(model: result));
      }catch(e){
          emit(NewsListError(errorText: e.toString()));
      }
    });
  }
}
