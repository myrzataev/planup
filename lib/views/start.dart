import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:package_info/package_info.dart';


import '../navigation/app_navigation.dart';
import '../page3.dart';



class Start extends StatelessWidget {
  const Start({super.key});

  @override
  Widget build(BuildContext context) {


    Future<String> getAppVersion() async {

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.version;
    }

    Future<void> _checkVersion() async {

      try {
        final uri = Uri.parse('http://planup.skynet.kg:8000/planup/update/');
        final headers = {'Content-Type': 'application/json'};
        final dio = Dio();

        final response = await dio.get(uri.toString(), options: Options(headers: headers));

        if (response.statusCode == 200) {
          final responseData = response.data;

          if (responseData is List<dynamic> && responseData.isNotEmpty) {
            var updateInfo = responseData[0];
            String? newVersionString = updateInfo['version'];
            String? releaseFileUrl = updateInfo['releases_file'];
            print('File: $releaseFileUrl');

            final currentVersion = await getAppVersion();
            print('Current Version: $currentVersion');
            print('New Version: $newVersionString');
            if (newVersionString != null && newVersionString != currentVersion) {

              Navigator
                  .of(context)
                  .pushReplacement(MaterialPageRoute(builder: (BuildContext context) => Update()));

            }
            else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  duration: Duration(seconds: 4),
                  content: Text("Актуальная  версия приложения "),
                ),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                duration: Duration(seconds: 4),
                content: Text("Ошибка проверки  версии приложения"),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 4),
              content: Text("Сервер обновления недоступен"),
            ),
          );
        }
      } catch (e) {
        print('Error loading data: $e');
      }
    }

    _checkVersion();

    return MaterialApp.router(
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
      title: 'PlanUp',
      debugShowCheckedModeBanner: false,
      routerConfig: AppNavigation.router,
    );
  }
}
