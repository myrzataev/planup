
import 'package:flutter/material.dart';

class CustomCategoriesCard extends StatelessWidget {
  final String title;
  final Function onTap;
  const CustomCategoriesCard(
      {super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.15,
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Card(
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: "SanSerif",
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
