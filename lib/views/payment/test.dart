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



  void login(String login , password) async {




    try{
      
Response response = await post(
        Uri.parse('http://localpay.skynet.kg/account/login/'),

        body: {
          'login' : login,
          'password' : password
        }
      );
  
print(response.statusCode);
var err = response.statusCode;


      if(err== 200){
        const Dialog();
         var data = jsonDecode(utf8.decode(response.bodyBytes));



ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
    duration: Duration(seconds: 2),
    content: Text("Вход успешно выполнен"),
  )
);
print(data);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('login', login);




                  // // ignore: use_build_context_synchronously
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) =>  NavBar()));

      }
      
      else if (err == 401){
           var data = jsonDecode(utf8.decode(response.bodyBytes));
           var errors= data['detail'];
              ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    duration: const Duration(seconds: 5),
    content: Text(errors),
  ));
      }

      else if (err == 500)

{
   

        
   ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    duration: const Duration(seconds: 5),
    content: Text('Ошибка связи с сервером, обратитесь к  администратору'),
  ));}
      
            else 

{
   

        
   ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    duration: const Duration(seconds: 5),
    content: Text('Ошибка связи с сервером, обратитесь к  администратору'),
  ));}
    }catch(e){
      // ignore: avoid_print
      print(e.toString());
    }
  }





    @override
  Widget build(BuildContext context) {



    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Оплата Умные  решения"),

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
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                  controller: loginController,
                     autofillHints: [AutofillHints.username],
                decoration: const InputDecoration(
        
                    border: OutlineInputBorder(),
                    labelText: 'Логин',
                    hintText: 'Введите логин'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(

              controller: passwordController,
                obscureText: true,
                   autofillHints: [AutofillHints.password],
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Пароль',
                    hintText: 'Введите пароль'),
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

                   
   login(loginController.text.toString(), passwordController.text.toString());
              },
                child: const Text(
                  'Войти',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            const SizedBox(
              height: 130,
            ),
            const Text('Тестовая версия IT отдел  Skynet')
          ],
        ),
      ),
    );
  }


  

}