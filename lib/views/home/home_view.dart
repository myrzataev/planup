import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:go_router/go_router.dart';
import 'package:package_info/package_info.dart';

import 'package:permission_handler/permission_handler.dart';

import '../../page3.dart';


class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}




class _HomeViewState extends State<HomeView> {

  String? username; // Добавляем переменную для хранения username

  @override
  void initState() {
    super.initState();
    getUserData().then((data) {
      setState(() {
        username = data['full_name']; // Устанавливаем username в состояние виджета
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {

    });

  }



  @override
  void dispose() {



    super.dispose();
  }
  Future<Map<String, String?>> getUserData() async {
    final storage = FlutterSecureStorage();
    Map<String, String?> userData = {
      'user_id': await storage.read(key: 'user_id'),
      'username': await storage.read(key: 'username'),
      'full_name': await storage.read(key: 'full_name'),
      'phone_number': await storage.read(key: 'phone_number'),
      'one_c_code': await storage.read(key: 'one_c_code'),
      'bitrix_id': await storage.read(key: 'bitrix_id'),
      'region': await storage.read(key: 'region'),
      'version': await storage.read(key: 'version'),
      // Добавьте другие ключи здесь...
    };
    return userData;
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70), // Установка высоты AppBar
        child: AppBar(

          centerTitle: false,
          title: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: username ?? 'Загрузка...', // Используем username здесь
                  style: TextStyle(fontSize: 22.0, color: Colors.black, fontFamily: 'Gotham'),
                ),
                // ... (остальной код)
              ],
            ),
          ),

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
      ),
      body:SingleChildScrollView(
        child:
        Column(

          children: [

            Container(

              alignment: Alignment.center,
              padding: const EdgeInsets.all(5),
              margin: new EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(

                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,

                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 50,
                    offset: Offset(0, 20), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[

                            Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: 100.0,
                                margin: const EdgeInsets.all(0.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    context.goNamed("openservice");
                                  },




                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(80.0),
                                    ),
                                    padding: EdgeInsets.all(0.0),
                                  ),
                                  child: Ink(
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(width: 1, color: Color(0xFFFD4417)),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: Container(
                                      constraints: BoxConstraints(maxWidth: 150.0, minHeight: 80.0),
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Image.asset(
                                              'images/assets/allrequest.gif', // Укажите путь к вашему изображению
                                              width: 30.0,
                                              height: 30.0,
                                            ),
                                          ),
                                          const Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Наряды",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Gotham'),
                                                textScaler: TextScaler.noScaling,
                                              ),

                                              Text.rich(
                                                TextSpan(
                                                  children: [


                                                      TextSpan(
                                                        text: 'В моем квадрате',
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.black45,
                                                          fontFamily: 'Gotham',
                                                        ),

                                                      ),
                                                  ],
                                                ),
                                                textAlign: TextAlign.center,
                                              ),

                                            ],
                                          ),
                                        ],
                                      ),
                                    ),


                                  ),
                                ),
                              ),



                              const SizedBox(
                                height: 10,

                              ),
                              Container(
                                height: 100.0,
                                margin: const EdgeInsets.all(5.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    context.goNamed("myservices");
                                  }, // Замените на ваш собственный виджет для страницы оплаты},
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    padding: EdgeInsets.all(0.0),
                                  ),
                                  child: Ink(
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(width: 1, color: Color(0xFFFD4417)),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: Container(
                                      constraints: BoxConstraints(maxWidth: 150.0, minHeight: 80.0),
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 8.0),
                                            child: Image.asset(
                                              'images/assets/myrequest.gif', // Укажите путь к вашему изображению
                                              width: 30.0,
                                              height: 30.0,
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Мои наряды",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Gotham'),
                                                textScaler: TextScaler.noScaling,
                                              ),


                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                  ),
                                ),
                              ),




                            ]),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: 100.0,
                                margin: const EdgeInsets.all(0.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    context.goNamed("closedservice");

                                  },




                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(80.0),
                                    ),
                                    padding: EdgeInsets.all(0.0),
                                  ),
                                  child: Ink(
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(width: 1, color: Color(0xFFFD4417)),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: Container(
                                      constraints: BoxConstraints(maxWidth: 150.0, minHeight: 80.0),
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Image.asset(
                                              'images/assets/3.gif', // Укажите путь к вашему изображению
                                              width: 30.0,
                                              height: 30.0,
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Закрытые наряды",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Gotham'),
                                                textScaler: TextScaler.noScaling,
                                              ),

                                              Text.rich(
                                                TextSpan(
                                                  children: [


                                                    TextSpan(
                                                      text: 'Доступно на 3 дня',
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.black45,
                                                        fontFamily: 'Gotham',
                                                      ),

                                                    ),
                                                  ],
                                                ),
                                                textAlign: TextAlign.center,
                                              ),

                                            ],
                                          ),
                                        ],
                                      ),
                                    ),


                                  ),
                                ),
                              ),



                              const SizedBox(
                                height: 10,

                              ),
                              Container(
                                height: 100.0,
                                margin: const EdgeInsets.all(5.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    context.goNamed("payment");
                                  }, // Замените на ваш собственный виджет для страницы оплаты},
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    padding: EdgeInsets.all(0.0),
                                  ),
                                  child: Ink(
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(width: 1, color: Color(0xFFFD4417)),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: Container(
                                      constraints: BoxConstraints(maxWidth: 150.0, minHeight: 80.0),
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 8.0),
                                            child: Image.asset(
                                              'images/assets/localpay.gif', // Укажите путь к вашему изображению
                                              width: 30.0,
                                              height: 30.0,
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "LocalPay",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Gotham'),
                                                textScaler: TextScaler.noScaling,
                                              ),

                                              Text(
                                                "оплаты по лс",
                                                style: TextStyle(fontSize: 10.0, color: Colors.grey, fontFamily: 'Gotham'),
                                                textScaler: TextScaler.noScaling,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                  ),
                                ),
                              ),




                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: 100.0,
                                margin: const EdgeInsets.all(0.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                  //
                                    //  context.goNamed("createservice");

                                  },




                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(80.0),
                                    ),
                                    padding: EdgeInsets.all(0.0),
                                  ),
                                  child: Ink(
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(width: 1, color: Color(0xFFFD4417)),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: Container(
                                      constraints: BoxConstraints(maxWidth: 150.0, minHeight: 80.0),
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Image.asset(
                                              'images/assets/create.gif', // Укажите путь к вашему изображению
                                              width: 30.0,
                                              height: 30.0,
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Создать наряд",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Gotham'),
                                                textScaler: TextScaler.noScaling,
                                              ),

                                              Text.rich(
                                                TextSpan(
                                                  children: [


                                                    TextSpan(
                                                      text: 'Скоро заработает',
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.black45,
                                                        fontFamily: 'Gotham',
                                                      ),

                                                    ),
                                                  ],
                                                ),
                                                textAlign: TextAlign.center,
                                              ),

                                            ],
                                          ),
                                        ],
                                      ),
                                    ),


                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,

                              ),
                              Container(
                                height: 100.0,
                                margin: const EdgeInsets.all(0.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    context.goNamed("searchclient");

                                  },




                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(80.0),
                                    ),
                                    padding: EdgeInsets.all(0.0),
                                  ),
                                  child: Ink(
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(width: 1, color: Color(0xFFFD4417)),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: Container(
                                      constraints: BoxConstraints(maxWidth: 150.0, minHeight: 80.0),
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Image.asset(
                                              'images/assets/search.gif', // Укажите путь к вашему изображению
                                              width: 30.0,
                                              height: 30.0,
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Мой абонент",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Gotham'),
                                                textScaler: TextScaler.noScaling,
                                              ),

                                              Text.rich(
                                                TextSpan(
                                                  children: [


                                                    TextSpan(
                                                      text: 'Информация об абоненте',
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.black45,
                                                        fontFamily: 'Gotham',
                                                      ),

                                                    ),
                                                  ],
                                                ),
                                                textAlign: TextAlign.center,
                                              ),

                                            ],
                                          ),
                                        ],
                                      ),
                                    ),


                                  ),
                                ),
                              ),








                            ]),











                      ],
                    ),

            ),









          ],

        ),
      ),
    );
  }
}



class NotificationPermissionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text('Enable Notifications'),
      onPressed: () async {
        var status = await Permission.notification.status;
        if (status.isGranted) {
          // Notifications already granted
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Notification permission is already granted."),
          ));
        } else if (status.isDenied) {
          // Directly request the permission
          await Permission.notification.request();
        } else if (status.isPermanentlyDenied) {
          // The user opted not to allow notifications. Open app settings.
          openAppSettings();
        }
      },
    );
  }
}
