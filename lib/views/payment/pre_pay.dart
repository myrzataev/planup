import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:planup/views/payment/choose_payment.dart';
import 'package:planup/views/payment/pay.dart';
import 'nav_bar.dart';

class PrePayPage extends StatefulWidget {
  const PrePayPage({Key? key}) : super(key: key);

  @override
  _PrePayPageState createState() => _PrePayPageState();
}

class _PrePayPageState extends State<PrePayPage> {
  TextEditingController lsController = TextEditingController();

  // ignore: non_constant_identifier_names
  void chek_pay(String ls) async {
    try {
      Response response = await post(
          Uri.parse('http://91.210.169.237/account/check_pay/'),
          body: {
            'ls': ls,
          });
      print(response.statusCode);
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        print(data);
        var fio = data['fio'];
        var status = data['status'];
        if (status == '0') {
          print(ls);
          print(fio);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChoosePaymentScreen(
                        licevoi: lsController.text,
                        fio: fio,
                      )));
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (_) => Pay(
          //               licevoi: lsController.text,
          //               fio: fio,
          //             )));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(seconds: 5),
            content: Text("Не найден ЛС"),
          ));
        }
      } else {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        var err = data['detail'];
        print(err);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 5),
          content: Text("err"),
        ));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NavBar()),
            );
          },
          child: Icon(
            Icons.exit_to_app, // add custom icons also
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset('asset/images/logo.png')),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: lsController,
                style: TextStyle(
                    color: Colors
                        .black), // Устанавливаем черный цвет введенного текста

                decoration: InputDecoration(
                    fillColor: Colors
                        .grey[800], // Цвет фона для TextField в тёмной теме
                    hintStyle:
                        TextStyle(color: Colors.grey), // Цвет подсказки ввода
                    labelStyle: TextStyle(color: Colors.blue),
                    // Цвет метки
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black), // Цвет рамки при фокусе
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'Лицевой счет',
                    hintText: 'Введите лицевой счет'),
                keyboardType: TextInputType.number,
                maxLength: 9,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Center(
                child: Container(
                  height: 5,
                ),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () {
                  chek_pay(lsController.text.toString());
                },
                child: Text(
                  'Продолжить',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
