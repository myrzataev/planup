import 'package:flutter/material.dart';

class NewsScreen extends StatelessWidget {
  final String newsTitle;
  final String image;
  final String newsText;
  final String time;
  const NewsScreen(
      {super.key,
      required this.newsTitle,
      required this.image,
      required this.time,
      required this.newsText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Новости",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              Color(0xffFD4417),
              Color(0xffEC0478),
            ])),
          ),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                newsTitle,
                style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500)
              ),
            ),
            image != null
                ? Padding(
                    padding:
                       const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                    child: Image.network(
                      image,
                      height: 300,
                      width: double.infinity,
                    ),
                  )
                : const SizedBox(
                    height: 30,
                  ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(newsText,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color:  Color(0xff808080)))),
                        Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(time,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color:  Colors.black))),
          ],
        ));
  }
}
