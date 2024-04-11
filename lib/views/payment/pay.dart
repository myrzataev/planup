import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quickalert/quickalert.dart';

import 'nav_bar.dart';



class Pay extends StatelessWidget {




   Pay({Key? key, required  this.fio, required this.licevoi,}) : super(key: key);
   
  final  String licevoi;
  final  String fio;

  TextEditingController moneyController = TextEditingController();
    
      

  

  // ignore: non_constant_identifier_names
  
    @override
  Widget build(BuildContext context) {
    




    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Оплата Скайнет"),
        
          leading: GestureDetector(
    onTap: () { Navigator
    .of(context)
    .pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => NavBar()));

},
    child: Icon(
      Icons.home_filled,  // add custom icons also
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
           
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset('asset/images/logo.png')),
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
        padding: EdgeInsets.symmetric(horizontal: 15),
        width: 800,
        child: Text(
          'Лицевой счет: $licevoi',
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        width: 800,
        child: Text(
          'Ф.И.О: $fio',
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 25, color: Colors.black),
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
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                  controller: moneyController,
                style: TextStyle(color: Colors.black), // Устанавливаем черный цвет введенного текста

                decoration: InputDecoration(
                    fillColor: Colors.grey[800], // Цвет фона для TextField в тёмной теме
                    hintStyle: TextStyle(color: Colors.grey), // Цвет подсказки ввода
                    labelStyle: TextStyle(color: Colors.blue), // Цвет метки
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), // Цвет рамки при фокусе
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'Сумма',
                    hintText: 'Введите сумму'),
                    
                    keyboardType: TextInputType.number,
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

void chek_pay(String money,ls) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String



  String login = prefs.getString('login') ?? "null";
  
    try{
 
      


Response response = await post(
        Uri.parse('http://91.210.169.237/account/abon_pay/'),
        body: {
          'ls' : ls,
          'login':login,
          'money':money,
       
        }
      );
print(response.statusCode);
      if(response.statusCode == 200){

        
var data = jsonDecode(utf8.decode(response.bodyBytes));

var status = data['status'];
var err = response.body;

if(status == '0')
        {
          Navigator
    .of(context)
    .pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => NavBar()));



// ignore: use_build_context_synchronously
QuickAlert.show(
 context: context,

 type: QuickAlertType.success,
  titleColor: Colors.blue,
  confirmBtnText: 'Ок',
  title: 'Платеж успешно проведен' ,confirmBtnColor: Colors.black,


);


}

  
else{
          print("object");


QuickAlert.show(
 context: context,
 type: QuickAlertType.error,
 confirmBtnText: 'ОК',
  title: 'Платеж  не проведен!',
  
   onConfirmBtnTap: () async {
                  // ignore: use_build_context_synchronously
Navigator
    .of(context)
    .pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => NavBar()));


    },
);
           }

      }
  else{
     
        ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    duration: Duration(seconds: 5),
    content: Text("Неверный формат данных"),
  )
);}
        
    }catch(e){
        
        ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    duration: Duration(seconds: 5),
    content: Text("У вас недостаточно средств для оплаты или отсутствует доступ к оплате"),

  )
);
     
    }
  }
                   
   chek_pay(moneyController.text.toString(),licevoi);
              },
                child: Text(
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
  


}


