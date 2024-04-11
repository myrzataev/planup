import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';



class PaymentHistoryScreen extends StatefulWidget {

  


  @override
  _PaymentHistoryScreenState createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  List<dynamic> paymentData = [];
  double totalAmount = 0.0; // Добавленное свойство для хранения общей суммы

  @override
  void initState() {
    super.initState();
    fetchPaymentHistory();
  }

  Future<void> fetchPaymentHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? login = prefs.getString('login');
    final response = await http.post(
      Uri.parse('http://91.210.169.237/account/pay_info/'),
      body: {'login': login},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      print(data);
      double sum = 0.0;

      for (var payment in data) {
        if (payment[3]=="Выполнен") {
          sum += double.tryParse(payment[2].toString()) ??
              0; // Предполагая, что payment[2] - это сумма платежа
        }
      }

      setState(() {
        paymentData = data;
        totalAmount = sum ; // Обновление общей суммы
      });
    }  else{

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 5),
            content: Text("Неверный формат данных"),
          )
      );}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('История платежей'),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Center(child: Text('Всего: $totalAmount сом')),
          ),
        ],
      ),
      body: paymentData.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: paymentData.length,
              itemBuilder: (context, index) {
                final payment = paymentData[index];
                return ListTile(
                  title: Text('Лицевой счет: ${payment[1]}'),
                  subtitle: Text('Дата: ${payment[0].substring(0,payment[0].length - 6)} |\nСтатус: ${payment[3]}' ),
                  trailing: Text('Сумма: ${payment[2]} сом'),
                   
                );
              },
            ),
    );
  }
}
