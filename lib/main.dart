import 'dart:convert';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:planup/views/start.dart';
import 'firebase_options.dart';
import 'login_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';



Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
  }

  runApp(MyApp());
}
@override
void initState() {
  requestPermission();
  setupFirebaseMessagingListeners();
}



void requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  print('User granted permission: ${settings.authorizationStatus}');


  PermissionStatus galleryStatus = await Permission.photos.status;
  if (galleryStatus.isGranted) {
    print('Доступ к галерее разрешен');
  } else if (galleryStatus.isDenied) {
    // Обработка случая, когда доступ к галерее отклонен
    print('Доступ к галерее отклонен');
  } else {
    // Обработка других случаев (например, когда доступ к галерее навсегда запрещен)
    print('Доступ к галерее неопределен');
  }
}

void setupFirebaseMessagingListeners() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // Handle foreground messages
    // ... (same as previous example)
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    // Handle notification tap
    // ... (same as previous example)
  });
}



class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return       MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark, // Установка тёмной темы
      darkTheme: ThemeData.dark(), // Использование встроенной тёмной темы


      title: 'PlanUp',



      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        // Add other localization delegates you need
      ],
      supportedLocales: [
        const Locale('en', ''), // English
        const Locale('es', ''), // Spanish
        // Add other locales your app supports
      ],
      home: FutureBuilder(
        future: _tryAutoLogin(),
        builder: (context, snapshot) {
          // Check if the future is complete
          if (snapshot.connectionState == ConnectionState.done) {
            // If we have data, it means auto login was successful
            if (snapshot.hasData && snapshot.data ==true) {
              return Start();
            } else {
              return LoginScreen();
              // return Start();
            }
          }
          // While we're waiting, show a progress indicator
          return Scaffold(

            backgroundColor: Color.fromRGBO(25, 11, 54, 1.0),

            body: Center(

              child: Image.asset(
                'asset/images/splash.png', // Путь к вашей картинке в assets
                width: 200, // Установите размеры картинки по вашему усмотрению
                height: 200,
              ),
            ),
          );
        },
      ),
    );
  }
  final storage = FlutterSecureStorage();


  Future<bool> _tryAutoLogin() async {
    try {

      final username = await storage.read(key: 'username');
      final password = await storage.read(key: 'password');



      if (username != null && password != null) {

        final uri = Uri.parse('http://planup.skynet.kg:8000/accounts/mobile_app_login_view/');
        // Content-Type for form data
        final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
        // Encode the body as form data
        final body = {'username': username, 'password': password, 'version': "mobile"};
        try {
          final response = await http.post(uri, headers: headers, body: body);
          if (response.statusCode == 200) {


            PackageInfo packageInfo = await PackageInfo.fromPlatform();
            final storage = FlutterSecureStorage();
            final version = packageInfo.version;
            await storage.write(key: 'version', value: version);
            final data = json.decode(response.body);
            String? token = await FirebaseMessaging.instance.getToken();
            await storage.write(key: 'Token', value: token);
            await storage.write(key: 'user_id', value: data['user_id'].toString());
            await storage.write(key: 'username', value: data['username']);
            await storage.write(key: 'full_name', value: data['full_name']);
            await storage.write(key: 'phone_number', value: data['phone_number']);
            await storage.write(key: 'one_c_code', value: data['one_c_code']);
            await storage.write(key: 'bitrix_id', value: data['bitrix_id']);
            await storage.write(key: 'region', value: data['region']);
            await storage.write(key: 'permission', value: data['permission']);
            await storage.write(key: 'username', value: username);
            await storage.write(key: 'password', value: password);
            final uri = Uri.parse('http://planup.skynet.kg:8000/planup/update_device_token/');
            final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
            final user_id = await storage.read(key: 'user_id');
            final body = {'user_id': user_id,  'token': token};
            final responses = await http.post(uri, headers: headers, body: body);


          }
        } catch (e) {
          // Handle any errors that occur during the request
          print('Error occurred: $e');
        }

        return true;
      }
    } catch (e) {
      print('Error during auto login: $e');
    }
    return false;
  }
}
