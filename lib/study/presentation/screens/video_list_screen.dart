import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:planup/study/data/models/video_list_model.dart';
import 'package:planup/study/presentation/blocs/bloc/video_list_bloc.dart';
import 'package:planup/study/presentation/widgets/custom_videocard.dart';

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({super.key});

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  List<Tutorial>? videoDescriptions = [];
  List<Tutorial>? videoDescriptionsCopy = [];
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    BlocProvider.of<VideoListBloc>(context).add(VideoListEvent());
    super.initState();
  }

  void filterBySearch(String? searchQuery) {
    if (searchQuery == null || searchQuery.isEmpty) {
      setState(() {
        videoDescriptionsCopy = videoDescriptions;
      });
    } else {
      setState(() {
        videoDescriptionsCopy = videoDescriptions
            ?.where((element) =>
                element.title
                    ?.toLowerCase()
                    .contains(searchQuery.toLowerCase()) ??
                false)
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Список видеоуроков"),
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
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.06,
                  vertical: 3),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      filterBySearch(value);
                    });
                  },
                  decoration: InputDecoration(
                      hintText: "Поиск по названию",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
              ),
            ),
      
            Expanded(
              child: BlocConsumer<VideoListBloc, VideoListState>(
                builder: (context, state) {
                  if (state is VideoListLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is VideoListSuccess) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                          itemCount: videoDescriptionsCopy?.length ?? 0,
                          // itemCount: state.model.tutorial?.length ?? 0,
                          itemBuilder: (context, index) {
                            DateTime dateTime = DateTime.parse(
                                // state
                                //       .model.tutorial?
                                videoDescriptionsCopy?[index]
                                        .createdAt
                                        .toString() ??
                                    "");

                            return InkWell(
                              child: CustomVideoCard(
                                time: DateFormat('dd/MM/yy HH:mm')
                                    .format(dateTime.toLocal()),
                                image:
                                    videoDescriptionsCopy?[index].image ?? "",
                                title:
                                    videoDescriptionsCopy?[index].title ?? "",
                                description:
                                    videoDescriptionsCopy?[index].description ??
                                        "",
                              ),
                              onTap: () {
                                GoRouter.of(context)
                                    .pushNamed("video", queryParameters: {
                                  "title": videoDescriptionsCopy?[index].title,
                                  "time": DateFormat('dd/MM/yy HH:mm')
                                      .format(dateTime.toLocal()),
                                  "link": videoDescriptionsCopy?[index].video,
                                  "description":
                                      videoDescriptionsCopy?[index].description
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
                listener: (context, state) {
                  if (state is VideoListLoading) {
                  } else if (state is VideoListSuccess) {
                    setState(() {
                      videoDescriptions = state.model.tutorial;
                      videoDescriptionsCopy = List.from(videoDescriptions!);
                    });
                  }
                },
              ),
            ),
          ],
        ));
  }
}
