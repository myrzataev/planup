import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

import 'package:http/http.dart';
import 'package:planup/views/payment/pre_pay.dart';
import 'package:planup/views/payment/signup.dart';
import 'globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auto_reload/auto_reload.dart';

import 'globals.dart';
import 'history.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});
  @override
  NavBarState createState() => NavBarState();
}

class NavBarState extends State<NavBar> {
  String _name = '';
  String _surname = '';
  String _balance = '';
  String _region = '';
  String _availbalance = '';

  @override
  void initState() {
    super.initState();
    getuser();
  }

  Future<void> deleteLoginFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('login');
  }

  void delete() async {
    await deleteLoginFromSharedPreferences();
  }

  Future<void> getuser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String login = prefs.getString('login') ?? "null";

    Response response = await post(
      Uri.parse('http://91.210.169.237/account/personal/'),
      body: {'login': login},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      setState(() {
        _name = data['name'];
        _surname = data['surname'];
        _balance = data['balance'].toString();
        _region = data['region'];
        _availbalance = data['avail_balance'].toString();
      });
    } else {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final errors = data['detail'];
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 5),
        content: Text(errors),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('$_surname $_name'),
            accountEmail: Text(
                "Доступный баланс: $_balance сом \nСумма оплат: $_availbalance \n$_region область"),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  'https://www.pngarts.com/files/6/User-Avatar-in-Suit-PNG.png',
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      'https://img.freepik.com/free-photo/painted-concrete-background_53876-92961.jpg')),
            ),
          ),
          ListTile(
            leading: Icon(Icons.money),
            title: Text('Пополнить лицевой счет'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => PrePayPage()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('История платежей'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => PaymentHistoryScreen()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.close),
            title: Text('Назад'),
            onTap: () {
              context.goNamed("Главная");
              // delete();
              // Navigator.of(context).pushAndRemoveUntil(
              //   MaterialPageRoute(builder: (_) => SignUpScreen()),
              //   (route) => false,
              // );
            },
          ),
          Divider(),
          Text('Версия v1.2')
        ],
      ),
    );
  }
}
