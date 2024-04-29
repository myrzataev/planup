// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class ImageViewPage extends StatelessWidget {
//   final String imageUrl;

//   ImageViewPage({Key? key, required this.imageUrl}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Просмотр изображения'),
//       ),
//       body: WebView(
//         initialUrl: '$imageUrl',
//         javascriptMode: JavascriptMode.unrestricted,
//       ),
//     );
//   }
// }



import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:planup/navigation/webview_navigation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: must_be_immutable
class ImageViewPage extends StatefulWidget {
  final String urlOfWeb;

  const ImageViewPage({Key? key, required this.urlOfWeb,}) : super(key: key);

  @override
  State<ImageViewPage> createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImageViewPage> {
  late final WebViewController controller;
  var loadingPercentage = 0;
  bool showErrorPage = false;

  @override
  void initState() {
    controller = WebViewController()
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              loadingPercentage = 0;
              showErrorPage = false;
            });
          },
          onProgress: (progress) {
            setState(() {
              loadingPercentage = progress;
            });
          },
          onPageFinished: (url) {
            setState(() {
              loadingPercentage = 100;
            });
          },
          onNavigationRequest: (request) {
            if (request.url.startsWith('whatsapp:') ||
                request.url.startsWith('tel:')) {
              // ignore: deprecated_member_use
              launch(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onWebResourceError: (error) {
            showErrorPage = true;
          },
        ),
      )
      ..loadRequest(
        Uri.parse(widget.urlOfWeb),
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted);

    super.initState();
  }

  void blocKScreen() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (Platform.isAndroid) {
        await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
      }
    });
  }

  void unBlock() async {
    if (Platform.isAndroid) {
      await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    }
  }

  @override
  void didChangeDependencies() {
    blocKScreen();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    unBlock();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[Colors.red, Colors.purple],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
          ),
          actions: [NavigationControls(controller: controller)],
          title: const Text('Просмотр изображения'),
        ),
        body: Stack(
          children: [
            showErrorPage
                ? const Center(
                    child: Text("Что то пошло не так, повторите попытку позже"),
                  )
                : WebViewWidget(
                    controller: controller,
                  ),
            if (loadingPercentage < 100)
              LinearProgressIndicator(
                value: loadingPercentage / 100.0,
              ),
          ],
        ));
  }
}
