import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import 'package:planup/views/home/work_order_details_screen.dart';

import 'openserviceget.dart';

class OpenService extends StatefulWidget {
  const OpenService({Key? key}) : super(key: key);

  @override
  _OpenServiceState createState() => _OpenServiceState();
}

class _OpenServiceState extends State<OpenService> {
  List<WorkOrder> workOrders = [];
  List<String> typeDealList = [];
  List<dynamic> listOfLocations = [];
  List<dynamic> listOfUniqueLocations = [];
  String? _selectedTypeDeal;
  String? _selectedLocation;
  String? _searchQuery;
  DateTime? selectedDate;
  bool _isInit = true;
  bool _isLoading = false;
  List<dynamic> lsList = [];
  List<dynamic> lsListCopy = [];
  List<dynamic> _forLocations = [];
  List<dynamic> _forLocationsCopy = [];

  @override
  void initState() {
    super.initState();
    _loadWorkOrders();
    lsListCopy = lsList;
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<WorkOrder> allWorkOrders = [];

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
    setState(() {
      _isLoading = true;
    });

    final user_id = await storage.read(key: 'user_id');

    try {
      final uri =
          Uri.parse('http://planup.skynet.kg:8000/planup/locations_naryds/');
      final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
      final body = {'user_id': '$user_id'};

      final response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final List<dynamic> works = data['works'];
        _forLocations = works;
        setState(() {
          workOrders = works.map((work) => WorkOrder.fromJson(work)).toList();
          allWorkOrders = List.from(workOrders);
          _isLoading = false;

          // Extracting type deal list
          typeDealList = List<String>.from(
            Set<String>.from(
                workOrders.map((work) => work.dynamicFields['type_deal'])),
          );
          listOfLocations = works
              .map((toElement) =>
                  toElement["work_fields"]?["Наименование локации"]
                      ?["Наименование локации"]?["UF_CRM_1678102336"] ??
                  'Не указано')
              .toList();
          Set<dynamic> uniqueLocationsSet = listOfLocations.toSet();
          listOfUniqueLocations = uniqueLocationsSet.toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 4),
            content: Text("Раздел скоро заработает"),
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      // print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 4),
          content: Text("PlanUP сервер не доступен, обратитесь в IT отдел"),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  void filterAllWorkOrders() {
    setState(() {
      selectedDate = null;
      workOrders = List.from(allWorkOrders);
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
      if (status == 'Все') {
        workOrders = List.from(allWorkOrders);
      } else if (status == 'Не начат') {
        workOrders = allWorkOrders.where((workOrder) {
          final statusId = workOrder.dynamicFields['status_work_id'].toString();
          return statusId == '1';
        }).toList();
      } else {
        workOrders = allWorkOrders.where((workOrder) {
          final statusId = workOrder.dynamicFields['status_work_id'].toString();
          return statusId == getStatusIdByName(status!);
        }).toList();
      }
    });
  }

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

  String getStatusIdByName(String statusName) {
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
        return '';
    }
  }

  Map<String, dynamic> getStatusMessage(String statusId) {
    IconData statusIcon;
    switch (statusId) {
      case '1':
        statusIcon = Icons.error_outline;
        return {'message': 'Не начат', 'color': Colors.red, 'icon': statusIcon};
      case '2':
        statusIcon = Icons.directions_bus;
        return {
          'message': 'В пути',
          'color': Colors.yellow,
          'icon': statusIcon
        };
      case '3':
        statusIcon = Icons.play_arrow;
        return {'message': 'Начат', 'color': Colors.blue, 'icon': statusIcon};
      case '4':
        statusIcon = Icons.check_circle;
        return {
          'message': 'Завершен',
          'color': Colors.green,
          'icon': statusIcon
        };
      case '5':
        statusIcon = Icons.pause_circle;
        return {
          'message': 'Приостановлен',
          'color': Colors.yellow,
          'icon': statusIcon
        };
      default:
        statusIcon = Icons.help_outline;
        return {
          'message': 'Неизвестный статус',
          'color': Colors.grey,
          'icon': statusIcon
        };
    }
  }

  void filterWorkOrdersByTypeDeal(String? typeDeal) {
    setState(() {
      if (typeDeal == null || typeDeal.isEmpty) {
        workOrders = List.from(allWorkOrders);
      } else {
        workOrders = allWorkOrders
            .where(
                (workOrder) => workOrder.dynamicFields['type_deal'] == typeDeal)
            .toList();
      }
    });
  }

  void filterWorkOrdersBySearchQuery(String? searchQuery) {
    setState(() {
      if (searchQuery == null || searchQuery.isEmpty) {
        workOrders = List.from(allWorkOrders);
      } else {
        workOrders = allWorkOrders
            .where((workOrder) =>
                workOrder.dynamicFields['id'].toString().contains(searchQuery))
            .toList();
      }
    });
  }

  void filterWorkOrdersByLs(String? searchQuery) {
    setState(() {
      if (searchQuery == null || searchQuery.isEmpty) {
        workOrders = List.from(allWorkOrders);
      } else {
        workOrders = allWorkOrders
            .where((workOrder) => workOrder.dynamicFields['work_fields']
                    ["Лицевой счет"]["Лицевой счет"]["UF_CRM_1673255771"]
                .toString()
                .contains(searchQuery))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Открытые наряды'),
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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Поиск по номеру наряда',
                            prefixIcon: Icon(Icons.search),
                          ),
                          keyboardType: TextInputType.number, //

                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                              filterWorkOrdersBySearchQuery(_searchQuery);
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      DropdownButton<String>(
                        value: _selectedTypeDeal,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedTypeDeal = newValue;
                            filterWorkOrdersByTypeDeal(newValue);
                          });
                        },
                        items: ['Все', ...typeDealList].map((typeDeal) {
                          return DropdownMenuItem<String>(
                            value: typeDeal,
                            child: Text(typeDeal),
                          );
                        }).toList(),
                        hint: Text('Выберите тип сделки'),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.06,
                      vertical: 3),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          filterWorkOrdersByLs(value);

                          // if (value.isEmpty) {
                          //   // isSearching = false;
                          // } else {
                          //   // isSearching = true;
                          // }
                        });
                      },
                      decoration: InputDecoration(
                          hintText: "Поиск по лицевому счету",
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
                  items: ['Все', ...listOfUniqueLocations].map((location) {
                    return DropdownMenuItem<String>(
                      value: location,
                      child: Text(
                        location,
                      ),
                    );
                  }).toList(),
                  hint: Text('Выберите локацию'),
                ),
                // ElevatedButton(
                //     onPressed: () {
                //       // print();
                //     },
                //     child: Text("dfsa")),
                Expanded(
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
                              // print("Location keys entries: ${locationKeys.entries}");

                              for (var entry in locationKeys.entries) {
                                final locationLabel = entry.key;
                                final locationId = entry.value;
                                final locationValue =
                                    dynamicFields['work_fields'][locationLabel]
                                        ?[locationLabel]?[locationId];
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
                            String lsNumber =
                                workOrder.dynamicFields['work_fields']
                                            ['Лицевой счет']['Лицевой счет']
                                        ['UF_CRM_1673255771'] ??
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

                            Map<String, dynamic> statusInfo =
                                getStatusMessage(accountNumber);
                            String statusMessage = statusInfo['message'];
                            Color statusColor = statusInfo['color'];

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
                                              'Дата  приезда: $trimmedDateString\n'),
                                      TextSpan(
                                          text: 'Лицевой счет: ${lsNumber}',
                                          style:
                                              TextStyle(color: Colors.green)),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Getopenservice(workOrders: workOrder),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                ),
               
              ],
            ),
    );
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
    // print(json);
    String desiredArrivalDateString = json["works"]?['work_fields']
                ?['Желаемая дата  приезда']?['Желаемая дата  приезда']
            ?['UF_CRM_1673255749'] ??
        "2024-03-22T14:24:23+06:00";

    DateTime desiredArrivalDate = DateTime.parse(desiredArrivalDateString);

    return WorkOrder(
      dynamicFields: fields,
      created_at: desiredArrivalDate,
    );
  }
}
