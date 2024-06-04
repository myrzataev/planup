// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:quickalert/quickalert.dart';

// import 'nav_bar.dart';

// class Pay extends StatefulWidget {
//   Pay({
//     Key? key,
//     required this.fio,
//     required this.licevoi,
//   }) : super(key: key);

//   final String licevoi;
//   final String fio;

//   @override
//   State<Pay> createState() => _PayState();
// }

// class _PayState extends State<Pay> {
//   bool isLoading = false;
//   TextEditingController moneyController = TextEditingController();

//   // ignore: non_constant_identifier_names
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text("Оплата Скайнет"),
//         leading: GestureDetector(
//           onTap: () {
//             Navigator.of(context).pushReplacement(new MaterialPageRoute(
//                 builder: (BuildContext context) => NavBar()));
//           },
//           child: Icon(
//             Icons.home_filled, // add custom icons also
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.only(top: 60.0),
//               child: Center(
//                 child: Container(
//                     width: 200,

//                     /*decoration: BoxDecoration(
//                         color: Colors.red,
//                         borderRadius: BorderRadius.circular(50.0)),*/
//                     child: Image.asset('asset/images/logo.png')),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 10.0),
//               child: Center(
//                 child: Container(
//                   height: 5,
//                 ),
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 15),
//               width: 800,
//               child: Text(
//                 'Лицевой счет: ${widget.licevoi}',
//                 textAlign: TextAlign.left,
//                 style: TextStyle(fontSize: 25, color: Colors.black),
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 15),
//               width: 800,
//               child: Text(
//                 'Ф.И.О: ${widget.fio}',
//                 textAlign: TextAlign.left,
//                 style: TextStyle(fontSize: 25, color: Colors.black),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 10.0),
//               child: Center(
//                 child: Container(
//                   height: 5,
//                 ),
//               ),
//             ),
//             Padding(
//               //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
//               padding: EdgeInsets.symmetric(horizontal: 15),
//               child: TextField(
//                 controller: moneyController,
//                 style: TextStyle(
//                     color: Colors
//                         .black), // Устанавливаем черный цвет введенного текста

//                 decoration: InputDecoration(
//                     fillColor: Colors
//                         .grey[800], // Цвет фона для TextField в тёмной теме
//                     hintStyle:
//                         TextStyle(color: Colors.grey), // Цвет подсказки ввода
//                     labelStyle: TextStyle(color: Colors.blue), // Цвет метки
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.blue),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(
//                           color: Colors.black), // Цвет рамки при фокусе
//                     ),
//                     border: OutlineInputBorder(),
//                     labelText: 'Сумма',
//                     hintText: 'Введите сумму'),

//                 keyboardType: TextInputType.number,
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 10.0),
//               child: Center(
//                 child: Container(
//                   height: 5,
//                 ),
//               ),
//             ),
//             Container(
//               height: 50,
//               width: 250,
//               decoration: BoxDecoration(
//                   color: Colors.blue, borderRadius: BorderRadius.circular(20)),
//               child: TextButton(
//                 onPressed: () {
//                   void chek_pay(String money, ls) async {
//                     SharedPreferences prefs =
//                         await SharedPreferences.getInstance();
//                     //Return String

//                     String login = prefs.getString('login') ?? "null";

//                     try {
//                       setState(() {
//                         isLoading = true;
//                       });

//                       Response response = await post(
//                           Uri.parse('http://91.210.169.237/account/abon_pay/'),
//                           body: {
//                             'ls': ls,
//                             'login': login,
//                             'money': money,
//                           });
//                       print(response.statusCode);
//                       if (response.statusCode == 200) {
//                         var data = jsonDecode(utf8.decode(response.bodyBytes));

//                         var status = data['status'];
//                         var err = response.body;

//                         if (status == '0') {
//                           Navigator.of(context).pushReplacement(
//                               new MaterialPageRoute(
//                                   builder: (BuildContext context) => NavBar()));

// // ignore: use_build_context_synchronously
//                           QuickAlert.show(
//                             context: context,
//                             type: QuickAlertType.success,
//                             titleColor: Colors.blue,
//                             confirmBtnText: 'Ок',
//                             title: 'Платеж успешно проведен',
//                             confirmBtnColor: Colors.black,
//                           );
//                         } else {

//                           print("object");

//                           QuickAlert.show(
//                             context: context,
//                             type: QuickAlertType.error,
//                             confirmBtnText: 'ОК',
//                             title: 'Сумма должна быть больше 0',
//                             onCancelBtnTap: () {
//                               // ignore: use_build_context_synchronously
//                               Navigator.of(context).pushReplacement(
//                                   MaterialPageRoute(
//                                       builder: (BuildContext context) =>
//                                          const NavBar()));
//                             },
//                           );

//                         }
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                           duration: Duration(seconds: 5),
//                           content: Text("Неверный формат данных"),
//                         ));
//                       }
//                     } catch (e) {
//                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                         duration: Duration(seconds: 5),
//                         content: Text(
//                             "У вас недостаточно средств для оплаты или отсутствует доступ к оплате"),
//                       ));
//                     }
//                   }

//                   chek_pay(moneyController.text.toString(), widget.licevoi);
//                 },
//                 child: Text(
//                   'Оплатить',
//                   style: TextStyle(color: Colors.white, fontSize: 25),
//                 ),
//               ),
//             ),
//             // ElevatedButton(onPressed: ()async{
//             //    SharedPreferences prefs =
//             //             await SharedPreferences.getInstance();
//             //                                 String login = prefs.getString('login') ?? "null";

//             //   print(login);
//             //   print(moneyController.text.runtimeType);
//             //   print(licevoi);
//             // }, child: Text("fsd"))
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quickalert/quickalert.dart';

import 'nav_bar.dart';

class Pay extends StatefulWidget {
  final String type;
  final bool hasComment;
  Pay(
      {Key? key,
      required this.fio,
      required this.licevoi,
      required this.hasComment,
      required this.type})
      : super(key: key);

  final String licevoi;
  final String fio;

  @override
  State<Pay> createState() => _PayState();
}

class _PayState extends State<Pay> {
  bool isLoading = false;
  TextEditingController moneyController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final now = DateTime.now();

  // ignore: non_constant_identifier_names
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Оплата Скайнет"),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(new MaterialPageRoute(
                builder: (BuildContext context) => const NavBar()));
          },
          child: const Icon(
            Icons.home_filled, // add custom icons also
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
                    width: 200, child: Image.asset('asset/images/logo.png')),
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
              padding: const EdgeInsets.symmetric(horizontal: 15),
              width: 800,
              child: Text(
                'Лицевой счет: ${widget.licevoi}',
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 25, color: Colors.black),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              width: 800,
              child: Text(
                'Ф.И.О: ${widget.fio}',
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 25, color: Colors.black),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: moneyController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    fillColor: Colors.grey[800],
                    hintStyle: const TextStyle(color: Colors.grey),
                    labelStyle: const TextStyle(color: Colors.blue),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    border: const OutlineInputBorder(),
                    labelText: 'Сумма',
                    hintText: 'Введите сумму'),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            widget.hasComment
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Form(
                      key: _formKey,
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextFormField(
                            controller: commentController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Пожалуйста перечислите оборудования';
                              }
                              return null;
                            },
                            maxLines: 10,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                labelText: 'Комментарий',
                                hintText: 'Перечислите оборудование'),
                          )),
                    ))
                : const SizedBox(),
            isLoading
                ? const CircularProgressIndicator() // Show loading indicator when isLoading is true
                : Container(
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)),
                    child: TextButton(
                      onPressed: () {
                        if (widget.hasComment) {
                          if (_formKey.currentState!.validate()) {
                            if (isBetweenProhibitedTime(now)) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Оплата запрещена'),
                                  content: const Text(
                                      'Платежи не принимаются с 23:58 до 00:01. Пожалуйста, повторите попытку позже.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                              return;
                            } else {
                              void chek_pay(String money, String ls) async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                String login =
                                    prefs.getString('login') ?? "null";

                                try {
                                  setState(() {
                                    isLoading = true;
                                  });

                                  Response response = await post(
                                      Uri.parse(
                                          'http://91.210.169.237/account/abon_pay/'),
                                      body: {
                                        'ls': ls,
                                        'login': login,
                                        'money': money,
                                        "service_type": widget.type,
                                        "comment": commentController.text
                                      });
                                  // print(response.statusCode);
                                  if (response.statusCode == 200) {
                                    var data = jsonDecode(
                                        utf8.decode(response.bodyBytes));

                                    var status = data['status'];

                                    if (status == '0') {
                                      Navigator.of(context).pushReplacement(
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  const NavBar()));

                                      QuickAlert.show(
                                        context: context,
                                        type: QuickAlertType.success,
                                        titleColor: Colors.blue,
                                        confirmBtnText: 'Ок',
                                        title: 'Платеж успешно проведен',
                                        confirmBtnColor: Colors.black,
                                      );
                                    } else {
                                      QuickAlert.show(
                                        context: context,
                                        type: QuickAlertType.error,
                                        confirmBtnText: 'ОК',
                                        title: 'Сумма должна быть больше 0',
                                        onCancelBtnTap: () {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          const NavBar()));
                                        },
                                      );
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      duration: Duration(seconds: 5),
                                      content: Text("Неверный формат данных"),
                                    ));
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    duration: Duration(seconds: 5),
                                    content: Text(
                                        "У вас недостаточно средств для оплаты или отсутствует доступ к оплате"),
                                  ));
                                } finally {
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              }

                              chek_pay(moneyController.text.toString(),
                                  widget.licevoi);
                            }
                          }
                        } else {
                          if (isBetweenProhibitedTime(now)) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Оплата запрещена'),
                                content: const Text(
                                    'Платежи не принимаются с 23:58 до 00:01. Пожалуйста, повторите попытку позже'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                            return;
                          } else {
                            void chek_pay(String money, String ls) async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String login = prefs.getString('login') ?? "null";

                              try {
                                setState(() {
                                  isLoading = true;
                                });

                                Response response = await post(
                                    Uri.parse(
                                        'http://91.210.169.237/account/abon_pay/'),
                                    body: {
                                      'ls': ls,
                                      'login': login,
                                      'money': money,
                                      "service_type": widget.type
                                    });
                                // print(response.statusCode);
                                if (response.statusCode == 200) {
                                  var data = jsonDecode(
                                      utf8.decode(response.bodyBytes));

                                  var status = data['status'];

                                  if (status == '0') {
                                    Navigator.of(context).pushReplacement(
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                const NavBar()));

                                    QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.success,
                                      titleColor: Colors.blue,
                                      confirmBtnText: 'Ок',
                                      title: 'Платеж успешно проведен',
                                      confirmBtnColor: Colors.black,
                                    );
                                  } else {
                                    QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.error,
                                      confirmBtnText: 'ОК',
                                      title: 'Сумма должна быть больше 0',
                                      onCancelBtnTap: () {
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        const NavBar()));
                                      },
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    duration: Duration(seconds: 5),
                                    content: Text("Неверный формат данных"),
                                  ));
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  duration: Duration(seconds: 5),
                                  content: Text(
                                      "У вас недостаточно средств для оплаты или отсутствует доступ к оплате"),
                                ));
                              } finally {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            }

                            chek_pay(moneyController.text.toString(),
                                widget.licevoi);
                          }
                        }
                      },
                      child: const Text(
                        'Оплатить',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  bool isBetweenProhibitedTime(DateTime currentTime) {
    final prohibitedStartTime = TimeOfDay(hour: 23, minute: 58);
    final prohibitedEndTime = TimeOfDay(hour: 0, minute: 1);

    // Check if current time is within the prohibited range.
    return prohibitedStartTime.hour <= currentTime.hour &&
            currentTime.hour < prohibitedEndTime.hour ||
        (currentTime.hour == prohibitedStartTime.hour &&
            currentTime.minute >= prohibitedStartTime.minute) ||
        (currentTime.hour == prohibitedEndTime.hour &&
            currentTime.minute < prohibitedEndTime.minute);
  }
}
