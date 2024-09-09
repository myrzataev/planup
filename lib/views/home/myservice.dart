import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String? _selectedLocation;
  List<dynamic> lsList = [];
  List<dynamic> lsListCopy = [];
  bool isSearching = false;
  List<dynamic> listOfLocations = [];
  List<dynamic> listOfUniqueLocations = [];
  Map<String, dynamic> jsonMap = {};
  List<dynamic> listOfRegions = [];
  Map<String, dynamic>? rrrr;
  String trimmedDateString = "";
  DateTime parsedDateTime = DateTime.now().toUtc();
  // var workFields;

  @override
  void initState() {
    super.initState();
    _loadWorkOrders();
    //  _reloadTimer = Timer.periodic(Duration(seconds: 120), (Timer t) => _loadWorkOrders());
    selectedStatus = 'Не начат';
    lsListCopy = lsList;
  }

  // void filterByLsNumber(String searchText) {
  //   List<dynamic> results = [];
  //   if (searchText.isEmpty) {
  //     // print("hello");
  //     results =
  //         listOfLsNumbers.map((toElement) => toElement.toString()).toList();
  //   } else {
  //     // print("world");
  //     results = listOfLsNumbers
  //         .where((element) => element.contains(searchText.toLowerCase()))
  //         .toList();
  //   }
  //   setState(() {
  //     print("this is the result $results");
  //     listOfLsNumbersCopy = List.from(results);
  //   });
  // }
  void filterWorkOrdersByLs(String? searchQuery) {
    setState(() {
      if (searchQuery == null || searchQuery.isEmpty) {
        workOrders = List.from(allWorkOrders);
      } else {
        workOrders = allWorkOrders
            .where((workOrder) =>
                workOrder.dynamicFields['work_fields']?["Лицевой счет"]
                        ?["Лицевой счет"]?["UF_CRM_1673255771"]
                    ?.toString()
                    ?.contains(searchQuery) ??
                false)
            .toList();

        workOrders.addAll(allWorkOrders.where((address) =>
            address.dynamicFields['work_fields']?['Адрес']?['Адрес']
                    ?['UF_CRM_1674993837284']
                ?.toString()
                ?.toLowerCase()
                ?.contains(searchQuery.toLowerCase()) ??
            false));
      }
    });
  }

  void searchByLs(String query) {
    var suggestions = [];
    if (query == null || query.isEmpty) {
      suggestions = lsList.map((toElement) => toElement.toString()).toList();
    } else {
      suggestions = lsList.where((lsNumber) {
        return lsNumber.toString().toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    setState(() => lsListCopy = suggestions);
  }

  // void filterWorkOrdersBySearchQuery(String? searchQuery) {
  //   setState(() {
  //     if (searchQuery == null || searchQuery.isEmpty) {
  //       lsList = List.from(lsList);
  //     } else {
  //       lsList = lsList
  //           .where((workOrder) =>
  //               workOrder.toString().contains(searchQuery.toLowerCase()))
  //           .toList();
  //     }
  //   });
  // }

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

      // print(response.statusCode);
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
        // jsonMap = data;
        final List<dynamic> works = data['works'];
        // final List<dynamic> worksTest = data['works'][0]["work_fields"];

        listOfRegions = works.map<String?>((element) {
          if (element["type_deal"] != "Перенос подкл") {
            return null; // Return null if type_deal is not "Перенос подкл"
          }

          final workFields = element["work_fields"] as Map<String, dynamic>?;
          if (workFields == null) {
            return null; // Return null if workFields is null
          }

          for (var entry in workFields.entries) {
            if (entry.key.toLowerCase().contains("локация")) {
              final nestedMap = entry.value as Map<String, dynamic>?;
              if (nestedMap != null) {
                for (var nestedEntry in nestedMap.entries) {
                  if (nestedEntry.value is Map<String, dynamic>) {
                    final deepNestedMap =
                        nestedEntry.value as Map<String, dynamic>;
                    for (var deepNestedEntry in deepNestedMap.entries) {
                      if (deepNestedEntry.value != "Не выбрано") {
                        return deepNestedEntry.value.toString();
                      }
                    }
                  } else if (nestedEntry.value != "Не выбрано") {
                    return nestedEntry.value.toString();
                  }
                }
              }
            }
          }

          return null; // Return null if no valid region is found
        }).toList();

        lsList = works.map(
          (e) {
            return e["work_fields"]?["Лицевой счет"]?["Лицевой счет"]
                    ?["UF_CRM_1673255771"] ??
                "Не указано";
          },
        ).toList();
        listOfLocations = works
            .map((toElement) =>
                toElement["work_fields"]?["Наименование локации"]
                    ?["Наименование локации"]?["UF_CRM_1678102336"] ??
                'Не указано')
            .toList();
        Set<dynamic> uniqueLocationsSet = listOfLocations.toSet();
        listOfUniqueLocations = uniqueLocationsSet.toList();
        // Получение списка заказов из ответа сервера
        // print(works.map((element) => element["work_fields"]["Лицевой счет"]["Лицевой счет"]["UF_CRM_1673255771"]).toList());
        setState(() {
          workOrders = works.map((work) => WorkOrder.fromJson(work)).toList();
          allWorkOrders = List.from(workOrders);
          lsListCopy = lsList;
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
  void filterWorkOrdersByLocation(String? location) {
    // print("Location is $location");
    setState(() {
      if (location == null || location.isEmpty || location == "Все") {
        workOrders = allWorkOrders;
      } else {
        workOrders = allWorkOrders
            .where((workOrder) =>
                workOrder.dynamicFields['work_fields']?["Наименование локации"]
                    ?["Наименование локации"]?["UF_CRM_1678102336"] ==
                location)
            .toList();
      }
    });
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
        return {
          'message': 'Не начат',
          // 'color': Colors.red,
          'color': Colors.black,
          'icon': statusIcon
        };
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
        // color = Colors.white;
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
                    // ElevatedButton(
                    //     onPressed: () {
                    //       print("this is what inside list $lsList");
                    //       print(
                    //           "this is what inside copy list ${lsListCopy}");
                    //     },
                    //     child: Text("test")),
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
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.06,
                  vertical: 3),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      filterWorkOrdersByLs(value);
                    });
                    // setState(() {
                    //   if (value.isEmpty) {
                    //     isSearching = false;
                    //   } else {
                    //     isSearching = true;
                    //   }
                    // });
                  },
                  decoration: InputDecoration(
                      hintText: "Поиск по лицевому счету/адресу",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
              ),
            ),
            DropdownButton<String>(
              value: _selectedLocation,
              onChanged: (newValue) {
                setState(() {
                  _selectedLocation = newValue;
                  filterWorkOrdersByLocation(newValue);
                });
              },
              // items: [
              //   DropdownMenuItem<String>(
              //     value: 'Все',
              //     child: Text('Все'),
              //   ),
              //   ...listOfUniqueLocations.map((location) {
              //     return DropdownMenuItem<String>(
              //       value: location['VALUE'] as String,
              //       child: Text(location['VALUE'] as String),
              //     );
              //   }).toList(),
              // ],
              items: ['Все', ...listOfUniqueLocations].map((location) {
                // print(location);
                return DropdownMenuItem<String>(
                  value: location,
                  child: Text(
                    location,
                  ),
                );
              }).toList(),
              hint: Text('Выберите локацию'),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  // lsListCopy.clear();
                  _loadWorkOrders();
                },
                child: workOrders.isEmpty
                    ? Center(
                        child: selectedDate == null
                            ? const Text('Выберите дату для фильтрации нарядов')
                            : const Text('Нет нарядов для выбранной даты'),
                      )
                    : ListView.builder(
                        itemCount: workOrders.length,
                        // itemCount: workOrders.length,
                        itemBuilder: (context, index) {
                          final region = listOfRegions[index];
                          // final lsNumber = [index];
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
                                  .dynamicFields['work_fields']?['Адрес']
                                      ?['Адрес']?['UF_CRM_1674993837284']
                                  .split('|')
                                  .first ??
                              'Не указано';
                          String? workerComment =
                              workOrder.dynamicFields['work_fields']
                                      ?['Комментарий СИ']?['Комментарий СИ']
                                  ?['UF_CRM_1723708136993'];
                          // "Комментарий отсутствует";

                          String transferAddress = workOrder
                                  .dynamicFields['work_fields']
                                      ?['Адрес переноса']?['Адрес переноса']
                                      ?['UF_CRM_1715681738756']
                                  .split('|')
                                  .first ??
                              'Не указано';
                          String typeDeal =
                              workOrder.dynamicFields['type_deal'] ??
                                  "Не указано";
                          String accountNumber = workOrder
                                  .dynamicFields['status_work_id']
                                  .toString() ??
                              '0';
                          String desiredArrivalDateString =
                              workOrder.dynamicFields['work_fields']
                                              ?['Желаемая дата  приезда']
                                          ['Желаемая дата  приезда']
                                      ?['UF_CRM_1673255749'] ??
                                  "2020-11-29T00:00:00+06:00";
                          try {
                            // Attempt to trim and parse the desired arrival date string
                            trimmedDateString =
                                desiredArrivalDateString.substring(
                                    0, desiredArrivalDateString.length - 15);
                            parsedDateTime =
                                DateTime.parse(trimmedDateString).toUtc();
                          } catch (e) {
                            // Handle parsing error or null value
                            // print("Error parsing date string: $e");
                            // Set a default date (e.g., today's date or a specific date)
                            parsedDateTime = DateTime.now().toUtc();
                          }
                          parsedDateTime = parsedDateTime.toUtc();
                          Map<String, dynamic> statusInfo =
                              getStatusMessage(accountNumber);
                          String statusMessage = statusInfo['message'];
                          Color statusColor = statusInfo['color'];

                          String resolutionId = workOrder
                                  .dynamicFields['resolution_work_id']
                                  ?.toString() ??
                              'нет резолюции';
                          Map<String, dynamic> resolutionInfo =
                              getResolutionMessage(resolutionId);
                          bool isCompleted = accountNumber ==
                              '4'; // Предположим, что '4' это статус "Завершен"

                          return Card(
                            color: chooseColor(date: parsedDateTime),
                            child: ListTile(
                              title: Text(
                                  'Наряд: №${workOrder.dynamicFields['id']}   ${workOrder.dynamicFields['type_deal']}'),
                              subtitle: RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    isTransferredAddress(typeDeal)
                                        ? TextSpan(
                                            text:
                                                "Локация: ${region ?? "Не указано"}\nАдрес переноса: ${transferAddress ?? "Не указано"}\n")
                                        : TextSpan(
                                            text:
                                                'Локация: $location\nАдрес: $executor\n'),
                                    TextSpan(
                                      text: 'Статус: $statusMessage\n',
                                      // style: TextStyle(color: statusColor)
                                    ),
                                    TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'Дата приезда: ',
                                        ), // Default color
                                        TextSpan(
                                          text: "$trimmedDateString\n",
                                          // style: TextStyle(
                                          //     color: chooseColor(
                                          //         date: parsedDateTime)
                                          //         ),
                                        ),
                                      ],
                                    ),
                                    TextSpan(
                                      text:
                                          "Лицевой счет: ${_decider(lsListCopy[index])}\n",
                                      // text: 'Лицевой счет:${_decider(listOfLsNumbers[index])}',
                                      // style: const TextStyle(
                                      //     color: Colors.green)
                                    ),
                                    TextSpan(children: [
                                      TextSpan(
                                        text: (workerComment != null)
                                            ? "Комментарий СИ: "
                                            : "",
                                      ),
                                      TextSpan(
                                          text: (workerComment != null)
                                              ? workerComment
                                              : "",
                                          style: const TextStyle(
                                              color: Color(0xff0000FE)))
                                    ]),
                                    if (isCompleted) // Показать резолюцию, если наряд завершен
                                      TextSpan(
                                        text:
                                            '\nРезолюция: ${resolutionInfo['message']}',
                                        // style: TextStyle(
                                        //     color: resolutionInfo['color'])
                                      ),
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
                                // print(listOfRegions);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        WorkOrderDetailsScreen(
                                            isTransering:
                                                isTransferredAddress(typeDeal),
                                            location: region ?? "",
                                            transferAddress: transferAddress,
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

  String _decider(String ls) {
    if (ls.isEmpty || ls == null) {
      return "Не Указано";
    } else {
      return ls;
    }
  }

  bool isTransferredAddress(String typeDeal) {
    if (typeDeal == "Перенос подкл") {
      return true;
    } else {
      return false;
    }
  }

  Color chooseColor({required DateTime date}) {
    DateTime currentDateTime = DateTime.now().toLocal().toUtc();
    Duration oneDay = const Duration(days: 1);
    Duration tenDays = const Duration(days: 10);

    Duration difference = currentDateTime.difference(date);

    if (difference <= oneDay) {
      return Colors.green; // 1-2 days
    } else if (difference <= oneDay * 5) {
      return Colors.amber; // 3-5 days
    } else if (difference <= tenDays) {
      return Colors.orange;
      // 6-9 days (you can choose another color here)
    } else {
      return Colors.red; // More than 10 days
    }
  }
  // String filter(String location){
  //   switch (location){
  //     case "Локация Ош":
  //     return "UF_CRM_1675070693";
  //     case "Локация Талас"
  //   }
  // }
  // String locationName(String location){
  //   if(location == )
  // }
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
                ?['Желаемая дата  приезда']?['Желаемая дата  приезда']
            ?['UF_CRM_1673255749'] ??
        "2023-11-29T00:00:00+06:00";
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
