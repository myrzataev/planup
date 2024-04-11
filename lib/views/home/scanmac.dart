import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:planup/views/home/result_screen.dart';





class Scanmac extends StatefulWidget {
  const Scanmac({super.key});

  @override
  State<Scanmac> createState() => _ScanmacState();
}

class _ScanmacState extends State<Scanmac> with WidgetsBindingObserver {
  bool _isPermissionGranted = false;

  late final Future<void> _future;
  CameraController? _cameraController;

  final textRecognizer = TextRecognizer();

  FlutterTts flutterTts = FlutterTts(); // TTS

  @override
  void initState() {
    super.initState();


    WidgetsBinding.instance.addObserver(this);

    _future = _requestCameraPermission();
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopCamera();
    textRecognizer.close();
    flutterTts.stop(); // TTS Stop
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _stopCamera();
    } else if (state == AppLifecycleState.resumed &&
        _cameraController != null &&
        _cameraController!.value.isInitialized) {
      _startCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        return Stack(
          children: [
            if (_isPermissionGranted)
              FutureBuilder<List<CameraDescription>>(
                future: availableCameras(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    _initCameraController(snapshot.data!);

                    return Center(child: CameraPreview(_cameraController!));
                  } else {
                    return const LinearProgressIndicator();
                  }
                },
              ),
            Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: const Text('Наведите камеру на MAC адрес'),
                centerTitle: true,
              ),
              backgroundColor: _isPermissionGranted ? Colors.transparent : null,
              body: _isPermissionGranted
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(),
                  Container(
                    color: Theme.of(context).colorScheme.inverseSurface,
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        onPressed: _scanImage,
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all<Size>(
                            const Size(256, 64), // Set the desired width and height
                          ),
                        ),
                        child: const Text('Сканировать МАС-адрес'),
                      ),
                    ),
                  ),
                ],
              )
                  : Center(
                child: Container(
                  padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                  child: const Text(
                    'Camera permission denied',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    _isPermissionGranted = status == PermissionStatus.granted;
  }

  void _startCamera() {
    if (_cameraController != null) {
      _cameraSelected(_cameraController!.description);
    }
  }

  void _stopCamera() {
    if (_cameraController != null) {
      _cameraController?.dispose();
    }
  }

  void _initCameraController(List<CameraDescription> cameras) {
    if (_cameraController != null) {
      return;
    }

    // Select the first rear camera.
    CameraDescription? camera;
    for (var i = 0; i < cameras.length; i++) {
      final CameraDescription current = cameras[i];
      if (current.lensDirection == CameraLensDirection.back) {
        camera = current;
        break;
      }
    }

    if (camera != null) {
      _cameraSelected(camera);
    }
  }

  Future<void> _cameraSelected(CameraDescription camera) async {
    _cameraController = CameraController(
      camera,
      ResolutionPreset.ultraHigh,
      enableAudio: false,

    );

    await _cameraController!.initialize();
    await _cameraController!.setFlashMode(FlashMode.torch);

    if (!mounted) {
      return;
    }
    setState(() {});
  }
  Future<void> _scanImage() async {
    if (_cameraController == null) return;

    final navigator = Navigator.of(context);

    try {
      final pictureFile = await _cameraController!.takePicture();
      final file = File(pictureFile.path);
      final inputImage = InputImage.fromFile(file);
      final recognizedText = await textRecognizer.processImage(inputImage);
      final RegExp macAddressRegExp = RegExp(
          r'((?:[0-9A-Fa-f]{2}[:\-\s]?){5}(?:[0-9A-Fa-f]{2}))',
          caseSensitive: false
      );

      // Использование обновленного регулярного выражения для поиска MAC-адресов
      final Iterable<RegExpMatch> matches = macAddressRegExp.allMatches(recognizedText.text);

      // Формирование строки с найденными MAC-адресами
      final List<String> macAddresses = matches.map((match) {
        // Удаление всех не-алфавитно-цифровых символов для нормализации
        String rawMac = match.group(0)!.replaceAll(RegExp(r'[^0-9A-Fa-f]'), '');
        // Вставка ":" для форматирования MAC-адреса
        return formatMacAddress(rawMac);
      }).toList();

      if (macAddresses.isEmpty) {
        // Если MAC-адреса не найдены, выводим сообщение
        await navigator.push(MaterialPageRoute(builder: (context) => ResultScreen(text: "MAC-адреса не найдены.")));
      } else {
        // Если найдены, выводим их
        String filteredText = macAddresses.join('\n');
// Когда сканирование завершено и у вас есть результаты

        print(filteredText);
        Navigator.pop(context, filteredText);
      //  await navigator.push(MaterialPageRoute(builder: (context) => ResultScreen(text: filteredText)));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred when scanning text: $e')));
    }
  }

// Вспомогательная функция для форматирования MAC-адреса
  String formatMacAddress(String rawMac) {
    Iterable<Match> matches = RegExp(r'.{2}').allMatches(rawMac).toList();
    return matches.map((match) => match.group(0)).join(':').toUpperCase();
  }





}