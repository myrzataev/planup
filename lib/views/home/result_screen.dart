import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String text;

  const ResultScreen({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Разбиваем текст на отдельные строки (предполагается, что каждый MAC-адрес на новой строке)
    List<String> macAddresses = text.split('\n');

    return Scaffold(
      appBar: AppBar(
        title: Text('Результат сканирования'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: macAddresses.map((macAddress) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: SelectableText(macAddress, style: Theme.of(context).textTheme.bodyText1,),
              ),

            ],
          )).toList(),
        ),
      ),
    );
  }
}
