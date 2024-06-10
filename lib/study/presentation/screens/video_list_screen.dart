import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:planup/study/presentation/blocs/bloc/video_list_bloc.dart';
import 'package:planup/study/presentation/widgets/custom_videocard.dart';

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({super.key});

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  @override
  void initState() {
    BlocProvider.of<VideoListBloc>(context).add(VideoListEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Список видеоуроков"),
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
              child: BlocBuilder<VideoListBloc, VideoListState>(
                builder: (context, state) {
                  if (state is VideoListLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is VideoListSuccess) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                          itemCount: state.model.tutorial?.length ?? 0,
                          itemBuilder: (context, index) {
                            DateTime dateTime = DateTime.parse(state
                                    .model.tutorial?[index].createdAt
                                    .toString() ??
                                "");

                            return InkWell(
                              child: CustomVideoCard(
                                time: DateFormat('dd/MM/yy HH:mm')
                                    .format(dateTime.toLocal()),
                                image: state.model.tutorial?[index].image ?? "",
                                title: state.model.tutorial?[index].title ?? "",
                                description:
                                    state.model.tutorial?[index].description ??
                                        "",
                              ),
                              onTap: () {
                                GoRouter.of(context)
                                    .pushNamed("video", queryParameters: {
                                  "title": state.model.tutorial?[index].title,
                                  "time": DateFormat('dd/MM/yy HH:mm')
                                    .format(dateTime.toLocal()),
                                  "link": state.model.tutorial?[index].video,
                                  "description":
                                      state.model.tutorial?[index].description
                                });
                              },
                            );
                          }),
                    );
                  } else if (state is VideoListError) {
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
