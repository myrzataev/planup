import 'package:flutter/material.dart';

class CustomVideoCard extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final String time;
  const CustomVideoCard(
      {super.key,
      required this.image,
      required this.time,
      required this.title,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
      child: Card(
        color: Colors.white,
        shadowColor: Colors.grey.withOpacity(0.5),
        // width: double.infinity,
        // height: 110,
        // decoration: BoxDecoration(boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.5),
        //     spreadRadius: 0.2,
        //     blurRadius: 2,
        //     offset: const Offset(0, 1), // changes position of shadow
        //   ),
        // ], color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Image.network(
                  fit: BoxFit.fill,
                  image,
                  height: 70,
                  width: 70,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      title,
                      style: const TextStyle(fontSize: 25),
                    ),
                    Text(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      description,
                      style: const TextStyle(),
                    ),
                    Row(
                      children: [const SizedBox(), const Spacer(), Text(time)],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
