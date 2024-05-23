import 'package:flutter/material.dart';
import 'package:planup/views/home/see_pdf_screen.dart';

class ChooseSquareScreen extends StatefulWidget {
  final int squareId;
  const ChooseSquareScreen({super.key, required this.squareId});

  @override
  State<ChooseSquareScreen> createState() => _ChooseSquareScreenState();
}

class _ChooseSquareScreenState extends State<ChooseSquareScreen> {
  late List<Squares> squaresList;
  @override
  void initState() {
    squaresList = ChooseSquares.chooseSquare(squareId: widget.squareId);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Карта"),
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
        body: ListView.builder(
          itemCount: squaresList.length ,
          itemBuilder: (context, index) {
            return   Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> PdfScreen(pdfUrl: squaresList[index].urlOfPdf,)));
                },
                child: Container(
                  color: Colors.blue,
                  child:  Text(squaresList[index].nameOfLocation),
                ),
              ),
            );
          },
        ));
  }
}

abstract class ChooseSquares {
  static List<Squares> chooseSquare({required int squareId}) {
    switch (squareId) {
      case 9:
        return [
          Squares(
            nameOfLocation: "Алтын-Ордо протяжка",
            urlOfPdf:
                "https://drive.google.com/uc?export=download&id=1_Vojm2zQrVVnEQykVKwFJQ7sKmZKUqey",
          ),
          Squares(
              nameOfLocation: "Алтын-Ордо протяжка",
              urlOfPdf:
                  "https://drive.google.com/uc?export=download&id=1_Vojm2zQrVVnEQykVKwFJQ7sKmZKUqey")
        ];
      case 11:
        return [
          Squares(
              nameOfLocation: "Бакай-Ата протяжка",
              urlOfPdf:
                  "https://drive.google.com/uc?export=download&id=1mLqqECrXRSblu1djYPcm7ypqFqBFTZ_X"),
          Squares(
              nameOfLocation: "Биримдик-Кут протяжка",
              urlOfPdf:
                  "https://drive.google.com/uc?export=download&id=1T6rXqQsSrZ9eXVxKFQPeSW4Op56Kw-Oy"),
          Squares(
              nameOfLocation: "Биримдик-Кут разварка",
              urlOfPdf:
                  "https://drive.google.com/uc?export=download&id=1yaLqyr5nTdqEofgnW3Q0DeFRga3Ox41-"),
          Squares(
              nameOfLocation: "Карагачевая роща протяжка",
              urlOfPdf:
                  "https://drive.google.com/uc?export=download&id=1txtPPLFuAgzYYODrBhId2wpo9oy8eMEH"),
          Squares(
              nameOfLocation: "Карагачевая роща разварка",
              urlOfPdf:
                  "https://drive.google.com/uc?export=download&id=1p8_8WmZW23f0V3cJnyFxufJN45xz173U"),
          Squares(
              nameOfLocation: "Разварка Аламедин",
              urlOfPdf:
                  "https://drive.google.com/uc?export=download&id=1lJZJ2gmChdD-a0ov6U4FNiPZKXX_sSx8"),
          Squares(
              nameOfLocation: "Разварка Бакай-Ата(чуй)",
              urlOfPdf:
                  "https://drive.google.com/uc?export=download&id=1kZfhpzDnzSWlmbXDqvVstEdG7iqa_MrM")
        ];
      case 10:
        return [
          Squares(
              nameOfLocation: "Джалал-Абад СМУ и Центр протяжка",
              urlOfPdf:
                  "https://drive.google.com/uc?export=download&id=1Z6vQhRQY6IeT6M2lHDYgi_7GlXvvLU5N"),
          Squares(
              nameOfLocation: "Джалал-Абад СМУ и Центр Разварка",
              urlOfPdf:
                  "https://drive.google.com/uc?export=download&id=1A_cVSkqhKvRoDA8pWpzt9bGErZKDP3D8"),
          Squares(
              nameOfLocation: "Курманбек протяжка",
              urlOfPdf:
                  "https://drive.google.com/uc?export=download&id=1Ypm0WeTLZtHtEpgVqCjeFRP8EZnAA5aO")
        ];
      default:
        return [];
    }
  }
}

class Squares {
  final String nameOfLocation;
  final String urlOfPdf;
  Squares({required this.nameOfLocation, required this.urlOfPdf});
}
