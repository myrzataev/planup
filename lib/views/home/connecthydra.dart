import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:planup/views/home/scanmac.dart';

class HydraConnect extends StatefulWidget {
  final String accountNumber;
  const HydraConnect({Key? key, required this.accountNumber}) : super(key: key);

  @override
  _HydraConnectState createState() => _HydraConnectState();
}

class _HydraConnectState extends State<HydraConnect> {
  List<String>?
      macAddresses; // Переменная состояния для хранения результатов сканирования
// В HydraConnect
  void _scanAndReceiveMacAddresses() async {
    // Начало сканирования и ожидание возвращённых данных
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Scanmac()),
    );

    // Проверка на null и обработка возвращённых данных
    if (result != null) {
      // Преобразование возвращённой строки в список MAC-адресов
      List<String> macAddresses = result.split('\n');

      // Обновление UI
      setState(() {
        // Здесь обновите переменные состояния, используемые для отображения MAC-адресов
        // Например:
        this.macAddresses = macAddresses;
      });

      // Показать Snackbar с сообщением о количестве найденных MAC-адресов (необязательно)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Найдено MAC-адресов: ${macAddresses.length}'),
        ),
      );
    }
  }

  final _formKey =
      GlobalKey<FormState>(); // Добавьте это в состояние вашего виджета

  final storage = FlutterSecureStorage();
  String? selectedTariff;
  String? selectedTarifForNextMonth;
  final List<String> companies = ["Skynet Telecom", "Intercom"];
  String? selectedCompany;
  late TextEditingController accountNumberController;

  bool isPhoneFieldVisible =
      false; // Состояние для видимости поля ввода номера телефона
  TextEditingController phoneController =
      TextEditingController(); // Контроллер для поля ввода номера телефона
  TextEditingController phoneControllerur = TextEditingController();
  TextEditingController accountNumberControllerur = TextEditingController();
  bool isGiftedTarif = false;
  bool isCompanySelected = false;

  Map<String, String> tariffs = {
    '4469680701': 'Sky70 - 890,00	сом',
    '4469697801': 'Промо 70+ТВ	- 980,00	сом',
    '4470325301': 'Промо 90+ТВ	- 1190,00	сом',
    '4470378201': 'Промо 100+ТВ	- 1280,00	сом ',
    '51153501': 'Gift'
  };
  Map<String, String> interComTariffs = {
    '6898370401': 'Интер 70	-	890,00	сом',
    '6898374601': 'Интер 70+ТВ	-	980,00	сом',
    '6898370601': 'Интер 90	-	1090,00	сом',
    '6898374901': 'Интер 90+ТВ	-	1190,00	сом',
    '6898371001': 'Интер 100	-	1180,00	сом',
    '6898376701': 'Интер 100+ТВ	-	1280,00	сом',
    '51153501': 'Gift'
  };
  TextEditingController macAddressController = TextEditingController();
  Map<String, File> capturedImages = {}; // Updated to use a Map
  Map<String, TextEditingController> reportControllers =
      {}; // Для хранения контроллеров
  bool isMacAddressValid =
      false; // Изначально считаем, что MAC-адрес недействителен
  bool isInterTariffSelected =
      false; // New variable to track if 'Интер' tariff is selected

  @override
  void initState() {
    super.initState();
    selectedTariff = tariffs.keys.first; // Например, ключ первого тарифа
    accountNumberController = TextEditingController(text: widget.accountNumber);
    updateInterTariffVisibility(selectedTariff); // Check initial tariff
  }

  void dispose() {
    // Очищаем контроллер, когда виджет удаляется из дерева виджетов
    accountNumberController.dispose();
    super.dispose();
  }

  // This function updates the isInterTariffSelected variable based on the selected tariff
  void updateInterTariffVisibility(String? tariffKey) {
    if (tariffKey != null) {
      setState(() {
        // Предполагая, что 'Интер' тарифы начинаются с '68983'
        isInterTariffSelected = tariffKey.startsWith('68983');
      });
    }
  }

  Future<void> autoConnect(
    String macAddress,
    String selectedTariff,
    String accaunt,
    String tv,
    String accaunt_ur,
    String tel_ur,
    String? gift,
  ) async {
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

/////Myrzataev
    final Uri uri =
        Uri.parse('http://185.39.79.84:8000/accounts/auto-connetction/');
    Map<String, dynamic> requestBody = {
      "mac_address": "${macAddress.toLowerCase()}",
      "ls": "$accaunt",
      "tarif": selectedTariff,
      "tv": phoneController.text,
      "ur_ls": "$accaunt_ur",
      "ur_tel": "$tel_ur",
      "gift": isGiftedTarif ? "51153501" : ""
    };

    // print(
    //   "this is mac address  ${macAddress}",
    // );
    // print(
    //   "this is selectedTarif $selectedTariff",
    // );
    // print(
    //   "this is ls: $accaunt",
    // );
    // print("this is tarif $selectedTariff");
    // print(gift == null);

    // print(
    //   "phone ${phoneControllerur.text}",
    // );
    // print("selectedTarifForNextMonth $selectedTarifForNextMonth");
    // if (gift != null) {
    //   requestBody[""] = gift;
    // }

    // Кодирование данных в JSON
    String jsonData = jsonEncode(requestBody);

    // Определение заголовков запроса
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    try {
      // Отправка POST-запроса на сервер
      final response = await http.post(
        uri,
        headers: headers,
        body: jsonData,
      );

      if (response.statusCode == 200) {
        if (dialogContext != null) {
          Navigator.of(dialogContext!).pop(); // Закрывает только диалог
        }

        context.goNamed("searchclient");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Абонент подключен, интернет  заработает  через 15 секунд'),
          ),
        );
      } else {
        if (dialogContext != null) {
          Navigator.of(dialogContext!).pop(); // Закрывает только диалог
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Запрос не может выполнен, проверьте данные'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Ошибка отправки запроса, попробуйте  еще раз или  обратитесь в СПК'),
        ),
      );
    }
  }

  Future<void> sendMacDataWithAddress(
      {required String macAddress,
      required String selectedTariff,
      required String accaunt,
      required String tv,
      // ignore: non_constant_identifier_names
      required String accaunt_ur,
      // ignore: non_constant_identifier_names
      required String tel_ur}) async {
////Myrzataev
    final Uri uri =
        Uri.parse('http://185.39.79.84:8000/accounts/manual-input/');
    Map<String, dynamic> requestBody = {
      'mac_address': macAddress.toLowerCase(),
    };

    // Кодирование данных в JSON
    String jsonData = jsonEncode(requestBody);

    // Определение заголовков запроса
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    try {
      // Отправка POST-запроса на сервер
      final response = await http.post(
        uri,
        headers: headers,
        body: jsonData,
      );

      if (response.statusCode == 200) {
        autoConnect(
            macAddressController.text,
            isGiftedTarif ? selectedTarifForNextMonth ?? "" : selectedTariff,
            accountNumberController.text,
            phoneController.text,
            accountNumberControllerur.text,
            phoneControllerur.text,
            selectedTarifForNextMonth);
        // autoConnect(macAddress, selectedTariff, accaunt, tv, accaunt_ur, tel_ur,
        //     selectedTarifForNextMonth);
      } else {
        print(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Указанный MAC-адрес не найден, проверьте правильность указания MAC-адреса'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Ошибка отправки запроса, попробуйте  еще раз или  обратитесь в СПК'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> currentTariffs =
        selectedCompany == "Skynet Telecom" ? tariffs : interComTariffs;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.accountNumber),
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // Добавляем SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(
              16.0), // Добавляем padding ко всему содержимому
          child: Column(
            // Ваш Column теперь внутри SingleChildScrollView
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical:
                        8.0), // Задаём горизонтальные и вертикальные отступы
                child: TextField(
                  controller: accountNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Лицевой счет',
                    border:
                        OutlineInputBorder(), // Добавляет границу вокруг поля ввода
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical:
                        8.0), // Задаём горизонтальные и вертикальные отступы
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    labelText: 'Компания',
                  ),
                  child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text("Выберите компанию где вы работаете"),
                    disabledHint:
                        const Text("Выберите компанию где вы работаете"),
                    value: selectedCompany,
                    onChanged: (String? newValue) {
                      setState(() {
                        isCompanySelected = true;
                        selectedCompany = newValue;
                      });
                    },
                    items: companies.map<DropdownMenuItem<String>>((entry) {
                      return DropdownMenuItem<String>(
                        value: entry,
                        child: Text(entry),
                      );
                    }).toList(),
                  )),
                ),
              ),
              isCompanySelected
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical:
                              8.0), // Задаём горизонтальные и вертикальные отступы
                      child: InputDecorator(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          labelText: 'Тариф',
                        ),
                        child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                                hint: const Text("Выберите тариф"),
                                disabledHint: const Text("Выберите тариф"),
                                value:
                                    currentTariffs.containsKey(selectedTariff)
                                        ? selectedTariff
                                        : null,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    if (newValue != "51153501") {
                                      isGiftedTarif = false;
                                      selectedTariff = newValue;
                                      updateInterTariffVisibility(newValue);
                                    } else {
                                      isGiftedTarif = true;
                                      selectedTariff = newValue;
                                    } // Обновляем видимость полей для тарифа "Интер"
                                  });
                                },
                                items: currentTariffs.entries
                                    .map<DropdownMenuItem<String>>((entry) {
                                  return DropdownMenuItem<String>(
                                    value: entry.key,
                                    child: Text(entry.value),
                                  );
                                }).toList())),
                      ),
                    )
                  : const SizedBox(),
              (isGiftedTarif)
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical:
                              8.0), // Задаём горизонтальные и вертикальные отступы
                      child: InputDecorator(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          labelText: 'Выберите тариф на следующий месяц',
                        ),
                        child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                                hint: const Text("Выберите тариф на следующий месяц"),
                                disabledHint: const Text("Выберите тариф на следующий месяц"),
                                value: currentTariffs
                                        .containsKey(selectedTarifForNextMonth)
                                    ? selectedTarifForNextMonth
                                    : null,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    // selectedTariff = newValue;
                                    selectedTarifForNextMonth = newValue;
                                    // updateInterTariffVisibility(
                                    //     newValue); // Обновляем видимость полей для тарифа "Интер"
                                  });
                                },
                                items: currentTariffs.entries
                                    .map<DropdownMenuItem<String>>((entry) {
                                      return DropdownMenuItem<String>(
                                        value: entry.key,
                                        child: Text(entry.value),
                                      );
                                    })
                                    .toList()
                                    .sublist(0, currentTariffs.length - 1))),
                      ),
                    )
                  : const SizedBox(),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              //   child: TextFormField(
              //     controller: macAddressController,
              //     decoration: InputDecoration(
              //       labelText: 'MAC-адрес',
              //       hintText: 'XX:XX:XX:XX:XX:XX',
              //       border: OutlineInputBorder(),
              //     ),
              //     keyboardType: TextInputType.text,
              //     inputFormatters: [
              //       FilteringTextInputFormatter.allow(RegExp(r'[0-9A-Fa-f:]')), // Разрешаем только шестнадцатеричные символы и двоеточие
              //       LengthLimitingTextInputFormatter(17), // Ограничиваем длину ввода до 17 символов
              //       TextInputFormatter.withFunction((oldValue, newValue) {
              //         // Форматируем текст в соответствии с маской
              //         if (oldValue.text.length >= newValue.text.length) {
              //           return TextEditingValue(
              //             text: newValue.text,
              //             selection: TextSelection.collapsed(offset: newValue.selection.baseOffset),
              //           );
              //         } else if (newValue.text.length == 2 || newValue.text.length == 5 || newValue.text.length == 8 || newValue.text.length == 11 || newValue.text.length == 14) {
              //           // Добавляем двоеточие после каждых двух символов, кроме последнего двоеточия
              //           return TextEditingValue(
              //             text: '${newValue.text.toUpperCase()}:',
              //             selection: TextSelection.collapsed(offset: newValue.text.length + 1),
              //           );
              //         }
              //         return newValue;
              //       }),
              //     ],
              //     onChanged: (value) {
              //       print(value);
              //       bool isValid = value.length == 17;
              //       if (isMacAddressValid != isValid) {
              //         setState(() {
              //           isMacAddressValid = isValid;
              //         });
              //       }
              //     },
              //   ),
              // ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  controller: macAddressController,
                  decoration: InputDecoration(
                    labelText: 'MAC-адрес',
                    hintText: 'xx:xx:xx:xx:xx:xx',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(
                        r'[0-9a-f:]')), // Allow only hexadecimal symbols and colon
                    LengthLimitingTextInputFormatter(
                        17), // Limit input length to 17 characters
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      // Format text according to the mask
                      final newText = newValue.text.toLowerCase();
                      if (oldValue.text.length >= newText.length) {
                        return TextEditingValue(
                          text: newText,
                          selection: TextSelection.collapsed(
                              offset: newValue.selection.baseOffset),
                        );
                      } else if (newText.length == 2 ||
                          newText.length == 5 ||
                          newText.length == 8 ||
                          newText.length == 11 ||
                          newText.length == 14) {
                        // Add colon after every two characters, except the last colon
                        return TextEditingValue(
                          text: '$newText:',
                          selection: TextSelection.collapsed(
                              offset: newText.length + 1),
                        );
                      }
                      return TextEditingValue(
                        text: newText,
                        selection: newValue.selection,
                      );
                    }),
                  ],
                  onChanged: (value) {
                    print(value);
                    bool isValid = value.length == 17;
                    if (isMacAddressValid != isValid) {
                      setState(() {
                        isMacAddressValid = isValid;
                      });
                    }
                  },
                ),
              ),

              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: CheckboxListTile(
                      title: Text("Подключить ТВ"),
                      value: isPhoneFieldVisible,
                      onChanged: (bool? newValue) {
                        setState(() {
                          isPhoneFieldVisible = newValue!;
                        });
                      },
                    ),
                  ),
                  Visibility(
                    visible: isPhoneFieldVisible,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: TextFormField(
                        controller: phoneController,
                        decoration: InputDecoration(
                          border:
                              OutlineInputBorder(), // Добавляет границу вокруг поля ввода
                          labelText: 'Введите номер телефона для ТВ',
                          hintText: 'ТВ номер в формате 996555112233',
                        ),
                        keyboardType: TextInputType.phone,
                        maxLength:
                            12, // Максимальная длина номера (включая "996")
                        maxLengthEnforcement: MaxLengthEnforcement
                            .enforced, // Учитывать максимальную длину
                        inputFormatters: [
                          FilteringTextInputFormatter
                              .digitsOnly, // Позволяет вводить только цифры
                          LengthLimitingTextInputFormatter(
                              12), // Ограничивает длину вводимого текста
                          // Опционально можно добавить форматирование номера, чтобы автоматически вставлялась "996" в начале
                          TextInputFormatter.withFunction((oldValue, newValue) {
                            // newValue - новое значение в поле ввода
                            // oldValue - предыдущее значение в поле ввода
                            // Проверяем, если новое значение не содержит "996", то добавляем его
                            if (newValue.text.isNotEmpty &&
                                !newValue.text.startsWith('996')) {
                              return TextEditingValue(
                                text:
                                    '996${newValue.text}', // Добавляем "996" в начало
                                selection: TextSelection.collapsed(
                                    offset: newValue.text.length +
                                        3), // Устанавливаем курсор в конец
                              );
                            }
                            // Если новое значение уже содержит "996", то оставляем его как есть
                            return newValue;
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // ElevatedButton(onPressed: (){
              //   print(phoneController.text);
              // }, child: Text("dadadfw")),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Visibility(
                        visible: isInterTariffSelected,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: accountNumberControllerur,
                              decoration: InputDecoration(
                                border:
                                    OutlineInputBorder(), // Добавляет границу вокруг поля ввода

                                labelText: 'Лицевой счет Интерком',
                                hintText: 'Введите лицевой счет',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Пожалуйста, введите лицевой счет Интерком';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                                height:
                                    20.0), // Вертикальный отступ между полями

                            TextFormField(
                              controller: phoneControllerur,
                              decoration: InputDecoration(
                                border:
                                    OutlineInputBorder(), // Добавляет границу вокруг поля ввода

                                labelText:
                                    'Номер телефона Интерком, в формате 996555112233',
                                hintText: 'Введите номер телефона Интерком',
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Пожалуйста, введите номер телефона Интерком';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: _scanAndReceiveMacAddresses,
                icon: Icon(Icons.document_scanner), // Иконка сканирования
                label: Text('Сканировать MAC-адрес'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.purple, // Цвет текста и иконки
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8.0), // Закругленные углы
                  ),
                ),
              ),

              ElevatedButton.icon(
                onPressed: macAddressController.text.length == 17
                    ? () {
                        if (_formKey.currentState!.validate()) {
                          sendMacDataWithAddress(
                              macAddress: macAddressController.text,
                              selectedTariff: selectedTariff!,
                              accaunt: accountNumberController.text,
                              tv: phoneController.text,
                              accaunt_ur: accountNumberControllerur.text,
                              tel_ur: phoneControllerur.text);
                          // autoConnect(
                          // macAddressController.text,
                          // isGiftedTarif
                          //     ? selectedTarifForNextMonth ?? ""
                          //     : selectedTariff!,
                          // accountNumberController.text,
                          // phoneController.text,
                          // accountNumberControllerur.text,
                          // phoneControllerur.text,
                          // selectedTarifForNextMonth);
                        }
                      }
                    : null, // Кнопка становится неактивной, если длина текста не равна 17
                icon: Icon(Icons.connect_without_contact),
                label: Text('Подключить'), // Иконка сканирования
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepPurple, // Цвет текста кнопки
                  elevation: 5, // Тень кнопки
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Скругление углов
                  ),
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: macAddresses
                        ?.map((macAddress) => Card(
                              elevation: 2.0, // Добавляет тень для 3D эффекта
                              margin: EdgeInsets.symmetric(
                                  vertical: 4.0,
                                  horizontal: 8.0), // Отступы вокруг карточки
                              child: ListTile(
                                title: SelectableText(
                                  macAddress
                                      .toLowerCase(), // Преобразование MAC-адреса в нижний регистр
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.copy),
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(
                                        text: macAddress
                                            .toLowerCase())); // Также копируем в нижнем регистре
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('MAC адрес скопирован')),
                                    );
                                  },
                                ),
                              ),
                            ))
                        .toList() ??
                    [
                      Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Нет MAC адресов для отображения"))
                    ],
              ),
              // ElevatedButton(onPressed: () {
              //   print(tariffs);
              // }, child: Text("fds"))
            ],
          ),
        ),
      ),
    );
  }
}
