import 'dart:convert';
import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'nav_bar.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SignUpScreenState createState() => _SignUpScreenState();
}
class _SignUpScreenState extends State<SignUpScreen> {

  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> _login(String login , password) async {
    try {
      final response = await post(
        Uri.parse('http://91.210.169.237/account/login/'),
        body: {
          'login' : login,
          'password' : password
        }
      );
  
      print(response.statusCode);
      final err = response.statusCode;
      if(err == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 2),
            content: Text("Вход успешно выполнен"),
          )
        );
        print(data);
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('login', login);
        Navigator.push(context, MaterialPageRoute(builder: (_) =>  NavBar()));
      } else if (err == 401) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final errors= data['detail'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 5),
            content: Text(errors),
          )
        );
      } else if (err == 500) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 5),
            content: const Text('Ошибка связи с сервером, обратитесь к  администратору'),
          )
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 5),
            content: const Text('Ошибка связи с сервером, обратитесь к  администратору'),
          )
        );
      }
    } catch(e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    bool _isPasswordVisible = true;
    return Scaffold(
      backgroundColor: Colors.white,

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
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: loginController,
                autofillHints: const [AutofillHints.username],
                style: TextStyle(color: Colors.black), // Устанавливаем черный цвет введенного текста
                decoration: InputDecoration(
                  labelText: 'Логин',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.login, color: Colors.blue),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextFormField(
                controller: passwordController,
                obscureText: !_isPasswordVisible,
                style: TextStyle(color: Colors.black), // Устанавливаем черный цвет введенного текста

                decoration: InputDecoration(
                  labelText: 'Пароль',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.lock, color: Colors.blue),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isPasswordVisible = _isPasswordVisible;
                      });
                    },
                    child: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.black45,
                    ),
                  ),
                ),
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
    color: Colors.blue, 
    borderRadius: BorderRadius.circular(20)
  ),
  child: TextButton(
    onPressed: () {
      _login(loginController.text.toString(), passwordController.text.toString());
    },
    child: const Text(
      'Вход',
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