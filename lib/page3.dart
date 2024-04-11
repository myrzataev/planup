import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class Update extends StatefulWidget {
  const Update({Key? key}) : super(key: key);

  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  bool isDownloading = false;
  double downloadProgress = 0.0;
  String downloadedFilePath = '';

  @override
  void initState() {
    super.initState();
    // _checkVersion вызывается при инициализации, если нужно
    // _checkVersion();
  }

  Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future<void> downloadApk(String url, String fileName) async {
    try {
      Dio dio = Dio();

      Directory tempDir = await getTemporaryDirectory();
      String savePath = '${tempDir.path}/$fileName';

      setState(() {
        isDownloading = true;
        downloadProgress = 0.0;
      });

      await dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              downloadProgress = received / total;
            });
          }
        },
      );

      setState(() {
        downloadedFilePath = savePath;
        isDownloading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Обновление успешно загружено'),
        ),
      );

      final result = await OpenFile.open(savePath);
      print('Open file result: ${result.message}');
    } catch (e) {
      setState(() {
        isDownloading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка  загрузки  обновления'),
        ),
      );

    }
  }

  Future<Map<String, String>?> _checkVersion() async {
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

          final currentVersion = await getAppVersion();

          if (newVersionString != null && newVersionString != currentVersion) {
            return {
              'url': releaseFileUrl!,
              'version': newVersionString
            };
          }
        } else {
          print('Invalid response format: $responseData');
        }
      } else {
        print('Error fetching data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading data: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Обновление")),
      body: Stack(
        children: <Widget>[
          Center(
            child: ElevatedButton(
              onPressed: () async {
                final updateInfo = await _checkVersion();
                if (updateInfo != null) {
                  downloadApk(updateInfo['url']!, 'app_update.apk');
                }
              },
              child: Text("Загрузить обновление"),
            ),
          ),
          if (isDownloading) _buildDownloadingModal(),
        ],
      ),
    );
  }

  Widget _buildDownloadingModal() {
    return Center(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircularProgressIndicator(value: downloadProgress),
              SizedBox(height: 20),
              Text("${(downloadProgress * 100).toStringAsFixed(0)}% загружено"),
            ],
          ),
        ),
      ),
    );
  }
}

// Заглушка для класса HomePage
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Главная страница"),
      ),
      body: Center(
        child: Text("Добро пожаловать на главную страницу!"),
      ),
    );
  }
}
