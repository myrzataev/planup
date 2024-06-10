import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:planup/news/presentation/blocs/bloc/news_list_bloc.dart';
import 'package:planup/study/presentation/widgets/custom_videocard.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  @override
  void initState() {
    BlocProvider.of<NewsListBloc>(context).add(NewsListEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Новости"),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[Colors.red, Colors.purple],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<NewsListBloc, NewsListState>(
                builder: (context, state) {
                  if (state is NewsListLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is NewsListSuccess) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                          itemCount: state.model.news?.length ?? 0,
                          itemBuilder: (context, index) {
                            DateTime dateTime = DateTime.parse(
                                state.model.news?[index].createdAt.toString() ??
                                    "");

                            // ignore: prefer_is_empty
                            return state.model.news?.length == 0
                                ? const Center(
                                    child: Text("Нет никаких новостей"),
                                  )
                                : InkWell(
                                    child: CustomVideoCard(
                                      time: DateFormat('dd/MM/yy HH:mm')
                                          .format(dateTime.toLocal()),
                                      image:
                                          state.model.news?[index].image ?? "",
                                      title:
                                          state.model.news?[index].title ?? "",
                                      description: state
                                              .model.news?[index].description ??
                                          "",
                                    ),
                                    onTap: () {
                                      GoRouter.of(context)
                                          .pushNamed("news", queryParameters: {
                                        "description": state
                                            .model.news?[index].description,
                                        "image": state.model.news?[index].image,
                                        "title": state.model.news?[index].title,
                                        "time": DateFormat('dd/MM/yy HH:mm')
                                            .format(dateTime.toLocal())
                                      });
                                    },
                                  );
                          }),
                    );
                  } else if (state is NewsListError) {
                    return Center(
                      child: Text(state.errorText),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ));
  }
}
