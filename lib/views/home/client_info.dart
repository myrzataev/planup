import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import 'package:planup/views/home/work_order_details_screen.dart';

import 'openserviceget.dart';


class Client_info extends StatefulWidget {
  const Client_info({Key? key}) : super(key: key);

  @override
  _Client_infoState createState() => _Client_infoState();
}

class _Client_infoState extends State<Client_info> {
  final TextEditingController _lsController = TextEditingController();
  Map<String, dynamic> _userData = {};
  bool _loading = false; // Переменная для отслеживания состояния загрузки
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _fetchUserData() async {

    setState(() {
      _loading = true; // Устанавливаем состояние загрузки в true
    });
    final url = Uri.parse('http://185.39.79.84:8000/accounts/user_info/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'ls_abonent': _lsController.text}),
    );
    setState(() {
      _loading = false; // Устанавливаем состояние загрузки в false после получения ответа
    });
    if (response.statusCode == 200) {
      setState(() {
        _userData = jsonDecode(utf8.decode(response.bodyBytes)); // Коррекция кодировки
      });
    } else {
      throw Exception('Failed to load user data');
    }
  }

  @override
  Widget build(BuildContext context) {

    List<List<String>> _services = [];
    String _tvPhoneNumber = '';
    String _abonent_phone = '';

    void _parseUserData() {
      if (_userData.containsKey('services')) {
        _services = (_userData['services'] as List).map((item) => [
          item[0].toString(),
          item[1].toString(),
          item[2].toString(),
        ]).toList();
      }
      if (_userData.containsKey('tv_phone_number') && _userData['tv_phone_number'].isNotEmpty) {
        _tvPhoneNumber = _userData['tv_phone_number'][0];
      }

      if (_userData.containsKey('abonent_phone') && _userData['abonent_phone'].isNotEmpty) {
        _abonent_phone = _userData['abonent_phone'][0];
      }


    }



    _parseUserData();
    return Scaffold(
      appBar: AppBar(
        title: Text("Информация об абоненте"),
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
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _lsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Введите номер лицевого счета',
                ),

              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loading ? null : () {
                  _fetchUserData();
                  FocusScope.of(context).unfocus(); // Закрываем клавиатуру
                },
                child: _loading ? CircularProgressIndicator() : Text('Получить информацию'),
              ),

              SizedBox(height: 20),
              if (_userData.isNotEmpty) ...[

                Text('Лицевой счет: ${_userData['ls']}'),
                Divider(), // Разделитель
                Text('Имя: ${_userData['name']}'),
                Divider(), // Разделитель
                Text('Адрес: ${_userData['address'].join(', ')}'),
                Divider(), // Разделитель
                Text('Баланс: ${_userData['balance']}'),
                Divider(), // Разделитель
                Text('Телефон для ТВ: $_tvPhoneNumber'),
                Divider(), // Разделитель
                Text('Контакты: $_abonent_phone'),
                Divider(), // Разделитель
                Text('Услуги:'),


                Divider(), // Разделитель
                for (var service in _services)

                  Text('${service[0]} - ${service[1]} (${service[2]})'),



                Divider(), // Разделитель
              ],
            ],
          ),
        ),
      ),
    );
  }
}