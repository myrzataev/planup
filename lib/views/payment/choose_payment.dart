import 'package:flutter/material.dart';
import 'package:planup/views/payment/pay.dart';

class ChoosePaymentScreen extends StatelessWidget {
  final String licevoi;
  final String fio;
  const ChoosePaymentScreen(
      {super.key, required this.fio, required this.licevoi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomPayButton(
              text: "Оплата за услуги связи",
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Pay(
                              fio: fio,
                              licevoi: licevoi,
                              hasComment: false,
                              type: "0",
                            )));
              },
            ),
            CustomPayButton(
              text: "Оплата за оборудование",
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Pay(
                              fio: fio,
                              licevoi: licevoi,
                              hasComment: true,
                              type: "1",
                            )));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CustomPayButton extends StatelessWidget {
  final String text;
  final Function onTap;
  const CustomPayButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
          height: 60,
          width: double.infinity,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () {
                onTap();
              },
              child: Text(
                text,
                style: const TextStyle(color: Colors.white),
              ))),
    );
  }
}
