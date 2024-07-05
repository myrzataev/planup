import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:planup/viewimage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:url_launcher/url_launcher.dart';

import 'connecthydra.dart';
import 'myservice.dart';

class WorkOrderDetailsScreen extends StatefulWidget {
  final WorkOrder workOrder;
  final String location;
  final String transferAddress;
  bool isTransering;
  WorkOrderDetailsScreen({
    required this.workOrder,
    required this.location,
    required this.transferAddress,
    this.isTransering = false,
  });

  @override
  _WorkOrderDetailsScreenState createState() => _WorkOrderDetailsScreenState();
}

class _WorkOrderDetailsScreenState extends State<WorkOrderDetailsScreen> {
  // late String? _selectedOption;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> _formKeyForButton = GlobalKey<FormState>();

  List<dynamic> statuses = []; // Объявление списка статусов
  Map<String, String> selectedStatus = {};
  TextEditingController commentController = TextEditingController();
  late List<Widget> detailsWidgets;
  late List<Widget> reportWidgets;
  late List<Widget> reportWidgetsdone;
  late List<Widget> infoWidgets;
  Map<String, File> capturedImages = {}; // Updated to use a Map
  final storage = FlutterSecureStorage();

  Map<String, TextEditingController> reportControllers =
      {}; // Для хранения контроллеров
  String statusWorkId =
      ''; // Добавляем переменную состояния для отслеживания статуса работы
  String contact = '';

  Future<void> _captureImage(String sendKey) async {
    try {
      final ImageSource? source = await _showImageSourceDialog();

      if (source == null) return; // Если пользователь отменил выбор

      final imageFile = await ImagePicker().pickImage(source: source);

      if (imageFile == null) return; // Если пользователь не выбрал изображение

      final capturedImageUrl = imageFile.path;

      // Сохранение изображения в галерее, если оно было сделано камерой
      if (source == ImageSource.camera) {
        await GallerySaver.saveImage(capturedImageUrl);
      }

      setState(() {
        capturedImages[sendKey] = File(capturedImageUrl);
        widget.workOrder.dynamicFields[sendKey] = capturedImageUrl;
      });
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  Future<ImageSource?> _showImageSourceDialog() async {
    return showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Выберите источник изображения'),
        actions: [
          TextButton(
            child: Text('Камера'),
            onPressed: () => Navigator.pop(context, ImageSource.camera),
          ),
          TextButton(
            child: Text('Галерея'),
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ],
      ),
    );
  }

  Map<String, List<DropdownMenuItem<String>>> enumerationOptions =
      {}; // Для хранения вариантов выбора
  Map<String, String> selectedValues =
      {}; // Хранит текущие выбранные значения для выпадающих списков

  @override
  void initState() {
    super.initState();

    fetchStatuses().then((loadedStatuses) {
      setState(() {
        statuses = loadedStatuses;
      });
    }).catchError((error) {
      // Обработка ошибок, например, показать сообщение пользователю
      print('Error fetching statuses: $error');
    });

    final workFieldsMap =
        widget.workOrder.dynamicFields['work_fields'] as Map<String, dynamic>;

    workFieldsMap.entries.forEach((entry) {
      final innerWorkFieldsMap = entry.value as Map<String, dynamic>;
      innerWorkFieldsMap.entries
          .where((innerEntry) => innerEntry.key.contains('Отчет'))
          .forEach((innerEntry) {
        final sendKey = innerEntry.key;
        final reportData = innerEntry.value;

        if (reportData is Map<String, dynamic>) {
          reportData.forEach((key, value) {
            if (value is List) {
              // Обработка списка значений для dropdown
              List<DropdownMenuItem<String>> items = [
                DropdownMenuItem<String>(
                  value: 'default', // Статическое значение по умолчанию
                  child:
                      Text('Выберите опцию'), // Описание статического элемента
                ),
                ...value.map((item) {
                  final id = item['VALUE'].toString();

                  final text = item['VALUE'].toString();
                  return DropdownMenuItem<String>(
                    value: id,
                    child: Text(text),
                  );
                }).toList()
              ];

              enumerationOptions[sendKey] = items;

              // Установка начального значения в 'default'
              selectedValues[sendKey] = 'default';
            } else {
              // Убедитесь, что value является строкой
              if (value is String) {
                String correctedString = value.replaceAll("'", "\"");

                try {
                  // Десериализация JSON всего один раз
                  List<dynamic> values = json.decode(correctedString);

                  if (values is List) {
                    // Создание списка DropdownMenuItem из декодированного списка
                    List<DropdownMenuItem<String>> items = [
                      DropdownMenuItem<String>(
                        value: 'default',
                        child: Text('Выберите опцию'),
                      ),
                      ...values.map<DropdownMenuItem<String>>((item) {
                        final id = item['VALUE']
                            .toString(); // Используйте 'ID' для value
                        final text = item['VALUE'].toString();
                        return DropdownMenuItem<String>(
                          value: id,
                          child: Text(text),
                        );
                      }).toList(),
                    ];

                    // Сохранение созданных элементов в структуры данных для дальнейшего использования
                    enumerationOptions[sendKey] = items;
                    selectedValues[sendKey] = 'default';
                  } else {
                    // Обработка, если декодированное значение не является списком
                    // print("Декодированное значение не является списком");
                  }
                } catch (e) {
                  // Обработка ошибки десериализации
                  // print("Ошибка при десериализации JSON: $e");
                  reportControllers[sendKey] =
                      TextEditingController(text: value);
                }
              } else {
                // Если value не является строкой, напрямую используем как текст контроллера
                reportControllers[sendKey] =
                    TextEditingController(text: value.toString());
              }
            }
          });
        }
      });
    });

    statusWorkId = widget.workOrder.dynamicFields['status_work_id'].toString();

    String extractNestedValue(dynamic value) {
      // Если значение уже является строкой, просто возвращаем ее
      if (value is String) return value;

      // Если это Map, пробуем извлечь данные
      if (value is Map) {
        // Если Map содержит только один ключ и значение, возвращаем значение
        if (value.length == 1) {
          return extractNestedValue(value.values.first);
        } else {
          // Иначе, преобразуем все пары ключ-значение в строку
          var result = '';
          value.forEach((key, value) {
            // Пропускаем вложенные ключи, которые повторяют внешний
            if (key == value.keys.first) {
              result = extractNestedValue(value.values.first);
            } else {
              result += '$key: ${extractNestedValue(value)}; ';
            }
          });
          return result.trim();
        }
      }

      // Для всех остальных типов данных просто возвращаем toString
      return value.toString();
    }

    statusWorkId = widget.workOrder.dynamicFields['status_work_id'].toString();

// ...

// Использование функции в map
    detailsWidgets =
        (widget.workOrder.dynamicFields['work_fields'] as Map<String, dynamic>)
            .entries
            .where((entry) =>
                !entry.key.contains('Резолюция') &&
                !entry.key.contains('Отчет') &&
                !entry.key.contains('Желаемая дата  приезда') &&
                !entry.key.contains('enumeration') &&
                !entry.key.contains('TYPE_ID') &&
                !entry.key.contains('templates_tip_id') &&
                !entry.key.contains('worker_id') &&
                !entry.key.contains('bitrix_id') &&
                !entry.key.contains('created_at') &&
                !entry.key.contains('type_deal') &&
                !entry.key.contains('Локация Чуй') &&
                !entry.key.contains('Локация Иссык-Куль') &&
                !entry.key.contains('Локация Нарын') &&
                !entry.key.contains('Локация Ош') &&
                !entry.key.contains('Локация Талас') &&
                !entry.key.contains('Локация Джалал-Абад') &&
                !entry.key.contains('Наименование локации') &&
                !entry.key.contains('Адрес') &&
                !entry.key.contains('Контакт') &&
                !entry.key.contains('.status_work') &&
                !entry.key.contains('id') &&
                !entry.key.contains('Тип') &&
                !entry.key.contains('CONTACT_ID'))
            .map((entry) {
      final cleanedKey = entry.key
          .replaceFirstMapped(RegExp(r'.UF_CRM.*$'), (match) => '')
          .trim();
      final displayValue = extractNestedValue(entry.value);

      // Проверяем наличие "Ссылка" и "Схема" в данных
      final hasSchema = displayValue.toString().contains('bitrix24');

      final hasLink = displayValue.toString().contains('telegra');

      return ListTile(
        leading:
            Icon((hasLink || hasSchema) ? Icons.image : Icons.info_outline),
        title: Text(cleanedKey),
        subtitle:
            Text((hasLink || hasSchema) ? 'Показать' : displayValue.toString()),
        onTap: () {
          if (hasLink) {
            final match =
                RegExp(r'https?://\S+').firstMatch(displayValue.toString());
            print(match);
            if (match != null) {
              final url = match.group(0);
              _showImageView(url!);
            }
          } else if (hasSchema) {
            final match =
                RegExp(r'https?://\S+').firstMatch(displayValue.toString());
            if (match != null) {
              final url = match.group(0);
              _showImageDialog(url!);
            }
          }
        },
      );
    }).toList();

    final workDetailsMap =
        widget.workOrder.dynamicFields['work_fields'] as Map<String, dynamic>;

    infoWidgets = workDetailsMap.entries.expand((entry) {
      final innerMap = entry.value as Map<String, dynamic>;
      return innerMap.entries
          .where((innerEntry) =>
              !(innerEntry.key.contains('Локация Чуй') &&
                      entry.value["Локация Чуй"]?["UF_CRM_1675072231"] !=
                          'Не выбрано') &&
                  !(innerEntry.key.contains('Локация Иссык-Куль') &&
                      entry.value["Локация Иссык-Куль"]?["UF_CRM_1675071171"] !=
                          'Не выбрано') &&
                  !(innerEntry.key.contains('Локация Нарын') &&
                      entry.value["Локация Нарын"]?["UF_CRM_1675071012"] !=
                          'Не выбрано') &&
                  !(innerEntry.key.contains('Локация Ош') &&
                      entry.value["Локация Ош"]?["UF_CRM_1675070693"] !=
                          'Не выбрано') &&
                  !(innerEntry.key.contains('Локация Талас') &&
                      entry.value["Локация Талас"]?["UF_CRM_1675070436"] !=
                          'Не выбрано') &&
                  !(innerEntry.key.contains('Локация Джалал-Абад') &&
                      entry.value["Локация Талас"]?["UF_CRM_1675071353"] !=
                          'Не выбрано') &&
                  innerEntry.key.contains('Наименование локации') ||
              innerEntry.key.contains('Адрес') ||
              innerEntry.key.contains('Желаемая дата  приезда') ||
              innerEntry.key.contains('Контакт'))
          .map((innerEntry) {
        final cleanedKey = innerEntry.key
            .replaceFirstMapped(RegExp(r'.UF_CRM.*$'), (match) => '')
            .trim();
        final displayValue = extractNestedValue(innerEntry.value);
        final value = displayValue.split('|').first;

        if (innerEntry.key.contains('Желаемая дата  приезда')) {
          final dateTimeParts = displayValue.split("T");
          final datePart = dateTimeParts[0];
          final timePart = dateTimeParts[1].substring(0, 5);

          return ListTile(
            leading: const Icon(Icons.calendar_today), // Иконка календаря
            title: Text(cleanedKey),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Дата: $datePart'),
                Text('Время: $timePart'),
              ],
            ),
          );
        } else if (innerEntry.key.contains('Контакт')) {
          final contactData = innerEntry.value['CONTACT_ID'] ?? {};
          String fio = '';
          List<String> phoneNumbers = [];

          if (contactData is Map) {
            for (var entry in contactData.entries) {
              if (entry.value is List) {
                fio = entry.key; // Предполагаем, что ключ - это ФИО
                phoneNumbers = List<String>.from(
                    entry.value); // Извлекаем номера телефонов
                break; // Прерываем цикл после обработки первой пары ключ-значение
              }
            }
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: Icon(Icons.person), // Иконка для ФИО
                title: Text('ФИО: $fio'), // Отображаем ФИО
              ),
              ...phoneNumbers.map((phoneNumber) {
                return ListTile(
                  leading: Icon(Icons.phone), // Иконка телефона
                  title: Text(phoneNumber), // Отображаем телефонный номер
                  onTap: () async {
                    launch('tel:${phoneNumber}');
                  },
                );
              }).toList(),
            ],
          );
        } else {
          return widget.isTransering
              ? ListTile(
                  leading: Icon(Icons.location_on), // Иконка местоположения
                  title: Text(cleanedKey),
                  subtitle:
                      Text("${widget.location}, ${widget.transferAddress}"),
                )
              : ListTile(
                  leading: Icon(Icons.location_on), // Иконка местоположения
                  title: Text(cleanedKey),
                  subtitle: Text(value),
                );
        }
      });
    }).toList();
  }

  @override
  void dispose() {
    // Удаляем контроллеры
    reportControllers.forEach((_, controller) => controller.dispose());
    commentController.dispose();
    super.dispose();
  }

  Future<void> _showConfirmationDialog(
      String message, VoidCallback onConfirm) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button to close the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Подтвердите действие'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Отменить'),
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Close the dialog without doing anything
              },
            ),
            TextButton(
              child: Text('Да'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                onConfirm(); // Perform the confirmed action
              },
            ),
          ],
        );
      },
    );
  }

// 2. Integrate Confirmation Dialog in Actions
// Example: Modify the _go method to include confirmation
  void _goWithConfirmation() {
    _showConfirmationDialog(
      'Вы уверены, что хотите выехать?',
      _go, // This is the original action method
    );
  }

  void _pauseWithConfirmation() {
    _showConfirmationDialog(
      'Вы уверены, что хотите приостановить?',
      _pause, // This is the original action method
    );
  }

  void _startWithConfirmation() {
    _showConfirmationDialog(
      'Вы уверены,что хотите начать?',
      _start, // This is the original action method
    );
  }

  // Интеграция метода подтверждения в действия
  void _endWithConfirmation() {
    _showConfirmationDialog(
      'Вы уверены, что хотите завершить наряд?',
      () => _showCompletionDialog(), // Показать диалог завершения наряда
    );
  }

  Future<List<dynamic>> fetchStatuses() async {
    const url = 'http://planup.skynet.kg:8000/planup/planup_resolution/';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['res'] as List<dynamic>;
    } else {
      throw Exception('Failed to load statuses');
    }
  }

  Future<void> _showCompletionDialog() async {
    final statuses = await fetchStatuses();
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Выберите статус завершения'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  title: const Text('Выполнен'),
                  onTap: () {
                    Navigator.of(context).pop();
                    selectedStatus['resolution'] = '1';
                    _showCommentDialog();
                  },
                ),
                ...statuses
                    .where((status) => status['id'] != 100)
                    .map((status) {
                  return ListTile(
                    title: Text(status['name']),
                    onTap: () {
                      Navigator.of(context).pop();
                      selectedStatus['resolution'] = status['id'].toString();
                      _showCommentDialog();
                    },
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  // Метод для отображения диалога ввода комментария
  Future<void> _showCommentDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Введите комментарий'),
          content: TextField(
            controller: commentController,
            decoration: InputDecoration(hintText: "Комментарий"),
            autofocus: true,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Отправить'),
              onPressed: () {
                if (commentController.text.trim().isNotEmpty) {
                  Navigator.of(context)
                      .pop(); // Закрыть диалог перед отправкой данных
                  sendReportData();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Пожалуйста, введите комментарий.'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> sendReportData() async {
    var dio = Dio();
    var formData = FormData();
    BuildContext? dialogContext; // Контекст для диалога

    // Отображение диалога с индикатором загрузки
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContext = context; // Сохраняем контекст диалога
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Отправка данных..."),
              ],
            ),
          ),
        );
      },
    );
    final username = await storage.read(key: 'user_id');
    // Добавление текстовых полей
    formData.fields
      ..add(MapEntry('user_id', '$username'))
      ..add(MapEntry(
          'naryd_id', widget.workOrder.dynamicFields['id'].toString()));

    // Добавление текстовых полей из reportControllers

    // Добавление выбранных значений из выпадающих списков
    // selectedValues.forEach((key, value) {
    //   formData.fields.add(MapEntry(key, value));
    // });

    formData.fields.add(MapEntry('resolution', selectedStatus['resolution']!));

    formData.fields.add(MapEntry('comment', commentController.text));

    selectedValues.forEach((key, value) {
      formData.fields.add(MapEntry(key, value));
    });
    reportControllers.forEach((key, controller) {
      formData.fields.add(MapEntry(key, controller.text));
    });

    // Добавление изображений (файлов) без изменений
    capturedImages.forEach((fileKey, file) {
      // Добавление выбранных значений из выпадающих списков

      if (file != null) {
        print(file);
        formData.files.add(MapEntry(
          '$fileKey', // Основной ключ 'image'
          MultipartFile.fromFileSync(
            file.path,
            filename: file.path.split('/').last,
          ),
        ));
      }
    });
    print('Отправка запроса с файлами: ${formData.files.length} файл(ов)');

    // Вывод информации о том, что отправляется
    formData.fields.forEach((field) {
      print('Sending Field: ${field.key} - ${field.value}');
    });

    formData.files.forEach((file) {
      print('Sending File: ${file.key} - ${file.value.filename}');
    });

    try {
      var response = await dio.post(
        'http://planup.skynet.kg:8000/planup/planup_ended/',
        data: formData,
      );

      // Вывод ответа сервера
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Отчет успешно  отправлен'),
          ),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка отправки отчета,сервер не доступен'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка отправки отчета, попробуйте  еще раз'),
        ),
      );
    } finally {
      if (dialogContext != null) {
        Navigator.of(dialogContext!).pop(); // Закрывает только диалог
      }
    }
  }

  void _showImageView(String imageUrl) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ImageViewPage(
        urlOfWeb: imageUrl,
      ),
    ));
  }

  Future<void> _start() async {
    final currentContext = context; // Capture the current BuildContext
    final username = await storage.read(key: 'user_id');
    try {
      final uri =
          Uri.parse('http://planup.skynet.kg:8000/planup/planup_start/');
      final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
      final body = {
        'user_id': '$username',
        'naryd_id': '${widget.workOrder.dynamicFields['id']}'
      };
      print(body);
      final response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          statusWorkId = "3";
          getStatusMessage("3"); // Обновление статуса
          // Тут добавьте код для обновления других данных в виджете
        });
        // Показать Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Статус успешно сменен'),
          ),
        );

        DefaultTabController.of(currentContext)!
            .animateTo(1); // Selects the second tab (index 1)
      } else {
        print('Ошибка при запросе данных: ${response.statusCode}');
      }
    } catch (e) {
      print('Ошибка при загрузке данных: $e');
    }
  }

  Future<void> _go() async {
    final username = await storage.read(key: 'user_id');
    try {
      final uri = Uri.parse('http://planup.skynet.kg:8000/planup/planup_go/');
      final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
      final body = {
        'user_id': '$username',
        'naryd_id': '${widget.workOrder.dynamicFields['id']}'
      };
      final response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Статус успешно сменен')),
        );
        setState(() {
          statusWorkId = "2";
          getStatusMessage("3"); // Обновление статуса
          // Тут добавьте код для обновления других данных в виджете
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка смены статуса Выехать')),
        );
      }
    } catch (e) {
      // Обработка исключений
    }
  }

  Future<void> _pause() async {
    final username = await storage.read(key: 'user_id');
    try {
      final uri =
          Uri.parse('http://planup.skynet.kg:8000/planup/planup_stoped/');
      final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
      final body = {
        'user_id': '$username',
        'naryd_id': '${widget.workOrder.dynamicFields['id']}'
      };

      final response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          statusWorkId = "5";
          getStatusMessage("5"); // Обновление статуса
          // Тут добавьте код для обновления других данных в виджете
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Статус успешно сменен'),
          ),
        );
      } else {
        print('Ошибка при запросе данных: ${response.statusCode}');
      }
    } catch (e) {
      print('Ошибка при загрузке данных: $e');
    }
  }

  void _showImageDialog(String imageUrl) async {
    final url = '$imageUrl';
    try {
      final file = await DefaultCacheManager().getSingleFile(url);
      final imageBytes = await file.readAsBytes();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pop(); // Close the dialog when tapped
            },
            child: AlertDialog(
              contentPadding: EdgeInsets.zero, // Remove padding
              content: InteractiveViewer(
                boundaryMargin: EdgeInsets.all(20.0),
                minScale: 0.1,
                maxScale: 4.0,
                child: Image.memory(imageBytes),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print('Ошибка при загрузке изображения: $e');
      // Обработка ошибок загрузки
    }
  }

  String getStatusMessage(String statusWorkId) {
    switch (statusWorkId) {
      case '1':
        return 'Наряд не начат';
      case '2':
        return 'В пути';
      case '3':
        return 'Наряд начат';
      case '4':
        return 'Наряд завершен';
      case '5':
        return 'Наряд приостановлен';
      default:
        return 'Неизвестный статус';
    }
  }

  Color getStatusColor(String statusWorkId) {
    switch (statusWorkId) {
      case '1':
        return Colors.red;
      case '2':
        return Colors.orange;
      case '3':
        return Colors.lime;
      case '4':
        return Colors.green;
      case '5':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  // late String? _errorText;
  @override
  Widget build(BuildContext context) {
    var statusInfo = getStatusMessage(statusWorkId);
    var statusColor = getStatusColor(statusWorkId);
    reportWidgets =
        (widget.workOrder.dynamicFields['work_fields'] as Map<String, dynamic>)
            .entries
            .where((entry) => entry.key.contains('Отчет'))
            .map((entry) {
      final displayedKey = entry.key
          .replaceFirstMapped(RegExp(r'.UF_CRM.*$'), (match) => '')
          .trim();
      final sendKey = entry.key
          .replaceFirstMapped(RegExp(r'^.*UF'), (match) => 'UF')
          .trim();

      final isPhoto = entry.key.contains('фото');
      final isNumpad = entry.key.contains('ODF') ||
          !entry.key.contains('работы') ||
          entry.key.contains('ОВ1') ||
          entry.key.contains('UTP') ||
          entry.key.contains('Лицевой счет') ||
          entry.key.contains('Коннектор') ||
          entry.key.contains('Кронштейн') ||
          entry.key.contains('муфте') ||
          entry.key.contains('RCA') ||
          entry.key.contains('оплаченная');
      final isShowUrls = entry.value is String && entry.value.contains('https');

      if (isPhoto) {
        // Обработка полей с фотографиями
        return ListTile(
          leading: Icon(Icons.camera_alt),
          title: Text(displayedKey),
          subtitle: widget.workOrder.dynamicFields[sendKey] != null
              ? Image.file(File(widget.workOrder.dynamicFields[
                  sendKey])) // Show the captured image if available
              : Text('Сделать фото'),
          onTap: () {
            _captureImage(sendKey); // Capture an image when tapped
          },
          trailing: widget.workOrder.dynamicFields[sendKey] != null
              ? IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () {
                    _captureImage(
                        sendKey); // Capture an image when the button is pressed
                  },
                )
              : null,
        );
      } else if (isShowUrls) {
        return ListTile(
          leading: Icon(Icons.image),
          title: Text(displayedKey),
          subtitle: Text(entry.value),
          onTap: () {
            if (isShowUrls) {
              _showImageDialog(entry.value);
            }
          },
        );
      } else if (enumerationOptions.containsKey(sendKey)) {
        // Создаем DropdownButtonFormField
        return Column(
          children: [
            ListTile(
              title: DropdownButtonFormField<String>(
                validator: (value) {
                  if (value == null || value.isEmpty || value == "default") {
                    return "Пожалуйста заполните все поля";
                  }
                  return null;
                },
                value: selectedValues[sendKey],
                style: TextStyle(
                    overflow: TextOverflow.ellipsis, color: Colors.black),
                onChanged: (newValue) {
                  print(newValue);
                  setState(() {
                    selectedValues[sendKey] = newValue ?? '';
                    // _errorText = null;
                  });
                },
                items: enumerationOptions[sendKey],
                // hint: Text("choose"),
                decoration: InputDecoration(
                  labelText: sendKey,
                ),
              ),
            ),
            // _errorText != null
            //     ? Text(
            //         _errorText ?? "",
            //         style: const TextStyle(color: Colors.red),
            //       )
            //     : const SizedBox()
          ],
        );
      } else if (isNumpad) {
        // Создаем TextFormField
        return ListTile(
          title: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Пожалуйста заполните все поля";
              }
              return null;
            },

            controller: reportControllers[sendKey],
            decoration: InputDecoration(labelText: sendKey),
            keyboardType:
                TextInputType.number, // Устанавливаем числовую клавиатуру
          ),
        );
      } else {
        // Создаем TextFormField
        return ListTile(
          title: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Пожалуйста заполните все поля";
              }
              return null;
            },
            controller: reportControllers[sendKey],
            decoration: InputDecoration(labelText: sendKey),
          ),
        );
      }
    }).toList();
    // String extractNestedValue(dynamic value) {
    //   // Если значение уже является строкой, просто возвращаем ее
    //   if (value is String) return value;
    //
    //   // Если это Map, пробуем извлечь данные
    //   if (value is Map) {
    //     // Если Map содержит только один ключ и значение, возвращаем значение
    //     if (value.length == 1) {
    //       return extractNestedValue(value.values.first);
    //     } else {
    //       // Иначе, преобразуем все пары ключ-значение в строку
    //       var result = '';
    //       value.forEach((key, value) {
    //         // Пропускаем вложенные ключи, которые повторяют внешний
    //         if (key == value.keys.first) {
    //           result = extractNestedValue(value.values.first);
    //         } else {
    //           result += '$key: ${extractNestedValue(value)}; ';
    //         }
    //       });
    //       return result.trim();
    //     }
    //   }
    //
    //   // Для всех остальных типов данных просто возвращаем toString
    //   return value.toString();
    // }

    // reportWidgetsdone = (widget.workOrder.dynamicFields['work_fields'] as Map<String, dynamic>).entries
    //     .where((entry) => entry.key.contains('Отчет') ||
    //     entry.key.contains('фото') )
    //     .map((entry) {
    //   final cleanedKey = entry.key.replaceFirstMapped(RegExp(r'.UF_CRM.*$'), (match) => '').trim();
    //   final displayValue = extractNestedValue(entry.value);
    //
    //   // Проверяем наличие "Ссылка" и "Схема" в данных
    //
    //
    //   final hasLink = displayValue.toString().contains('https');
    //
    //   return ListTile(
    //     leading: Icon((hasLink ) ? Icons.image : Icons.info_outline),
    //     title: Text(cleanedKey),
    //     subtitle: Text((hasLink ) ? 'Показать' : displayValue.toString()),
    //     onTap: () {
    //       if (hasLink) {
    //         final match = RegExp(r'https?://\S+').firstMatch(displayValue.toString());
    //         print(match);
    //         if (match != null) {
    //           final url = match.group(0);
    //           _showImageView(url!);
    //         }
    //       }
    //     },
    //   );
    // }).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(

                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        '$statusInfo  №${widget.workOrder.dynamicFields['id']} ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15, // Уменьшенный размер текста для статуса
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.workOrder.dynamicFields['type_deal'] == 'Подключение')
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue, // Цвет текста на кнопке
                    padding: EdgeInsets.symmetric(
                        vertical: 5, horizontal: 5), // Отступы внутри кнопки
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10)), // Форма кнопки
                    textStyle:
                        TextStyle(fontSize: 16), // Стиль текста на кнопке
                  ),
                  onPressed: () {
                    String extractNestedData(Map<dynamic, dynamic> data,
                        String outerKey, String innerKey) {
                      if (data.containsKey(outerKey)) {
                        var outerData = data[outerKey];
                        if (outerData is Map &&
                            outerData.containsKey(outerKey)) {
                          var innerData = outerData[outerKey];
                          if (innerData is Map &&
                              innerData.containsKey(innerKey)) {
                            return innerData[innerKey].toString();
                          }
                        }
                      }
                      return 'Данные не найдены';
                    }

                    String accountNumber = extractNestedData(
                        widget.workOrder.dynamicFields['work_fields'],
                        'Лицевой счет',
                        'UF_CRM_1673255771');
                    if (accountNumber != 'Данные не найдены') {
                      print(accountNumber);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              HydraConnect(accountNumber: accountNumber),
                        ),
                      );
                    } else {
                        Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                             const HydraConnect(accountNumber: ""),
                        ),
                      );
                      // Если 'Лицевой счет' не найден или данные не соответствуют ожидаемому формату
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(
                      //       content: Text(
                      //           'Лицевой счет не найден или данные не соответствуют ожидаемому формату')),
                      // );
                    }
                  },
                  child: Text('Подключить'),
                ),
            ],
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Подробности'),
              Tab(text: 'Отчет'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // "Details" tab
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Card(
                    margin: EdgeInsets.all(5.0),
                    child: Padding(
                      padding: EdgeInsets.all(1.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: infoWidgets,
                      ),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.all(5.0),
                    child: Padding(
                      padding: EdgeInsets.all(1.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: detailsWidgets,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // "Report" tab
            SingleChildScrollView(
                child: // Inside the "Report" tab, where you build the reportWidgets
// Inside the "Report" tab, where you build the reportWidgets
                    // Inside the "Report" tab, where you build the reportWidgets
                    Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (statusWorkId == '3') ...[
                    ...reportWidgets, // Include your report widgets
                    SizedBox(
                        height:
                            20), // Add some spacing between report widgets and images
                    // ElevatedButton(
                    //   onPressed: sendReportData,
                    //   child: Text('Отправить данные отчета'),
                    // ),
                    SizedBox(
                        height:
                            20), // Add some spacing between button and images
                  ] else if (statusWorkId == '4') ...[
                    ...reportWidgetsdone, // Включите ваши виджеты отчетов для завершенных нарядов
                    SizedBox(
                        height:
                            20), // Добавьте немного пространства после виджетов отчетов
                    // Здесь могут быть другие виджеты для статуса "Наряд завершен"
                  ] else ...[
                    // Если статус не '3', показать сообщение
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Для работы с отчетами необходимо перевести наряд в статус "Наряд начат".',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ],
              ),
            )),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Если статус "Наряд не начат" (statusWorkId == '1'), отображаем кнопку "Выехать"
              if (statusWorkId == '1')
                ElevatedButton(
                  onPressed: _goWithConfirmation,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text('Выехать',
                      style: TextStyle(color: Colors.white)),
                ),
              // Если статус "В пути" (statusWorkId == '2'), отображаем кнопку "Начать"
              if (statusWorkId == '2')
                ElevatedButton(
                  onPressed: _startWithConfirmation,
                  child: Text('Начать', style: TextStyle(color: Colors.white)),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              // Если статус "Наряд начат" (statusWorkId == '3'), отображаем кнопки "Приостановить" и "Завершить"
              if (statusWorkId == '3') ...[
                ElevatedButton(
                  onPressed: _pauseWithConfirmation,
                  child: Text('Приостановить',
                      style: TextStyle(color: Colors.white)),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                ),
                ElevatedButton(
                  onPressed: () {
                    // print(_formKey.currentState);
                    // if (_formKey.currentState!.validate()
                    // _formKeyForButton.currentState!.validate()
                    // _selectedOption != null
                    // ) {
                    _endWithConfirmation();
                    // } else {
                    //   // _errorText = 'Please select an option';
                    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    //       content: Text("Пожалуйста заполните все поля")));
                    // }
                  },
                  child:
                      Text('Завершить', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
                // Проверяем, нужно ли добавить вкладку "Подключить абонента"
              ],
              // Если статус "Приостановлен" (statusWorkId == '5'), отображаем кнопку "Начать"
              if (statusWorkId == '5')
                ElevatedButton(
                  onPressed: _startWithConfirmation,
                  child: Text('Начать', style: TextStyle(color: Colors.white)),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
