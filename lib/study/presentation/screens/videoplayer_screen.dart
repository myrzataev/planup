import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoLink;
  final String titleOfCourse;
  final String description;
  final String time;

  const VideoPlayerScreen(
      {Key? key,
      required this.videoLink,
      required this.titleOfCourse,
      required this.description,
      required this.time})
      : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  YoutubePlayerController? controller;

  @override
  void initState() {
    super.initState();
    if (widget.videoLink.isNotEmpty && _isValidUrl(widget.videoLink)) {
      final videoId = YoutubePlayer.convertUrlToId(widget.videoLink);
      if (videoId != null) {
        controller = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
          ),
        );
      } else {
        controller = YoutubePlayerController(
          initialVideoId: YoutubePlayer.convertUrlToId(
                "https://youtu.be/wiDjjB0nx_g?si=7GD2_3R8NUyKNGAb",
              ) ??
              "",
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
          ),
        );
      }
    } else {
      controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(
              "https://youtu.be/wiDjjB0nx_g?si=7GD2_3R8NUyKNGAb",
            ) ??
            "",
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
    }
  }

  bool _isValidUrl(String url) {
    try {
      Uri.parse(url);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        if (orientation == Orientation.landscape) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: youtubeHierarchy(orientation),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.titleOfCourse),
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
            body: youtubeHierarchy(orientation),
          );
        }
      },
    );
  }

  Widget youtubeHierarchy(Orientation orientation) {
    return orientation == Orientation.portrait
        ? SingleChildScrollView(
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: YoutubePlayer(
                    controller: controller ??
                        YoutubePlayerController(
                          initialVideoId: YoutubePlayer.convertUrlToId(
                                "https://youtu.be/wiDjjB0nx_g?si=7GD2_3R8NUyKNGAb",
                              ) ??
                              "",
                          flags: const YoutubePlayerFlags(
                            autoPlay: true,
                            mute: false,
                          ),
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    widget.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    widget.time,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          )
        : Center(
            child: FittedBox(
              fit: BoxFit.fill,
              child: YoutubePlayer(
                controller: controller ??
                    YoutubePlayerController(
                      initialVideoId: YoutubePlayer.convertUrlToId(
                            "https://youtu.be/wiDjjB0nx_g?si=7GD2_3R8NUyKNGAb",
                          ) ??
                          "",
                      flags: const YoutubePlayerFlags(
                        autoPlay: true,
                        mute: false,
                      ),
                    ),
              ),
            ),
          );
  }
}
