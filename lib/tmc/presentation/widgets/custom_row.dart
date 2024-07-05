
import 'package:flutter/material.dart';

class CustomRow extends StatelessWidget {
  final String title;
  final String text;
  const CustomRow({
    required this.text,
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Text(
            title,
            textAlign: TextAlign.start,
            style: const TextStyle(fontFamily: "SanSerif"),
          ),
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Text(text, style: const TextStyle(fontFamily: "SanSerif")))
      ],
    );
  }
}
