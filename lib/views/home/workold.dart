import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:planup/viewimage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';
// import 'package:gallery_saver/gallery_saver.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:planup/views/home/closedservice.dart';



class WorkOrderDetailsScreens extends StatefulWidget {
  final WorkOrder workOrders;

  WorkOrderDetailsScreens({required this.workOrders});

  @override
  _WorkOrderDetailsScreensState createState() => _WorkOrderDetailsScreensState();
}

class _WorkOrderDetailsScreensState extends State<WorkOrderDetailsScreens> {
  List<dynamic> statuses = []; // Объявление списка статусов
  Map<String, String> selectedStatus = {};
  TextEditingController commentController = TextEditingController();
  late List<Widget> detailsWidgets;
  late List<Widget> reportWidgets;
  late List<Widget> reportWidgetsdone;
  late List<Widget> infoWidgets;
  Map<String, File> capturedImages = {}; // Updated to use a Map
  final storage = FlutterSecureStorage();

  Map<String, TextEditingController> reportControllers = {}; // Для хранения контроллеров
  String statusWorkId = ''; // Добавляем переменную состояния для отслеживания статуса работы
  String contact = '';







  Map<String, List<DropdownMenuItem<String>>> enumerationOptions = {}; // Для хранения вариантов выбора
  Map<String, String> selectedValues = {}; // Хранит текущие выбранные значения для выпадающих списков

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




    statusWorkId = widget.workOrders.dynamicFields['status_work_id'].toString();

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

    statusWorkId = widget.workOrders.dynamicFields['status_work_id'].toString();


// ...

// Использование функции в map
    detailsWidgets = (widget.workOrders.dynamicFields['work_fields'] as Map<String, dynamic>).entries
        .where((entry) => !entry.key.contains('Отчет') &&
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
      final cleanedKey = entry.key.replaceFirstMapped(RegExp(r'.UF_CRM.*$'), (match) => '').trim();
      final displayValue = extractNestedValue(entry.value);

      // Проверяем наличие "Ссылка" и "Схема" в данных
      final hasSchema = displayValue.toString().contains('bitrix24');

      final hasLink = displayValue.toString().contains('telegra');

      return ListTile(
        leading: Icon((hasLink || hasSchema) ? Icons.image : Icons.info_outline),
        title: Text(cleanedKey),
        subtitle: Text((hasLink || hasSchema) ? 'Показать' : displayValue.toString()),
        onTap: () {
          if (hasLink) {
            final match = RegExp(r'https?://\S+').firstMatch(displayValue.toString());
            print(match);
            if (match != null) {
              final url = match.group(0);
              _showImageView(url!);
            }
          } else if (hasSchema) {
            final match = RegExp(r'https?://\S+').firstMatch(displayValue.toString());
            if (match != null) {
              final url = match.group(0);
              _showImageDialog(url!);
            }
          }
        },
      );
    }).toList();

    final workDetailsMap = widget.workOrders.dynamicFields['work_fields'] as Map<String, dynamic>;

    infoWidgets = workDetailsMap.entries.expand((entry) {
      final innerMap = entry.value as Map<String, dynamic>;
      return innerMap.entries
          .where((innerEntry) => innerEntry.key.contains('Локация Чуй') ||
          innerEntry.key.contains('Локация Иссык-Куль') ||
          innerEntry.key.contains('Локация Нарын') ||
          innerEntry.key.contains('Локация Ош') ||
          innerEntry.key.contains('Локация Талас') ||
          innerEntry.key.contains('Локация Джалал-Абад') ||
          innerEntry.key.contains('Наименование локации') ||
          innerEntry.key.contains('Адрес') ||
          innerEntry.key.contains('Желаемая дата  приезда') ||
          innerEntry.key.contains('Контакт'))
          .map((innerEntry) {
        final cleanedKey = innerEntry.key.replaceFirstMapped(RegExp(r'.UF_CRM.*$'), (match) => '').trim();
        final displayValue = extractNestedValue(innerEntry.value);
        final value = displayValue.split('|').first;

        if (innerEntry.key.contains('Желаемая дата  приезда')) {
          final dateTimeParts = displayValue.split("T");
          final datePart = dateTimeParts[0];
          final timePart = dateTimeParts[1].substring(0, 5);

          return ListTile(
            leading: Icon(Icons.calendar_today), // Иконка календаря
            title: Text(cleanedKey),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Дата: $datePart'),
                Text('Время: $timePart'),
              ],
            ),
          );
        }
        else if (innerEntry.key.contains('Контакт')) {
          final contactData = innerEntry.value['CONTACT_ID'] ?? {};
          String fio = '';
          List<String> phoneNumbers = [];

          if (contactData is Map) {
            for (var entry in contactData.entries) {
              if (entry.value is List) {
                fio = entry.key; // Предполагаем, что ключ - это ФИО
                phoneNumbers = List<String>.from(entry.value); // Извлекаем номера телефонов
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
                    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      print('Не удалось набрать номер $phoneNumber');
                    }
                  },
                );
              }).toList(),
            ],
          );
        }



        else {
          return ListTile(
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


  Future<void> _showConfirmationDialog(String message, VoidCallback onConfirm) async {
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
                Navigator.of(context).pop(); // Close the dialog without doing anything
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








  void _showImageView(String imageUrl) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ImageViewPage(urlOfWeb: imageUrl),
    ));
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

  @override
  Widget build(BuildContext context) {



    var statusInfo = getStatusMessage(statusWorkId);
    var statusColor = getStatusColor(statusWorkId);

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

    reportWidgetsdone = (widget.workOrders.dynamicFields['work_fields'] as Map<String, dynamic>).entries
        .where((entry) => entry.key.contains('Отчет') ||
        entry.key.contains('фото') )
        .map((entry) {
      final cleanedKey = entry.key.replaceFirstMapped(RegExp(r'.UF_CRM.*$'), (match) => '').trim();
      final displayValue = extractNestedValue(entry.value);

      // Проверяем наличие "Ссылка" и "Схема" в данных


      final hasLink = displayValue.toString().contains('https');

      return ListTile(
        leading: Icon((hasLink ) ? Icons.image : Icons.info_outline),
        title: Text(cleanedKey),
        subtitle: Text((hasLink ) ? 'Показать' : displayValue.toString()),
        onTap: () {
          if (hasLink) {
            final match = RegExp(r'https?://\S+').firstMatch(displayValue.toString());
            print(match);
            if (match != null) {
              final url = match.group(0);
              _showImageView(url!);
            }
          }
        },
      );
    }).toList();



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
                        '$statusInfo  №${widget.workOrders.dynamicFields['id']} ' ,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15, // Уменьшенный размер текста для статуса
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[Colors.red, Colors.purple],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
          ),
          bottom: TabBar(
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (statusWorkId == '3')...[

                      ...reportWidgets, // Include your report widgets
                      SizedBox(height: 20), // Add some spacing between report widgets and images
                      // ElevatedButton(
                      //   onPressed: sendReportData,
                      //   child: Text('Отправить данные отчета'),
                      // ),
                      SizedBox(height: 20), // Add some spacing between button and images
                      // Display captured images
// Display captured images
                      // Display captured images
                      // Display captured images
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: <Widget>[
                      //     ...capturedImages.entries.map((entry) {
                      //       final sendKey = entry.key;
                      //       final imageFile = entry.value;
                      //
                      //       return Image.file(imageFile);
                      //     }).toList(),
                      //   ],
                      // ),





                    ]else if (statusWorkId == '4') ...[
                      ...reportWidgetsdone, // Включите ваши виджеты отчетов для завершенных нарядов
                      SizedBox(height: 20), // Добавьте немного пространства после виджетов отчетов
                      // Здесь могут быть другие виджеты для статуса "Наряд завершен"
                    ]


                  ],
                )



            ),
          ],
        ),


      ),
    );
  }

}
