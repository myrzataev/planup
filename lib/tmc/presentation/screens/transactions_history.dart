import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:planup/tmc/presentation/widgets/custom_row.dart';

class TransactionsHistoryScreen extends StatelessWidget {
  const TransactionsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffD5E2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xffD5E2F2),
        title: const Text("История транзакций"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      CustomHistoryRow(
                        title: "Тип",
                        text: "Деление",
                      ),
                      CustomHistoryRow(
                        title: "Дата",
                        text: "2024-06-20 10:48",
                      ),
                      CustomHistoryRow(
                        title: "Код",
                        text: "фа2392",
                      ),
                      CustomHistoryRow(
                        title: "Маркировал",
                        text: "Мурат",
                      ),
                      Divider()
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
}

class CustomHistoryRow extends StatelessWidget {
  final String title;
  final String text;
  const CustomHistoryRow({super.key, required this.title, required this.text});

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
            child: Text(text,
                style: const TextStyle(
                    fontFamily: "SanSerif", color: Colors.grey)))
      ],
    );
  }
}


class MyTmcScreen1 extends StatefulWidget {
  const MyTmcScreen1({super.key});

  @override
  State<MyTmcScreen1> createState() => _MyTmcScreenState();
}

class _MyTmcScreenState extends State<MyTmcScreen1> {
  final List<CardModel> cardList = [
    CardModel(title: "Название", text: "Тв приставка"),
    CardModel(title: "Тип", text: "Электроинструмент"),
    CardModel(title: 'Бренд', text: "Tp Link"),
    CardModel(title: "Модель", text: "D-0023"),
    CardModel(title: "Код", text: "ау9212у"),
    CardModel(title: "Цена за единицу", text: "4000"),
    CardModel(title: "Количество", text: "10шт"),
    CardModel(title: "Ответственный", text: "Мурат Мырзатаев")
  ];
  late List<CardModel> cardListCopy;
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    initList();
    super.initState();
  }
@override
  void dispose() {
   controller.dispose();
    super.dispose();
  }
  void initList() {
    cardListCopy = List.from(cardList);
  }

  void sortBySearch(String? searchText) {
    setState(() {
      if (searchText == null || searchText.isEmpty) {
        cardListCopy = List.from(cardList);
      } else {
        cardListCopy = cardList
            .where((element) => element.text.toLowerCase().contains(searchText))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffD5E2F2),
        appBar: AppBar(
          backgroundColor: const Color(0xffD5E2F2),
          title: const Text("Мои материалы"),
        ),
        body: Column(
          children: [
            TextField(
              controller: controller,
              onChanged: (value) {
                sortBySearch(value);
              },
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: cardListCopy.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        GoRouter.of(context).pushNamed("detailedInfo");
                      },
                      child: Card(
                        elevation: 0.7,
                        shadowColor: Colors.black12,
                        color: const Color(0xffEDF5FF),
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomRow(
                                text: cardListCopy[index].text,
                                title: cardListCopy[index].title)),
                      ),
                    );
                  }),
            ),
          ],
        ));
  }
}

class CardModel {
  final String title;
  final String text;

  CardModel({required this.title, required this.text});
}
