import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';

class ServiceItem {
  final int id;
  final String name;

  ServiceItem({required this.id, required this.name});

  // Функция для создания объекта из JSON
  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    return ServiceItem(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Postservice extends StatefulWidget {
  const Postservice({Key? key, required serviceId}) : super(key: key);

  @override
  _PostserviceState createState() => _PostserviceState();
}

class _PostserviceState extends State<Postservice> {
  final storage = FlutterSecureStorage();
  List<ServiceItem> serviceItems = []; // Список для хранения элементов
  List<ServiceItem> filteredServiceItems = []; // Отфильтрованный список элементов

  @override
  void initState() {
    super.initState();
    _loadWorkOrders();
  }

  Future<void> _loadWorkOrders() async {
    final username = await storage.read(key: 'user_id');
    try {
      final uri = Uri.parse('http://planup.skynet.kg:8000/planup/work_create_mob/');
      final headers = {'Content-Type': 'application/x-www-form-urlencoded'};


      final response = await http.post(uri, headers: headers, );
      print(response.statusCode);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Загрузка данных в список serviceItems
        setState(() {
          serviceItems = List<ServiceItem>.from(data['data'].map((item) => ServiceItem.fromJson(item)));

          // Список названий услуг, которые нужно отобразить
          const allowedNames = {
            "Подключение Чуй",
            "Подключение Талас",
            "Подключение ДЖ",
            "Подключение Нарын",
            "Подключение Ош",
            "Перенос У/З",
            "Установка ТВ",
            "Техпод",
          };

          // Фильтрация serviceItems
          filteredServiceItems = serviceItems
              .where((item) => allowedNames.contains(item.name))
              .toList();

        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 4),
            content: Text("PlanUP сервер не доступен, обратитесь в IT! отдел"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 4),
          content: Text("PlanUP сервер не доступен, обратитесь в IT отдел"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Создать наряд'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[Colors.red, Colors.purple],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Количество столбцов
            crossAxisSpacing: 10, // Горизонтальное пространство между ячейками
            mainAxisSpacing: 10, // Вертикальное пространство между ячейками
            childAspectRatio: 3, // Соотношение сторон ячеек
          ),
          itemCount: filteredServiceItems.length,
          itemBuilder: (context, index) {
            final item = filteredServiceItems[index];
            return Card(
              child: InkWell(
                onTap: () {
                  // Обработка нажатия на элемент
                  print('Нажато на услугу: ${item.name}');
                  print('Нажато на услугу: ${item.id}');

                  // Действия при нажатии на элемент, например, навигация
                },
                child: Center(
                  child: Text(
                    item.name,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
