import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';

import 'package:planup/views/home/workold.dart';


class OutfitScreenOld extends StatefulWidget {
  const OutfitScreenOld({Key? key}) : super(key: key);

  @override
  _OutfitScreenOldState createState() => _OutfitScreenOldState();
}

class _OutfitScreenOldState extends State<OutfitScreenOld> {
  List<WorkOrder> workOrders = [];
  DateTime? selectedDate;
  bool _isInit = true;



  @override
  void initState() {
    super.initState();
    _loadWorkOrders();

  }


  @override
  void dispose() {

    super.dispose();
  }
  List<WorkOrder> allWorkOrders = []; // Добавьте переменную для хранения всех заказов
  String? selectedStatus;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _loadWorkOrders();

      _isInit = false;
    }
  }
  final storage = FlutterSecureStorage();



  Future<void> _loadWorkOrders() async {
    final username = await storage.read(key: 'user_id');

    try {
      final uri = Uri.parse('http://planup.skynet.kg:8000/planup/works_status/');
      final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
      final body = {'user_id': '$username'};

      final response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final List<dynamic> works = data['works_status']; // Получение списка заказов из ответа сервера

        setState(() {
          workOrders = works.map((work) => WorkOrder.fromJson(work)).toList();
          allWorkOrders = List.from(workOrders); // Создание копии всех заказов
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 4),
            content: Text("PlanUP сервер не доступен, обратитесь в IT! отдел"),
          ),
        );
      }
    } catch (e) {
      print('Error loading work orders: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 4),
          content: Text("PlanUP сервер не доступен, обратитесь в IT отдел"),
        ),
      );
    }
  }


  void filterWorkOrdersByDate(DateTime date) {
    setState(() {
      selectedDate = date;
      workOrders = allWorkOrders.where((workOrder) {
        return workOrder.created_at.year == date.year &&
            workOrder.created_at.month == date.month &&
            workOrder.created_at.day == date.day;
      }).toList();
    });
  }

  void filterTodayWorkOrders() {
    setState(() {
      selectedDate = DateTime.now();
      workOrders = allWorkOrders.where((workOrder) {
        final now = DateTime.now();
        final created = workOrder.created_at;
        return created.year == now.year &&
            created.month == now.month &&
            created.day == now.day;
      }).toList();
    });
  }


  void filterAllWorkOrders() {
    setState(() {
      selectedDate = null;
      workOrders = List.from(allWorkOrders); // Возвращение к полному списку всех заказов
    });
  }
  void filterWorkOrdersByStatus(String status) {
    setState(() {
      selectedStatus = status;
      if (status.isEmpty) {
        workOrders = List.from(allWorkOrders); // Если статус не выбран, показать все заказы
      } else {
        workOrders = allWorkOrders.where((workOrder) {
          return workOrder.dynamicFields['status_work_id'].toString() == status;
        }).toList();
      }
    });
  }



  Map<String, dynamic> getStatusMessage(String statusId) {
    IconData statusIcon;
    switch (statusId) {
      case '1':
        statusIcon = Icons.error_outline; // Icon for "Не начат"
        return {'message': 'Не начат', 'color': Colors.red, 'icon': statusIcon};
      case '2':
        statusIcon = Icons.directions_bus; // Icon for "В пути"
        return {'message': 'В пути', 'color': Colors.yellow, 'icon': statusIcon};
      case '3':
        statusIcon = Icons.play_arrow; // Icon for "Начат"
        return {'message': 'Начат', 'color': Colors.blue, 'icon': statusIcon};
      case '4':
        statusIcon = Icons.check_circle; // Icon for "Завершен"
        return {'message': 'Завершен', 'color': Colors.green, 'icon': statusIcon};
      case '5':
        statusIcon = Icons.pause_circle; // Icon for "Завершен"
        return {'message': 'Приостановлен', 'color': Colors.yellow, 'icon': statusIcon};
      default:
        statusIcon = Icons.help_outline; // Icon for "Неизвестный статус"
        return {'message': 'Неизвестный статус', 'color': Colors.grey, 'icon': statusIcon};
    }
  }
  Map<String, dynamic> getResolutionMessage(String resolutionId) {
    IconData resolutionIcon = Icons.help_outline; // Дефолтная иконка
    String message = 'Неизвестная резолюция';
    Color color = Colors.grey; // Дефолтный цвет

    switch (resolutionId) {
      case '1':
        resolutionIcon = Icons.check_circle;
        message = 'Выполнен';
        color = Colors.green;
        break;
      case '2':
        resolutionIcon = Icons.cancel_outlined;
        message = 'Не выполнен';
        color = Colors.red;
        break;
      case '3':
        resolutionIcon = Icons.person_off;
        message = 'Отменено абонентом';
        color = Colors.orange;
        break;
      case '4':
        resolutionIcon = Icons.location_off;
        message = 'Далеко от муфты';
        color = Colors.blue;
        break;
      case '5':
        resolutionIcon = Icons.block;
        message = 'Забита муфта';
        color = Colors.brown;
        break;
      case '6':
        resolutionIcon = Icons.block_outlined;
        message = 'Нет опор';
        color = Colors.teal;
        break;
      case '7':
        resolutionIcon = Icons.grid_off;
        message = 'Вне квадрата';
        color = Colors.purple;
        break;
      case '8':
        resolutionIcon = Icons.home;
        message = 'Нет дома';
        color = Colors.deepPurple;
        break;
      case '9':
        resolutionIcon = Icons.do_not_disturb_on;
        message = 'Отказывается возвращать оборудование';
        color = Colors.redAccent;
        break;
      case '10':
        resolutionIcon = Icons.cancel;
        message = 'Отменено из офиса';
        color = Colors.orangeAccent;
        break;
      case '11':
        resolutionIcon = Icons.timer_off;
        message = 'Не успели';
        color = Colors.lightBlue;
        break;
      case '12':
        resolutionIcon = Icons.link;
        message = 'Уже подключен';
        color = Colors.lightGreen;
        break;
      case '13':
        resolutionIcon = Icons.vpn_key;
        message = 'Нет доступа к щиткам/нет ключей от крыши/подвала';
        color = Colors.blueGrey;
        break;
      case '14':
        resolutionIcon = Icons.warning_amber_outlined;
        message = 'Предписание не исполнено';
        color = Colors.brown;
        break;
      default:
        break;
    }

    return {'message': message, 'color': color, 'icon': resolutionIcon};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Закрытые наряды'),
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
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                      locale: const Locale('ru', 'RU'),
                    );
                    if (pickedDate != null) {
                      filterWorkOrdersByDate(pickedDate);
                    }
                  },
                  child: Text(selectedDate == null ? "Выбрать дату" : "Дата: ${DateFormat('dd.MM').format(selectedDate!)}"),
                ),
                ElevatedButton(
                  onPressed: () {
                    filterAllWorkOrders();
                  },
                  child: Text('Все'),
                ),
                ElevatedButton(
                  onPressed: () {
                    filterTodayWorkOrders();
                  },
                  child: Text('Сегодня'),
                ),
              ],
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadWorkOrders,
                child: workOrders.isEmpty
                    ? Center(
                  child: selectedDate == null
                      ? Text('Выберите дату для фильтрации нарядов')
                      : Text('Нет нарядов для выбранной даты'),
                )
                    :ListView.builder(
                  itemCount: workOrders.length,
                  itemBuilder: (context, index) {
                    final workOrder = workOrders[index];
                    String extractLocation(Map<String, dynamic> dynamicFields) {
                      const locationKeys = {
                        'Локация Чуй': 'UF_CRM_1675072231',
                        'Локация Иссык-Куль': 'UF_CRM_1675071171',
                        'Локация Нарын': 'UF_CRM_1675071012',
                        'Локация Ош': 'UF_CRM_1675070693',
                        'Локация Талас': 'UF_CRM_1675070436',
                        'Локация Джалал-Абад': 'UF_CRM_1675071353',
                        'Наименование локации': 'UF_CRM_1678102336',
                      };

                      for (var entry in locationKeys.entries) {
                        final locationLabel = entry.key;
                        final locationId = entry.value;
                        final locationValue = dynamicFields['work_fields'][locationLabel]?[locationLabel]?[locationId];
                        if (locationValue != null && locationValue.isNotEmpty) {
                          return locationValue;
                        }
                      }
                      return 'Не указано';
                    }

                    String location = extractLocation(workOrder.dynamicFields);
                    String executor = workOrder.dynamicFields['work_fields']['Адрес']['Адрес']['UF_CRM_1674993837284'].split('|').first ?? 'Не указано';
                    String accountNumber = workOrder.dynamicFields['status_work_id'].toString() ?? '0';
                    Map<String, dynamic> statusInfo = getStatusMessage(accountNumber);
                    String statusMessage = statusInfo['message'];
                    Color statusColor = statusInfo['color'];

                    // Извлеките информацию о резолюции, если наряд завершен
                    String resolutionId = workOrder.dynamicFields['resolution_work_id']?.toString() ?? 'нет резолюции';
                    Map<String, dynamic> resolutionInfo = getResolutionMessage(resolutionId);
                    bool isCompleted = accountNumber == '4'; // Предположим, что '4' это статус "Завершен"

                    return Card(
                      child: ListTile(
                        title: Text('Наряд: ${workOrder.dynamicFields['type_deal']}'),
                        subtitle: RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(text: 'Локация: $location\nАдрес: $executor\n'),
                              TextSpan(text: 'Статус: $statusMessage', style: TextStyle(color: statusColor)),
                              if (isCompleted) // Показать резолюцию, если наряд завершен
                                TextSpan(text: '\nРезолюция: ${resolutionInfo['message']}', style: TextStyle(color: resolutionInfo['color'])),
                            ],
                          ),
                        ),
                        leading: Icon(
                          isCompleted ? resolutionInfo['icon'] : statusInfo['icon'], // Иконка для резолюции или статуса
                          color: isCompleted ? resolutionInfo['color'] : statusColor, // Цвет для резолюции или статуса
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WorkOrderDetailsScreens( workOrders: workOrder),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),

              ),
            ),
          ],
        ));
  }
}



class WorkOrder {
  final Map<String, dynamic> dynamicFields;
  final DateTime created_at;

  WorkOrder({
    required this.dynamicFields,
    required this.created_at,
  });

  factory WorkOrder.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> fields = json;
// print(fields);
    // Извлечение желаемой даты приезда
    String desiredArrivalDateString = json["works"]?['work_fields']?['Желаемая дата  приезда']?['Желаемая дата  приезда']?['UF_CRM_1673255749']??"2024-03-22T14:24:23+06:00";

    print(desiredArrivalDateString);
    DateTime desiredArrivalDate = DateTime.parse(desiredArrivalDateString);


    return WorkOrder(
      dynamicFields: fields,
      created_at: desiredArrivalDate,
    );
  }
}