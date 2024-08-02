import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChooseActionScreen extends StatelessWidget {
  const ChooseActionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEDF5FF),
      appBar: AppBar(
        backgroundColor: const Color(0xffEDF5FF),
        title: const Text(
          "Принять/Выдать материал",
          style: TextStyle(fontFamily: "SanSerif", fontWeight: FontWeight.w500),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SizedBox(
            //   width: double.infinity,
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 10),
            //     child: MaterialButton(
            //       onPressed: () {
                    
            //       },
            //       color: Colors.blueAccent,
            //       child: const Text("Принять"),
            //     ),
            //   ),
            // ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: MaterialButton(
                  onPressed: () {
                     GoRouter.of(context).pushNamed("tradeHistory");
                    
                  },
                  color: Colors.blueAccent,
                  child: const Text("Посмотреть историю"),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: MaterialButton(
                  onPressed: () {
                     GoRouter.of(context).pushNamed("myTrades");
                  },
                  color: Colors.green.shade300,
                  child: const Text("Посмотреть список трейдов"),
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
