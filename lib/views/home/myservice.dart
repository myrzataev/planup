import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import 'package:planup/views/home/work_order_details_screen.dart';

class OutfitScreen extends StatefulWidget {
  const OutfitScreen({Key? key}) : super(key: key);

  @override
  _OutfitScreenState createState() => _OutfitScreenState();
}

class _OutfitScreenState extends State<OutfitScreen> {
  List<WorkOrder> workOrders = [];
  DateTime? selectedDate;
  bool _isInit = true;
  // late String _lsNumber;
  List<dynamic> listOfLsNumbers = [];
  List<dynamic> listOfLsNumbersCopy = [];

  @override
  void initState() {
    super.initState();
    _loadWorkOrders();
    //  _reloadTimer = Timer.periodic(Duration(seconds: 120), (Timer t) => _loadWorkOrders());
    selectedStatus = 'Не начат';
    setState(() {
      listOfLsNumbersCopy = listOfLsNumbers;
    });
  }
   void filterByLsNumber(String searchText){
    List<dynamic> results = [];
    if(searchText.isEmpty){
      results = listOfLsNumbers;

    }else{
      // results = listOfLsNumbers.where((element) => element.toString().toLowerCase().c)
    }
   }
  @override
  void dispose() {
    //   _reloadTimer?.cancel();
    _loadWorkOrders();

    super.dispose();
  }

  List<WorkOrder> allWorkOrders =
      []; // Добавьте переменную для хранения всех заказов
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
  // Timer? _reloadTimer;

  Future<void> _loadWorkOrders() async {
    final username = await storage.read(key: 'user_id');
    try {
      final uri = Uri.parse('http://planup.skynet.kg:8000/planup/test_point/');
      final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
      final body = {'user_id': '$username'};

      final response = await http.post(uri, headers: headers, body: body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // if (data != null && data['works'] != null) {
        //   for (var work in data['works']) {
        //   var date = work['work_fields']?['Желаемая дата  приезда']?['Желаемая дата  приезда']?['UF_CRM_1673255749'];
        //     if (date != null) {
        //       var workId = work['id']; // Получаем ID работы
        //       print(date);
        //       print(workId);
        //     } else {
        //       print('Дата не найдена или структура данных отличается');
        //     }
        //   }
        // }
        final List<dynamic> works =
            data['works']; // Получение списка заказов из ответа сервера
        // print(works.map((element) => element["work_fields"]["Лицевой счет"]["Лицевой счет"]["UF_CRM_1673255771"]).toList());
        setState(() {
          workOrders = works.map((work) => WorkOrder.fromJson(work)).toList();
          allWorkOrders = List.from(workOrders);
          try {
            listOfLsNumbers = works.map((element) {
              var workFields = element["work_fields"];
              var lsNumber =
                  workFields != null ? workFields["Лицевой счет"] : 0;
              var innerLsNumber = (lsNumber != null && lsNumber != 0)
                  ? lsNumber["Лицевой счет"]
                  : 0;
              var finalValue = (innerLsNumber != null && innerLsNumber != 0)
                  ? innerLsNumber["UF_CRM_1673255771"]
                  : 0;

              if (finalValue != null && finalValue != 0) {
                print(finalValue);
                listOfLsNumbersCopy.add(finalValue);
                return finalValue;
              } else {
                // Handle the case where the value is null, if needed
                return "Не указан"; // or return null
              }
            }).toList();
          } catch (e) {
            print(e);
          }
          // Создание копии всех заказов
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 4),
          content: Text("PlanUP сервер не доступен, обратитесь в IT отдел"),
        ),
      );
    }
  }

  // void filterByLsNumber({required String searchQuery}) {
  //   setState(() {
  //     _lsNumber = searchQuery;
  //   });
  // }

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
      workOrders =
          List.from(allWorkOrders); // Возвращение к полному списку всех заказов
    });
  }

  List<String> statusList = [
    'Все',
    'Не начат',
    'В пути',
    'Начат',
    'Завершен',
    'Приостановлен',
  ];

  void filterWorkOrdersByStatus(String? status) {
    setState(() {
      selectedStatus = status;
      if (status == 'Все') {
        workOrders = List.from(allWorkOrders);
      } else if (status == 'Не начат') {
        workOrders = allWorkOrders.where((workOrder) {
          final statusId = workOrder.dynamicFields['status_work_id'].toString();
          return statusId == '1'; // '1' это идентификатор "Не начат"
        }).toList();
      } else {
        workOrders = allWorkOrders.where((workOrder) {
          final statusId = workOrder.dynamicFields['status_work_id'].toString();
          return statusId == getStatusIdByName(status!);
        }).toList();
      }
    });
  }

  String getStatusIdByName(String statusName) {
    // Метод, который преобразует имя статуса в его идентификатор
    // Например, можно использовать switch/case для этого
    switch (statusName) {
      case 'Не начат':
        return '1';
      case 'В пути':
        return '2';
      case 'Начат':
        return '3';
      case 'Завершен':
        return '4';
      case 'Приостановлен':
        return '5';
      default:
        return ''; // Вернуть пустую строку или другое значение по умолчанию
    }
  }

  Map<String, dynamic> getStatusMessage(String statusId) {
    IconData statusIcon;
    switch (statusId) {
      case '1':
        statusIcon = Icons.error_outline; // Icon for "Не начат"
        return {'message': 'Не начат', 'color': Colors.red, 'icon': statusIcon};
      case '2':
        statusIcon = Icons.directions_bus; // Icon for "В пути"
        return {
          'message': 'В пути',
          'color': Colors.yellow,
          'icon': statusIcon
        };
      case '3':
        statusIcon = Icons.play_arrow; // Icon for "Начат"
        return {'message': 'Начат', 'color': Colors.blue, 'icon': statusIcon};
      case '4':
        statusIcon = Icons.check_circle; // Icon for "Завершен"
        return {
          'message': 'Завершен',
          'color': Colors.green,
          'icon': statusIcon
        };
      case '5':
        statusIcon = Icons.pause_circle; // Icon for "Завершен"
        return {
          'message': 'Приостановлен',
          'color': Colors.yellow,
          'icon': statusIcon
        };
      default:
        statusIcon = Icons.help_outline; // Icon for "Неизвестный статус"
        return {
          'message': 'Неизвестный статус',
          'color': Colors.grey,
          'icon': statusIcon
        };
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
          title: Text('Мои наряды'),
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                    child: Text(selectedDate == null
                        ? "Выбрать дату"
                        : "Дата: ${DateFormat('dd.MM').format(selectedDate!)}"),
                  ),
                  DropdownButton<String>(
                    value: selectedStatus,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedStatus = newValue;
                        filterWorkOrdersByStatus(newValue);
                      });
                    },
                    items: statusList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // print(listOfLsNumbers.length);
                       
                      filterTodayWorkOrders();
                    },
                    child: Text('Сегодня'),
                  ),
                ],
              ),
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
                    : ListView.builder(
                        itemCount: workOrders.length,
                        itemBuilder: (context, index) {
                          final workOrder = workOrders[index];
                          String extractLocation(
                              Map<String, dynamic> dynamicFields) {
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
                              final locationValue = dynamicFields['work_fields']
                                  [locationLabel]?[locationLabel]?[locationId];
                              if (locationValue != null &&
                                  locationValue.isNotEmpty) {
                                return locationValue;
                              }
                            }
                            return 'Не указано';
                          }

                          String location =
                              extractLocation(workOrder.dynamicFields);
                          String executor = workOrder
                                  .dynamicFields['work_fields']['Адрес']
                                      ['Адрес']['UF_CRM_1674993837284']
                                  .split('|')
                                  .first ??
                              'Не указано';
                          String accountNumber = workOrder
                                  .dynamicFields['status_work_id']
                                  .toString() ??
                              '0';
                          String desiredArrivalDateString = workOrder
                                      .dynamicFields['work_fields']
                                  ['Желаемая дата  приезда']
                              ['Желаемая дата  приезда']['UF_CRM_1673255749'];
                          String trimmedDateString =
                              desiredArrivalDateString.substring(
                                  0, desiredArrivalDateString.length - 15);
                          // String? lsNumber = workOrder
                          //         .dynamicFields['work_fields']['Лицевой счет']
                          //     ['Лицевой счет']['UF_CRM_1673255771'];

                          Map<String, dynamic> statusInfo =
                              getStatusMessage(accountNumber);
                          String statusMessage = statusInfo['message'];
                          Color statusColor = statusInfo['color'];

                          // Извлеките информацию о резолюции, если наряд завершен
                          String resolutionId = workOrder
                                  .dynamicFields['resolution_work_id']
                                  ?.toString() ??
                              'нет резолюции';
                          Map<String, dynamic> resolutionInfo =
                              getResolutionMessage(resolutionId);
                          bool isCompleted = accountNumber ==
                              '4'; // Предположим, что '4' это статус "Завершен"

                          return Card(
                            child: ListTile(
                              title: Text(
                                  'Наряд: №${workOrder.dynamicFields['id']}   ${workOrder.dynamicFields['type_deal']}'),
                              subtitle: RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(
                                        text:
                                            'Локация: $location\nАдрес: $executor\n'),
                                    TextSpan(
                                        text: 'Статус: $statusMessage\n',
                                        style: TextStyle(color: statusColor)),
                                    TextSpan(
                                      text:
                                          'Дата  приезда: $trimmedDateString\n',
                                    ),
                                    TextSpan(
                                        text: 'Лицевой счет:${_decider(listOfLsNumbers[index])}',
                                        style: const TextStyle(
                                            color: Colors.green)),
                                    if (isCompleted) // Показать резолюцию, если наряд завершен
                                      TextSpan(
                                          text:
                                              '\nРезолюция: ${resolutionInfo['message']}',
                                          style: TextStyle(
                                              color: resolutionInfo['color'])),
                                  ],
                                ),
                              ),
                              leading: Icon(
                                isCompleted
                                    ? resolutionInfo['icon']
                                    : statusInfo[
                                        'icon'], // Иконка для резолюции или статуса
                                color: isCompleted
                                    ? resolutionInfo['color']
                                    : statusColor, // Цвет для резолюции или статуса
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        WorkOrderDetailsScreen(
                                            workOrder: workOrder),
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

  String _decider(String? ls) {
    if (ls != null) {
      return ls;
    } else {
      return "Неизвестный";
    }
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

    // Извлечение желаемой даты приезда
    String desiredArrivalDateString = json['work_fields']
            ['Желаемая дата  приезда']['Желаемая дата  приезда']
        ['UF_CRM_1673255749'];
    DateTime desiredArrivalDate = DateTime.parse(desiredArrivalDateString);

    return WorkOrder(
      dynamicFields: fields,
      created_at: desiredArrivalDate,
    );
  }
}
// class LsNumbers{
//   final List<String> lsNumbers;
//   LsNumbers({required this.lsNumbers});
//   factory LsNumbers.fromJson(Map<String, String> json){
//      Map<String, dynamic> fields = json["work_fields"]["Лицевой счет"]["Лицевой счет"]["UF_CRM_1673255771"];
//      String lsNumber = json[]
//   }
// }