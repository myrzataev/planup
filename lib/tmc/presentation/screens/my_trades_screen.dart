import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:intl/intl.dart';
import 'package:planup/core/services/shared_preferences_init.dart';
import 'package:planup/tmc/presentation/blocs/accept_trade_bloc/accept_trade_bloc.dart';
import 'package:planup/tmc/presentation/blocs/deny_trade_bloc/deny_trade_bloc.dart';
import 'package:planup/tmc/presentation/blocs/get_my_trades_bloc/get_my_trades_bloc.dart';
import 'package:planup/tmc/presentation/widgets/custom_row.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyTradesScreen extends StatefulWidget {
  const MyTradesScreen({super.key});

  @override
  State<MyTradesScreen> createState() => _TradeHistoryListScreenState();
}

class _TradeHistoryListScreenState extends State<MyTradesScreen> {
  SharedPreferences preferences = locator<SharedPreferences>();
  TextEditingController controller = TextEditingController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _loadTrades();
  }

  void _loadTrades() {
    final userId = preferences.getInt("userNameForTmc")?.toString() ?? '';
    BlocProvider.of<GetMyTradesBloc>(context).add(GetMyTradesEvent(id: userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEDF5FF),
      appBar: AppBar(
        backgroundColor: const Color(0xffEDF5FF),
        title: const Text(
          "Список трейдов",
          style: TextStyle(fontFamily: "SanSerif", fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocBuilder<GetMyTradesBloc, GetMyTradesState>(
            builder: (context, state) {
              if (state is GetMyTradesLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is GetMyTradesSuccess) {
                return Expanded(
                  child: RefreshIndicator(
                    key: _refreshIndicatorKey,
                    onRefresh: () async {
                      _loadTrades();
                    },
                    child: ListView.builder(
                      itemCount: state.modelList.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        String timestamp = state
                                .modelList.data?[index].createDate
                                ?.toString() ??
                            "";
                        String? formattedDate = formatTimestamp(timestamp);
                        return Card(
                          elevation: 0.7,
                          shadowColor: Colors.black12,
                          color: Colors.white,
                          child: Column(
                            children: [
                              CustomRow(
                                  title: "Номер трейда",
                                  text: state.modelList.data?[index].id
                                          ?.toString() ??
                                      ""),
                              const Divider(),
                              CustomRow(
                                  title: "Номер товара",
                                  text: state.modelList.data?[index].goodId
                                          ?.toString() ??
                                      ""),
                              const Divider(),
                              CustomRow(
                                  title: "Дата создания",
                                  text: formattedDate ?? ""),
                              const Divider(),
                              CustomRow(
                                  title: "Коммент",
                                  text: state.modelList.data?[index].comment ??
                                      ""),
                              const Divider(),
                              CustomRow(
                                  title: "Номер трейда",
                                  text: state.modelList.data?[index].id
                                          ?.toString() ??
                                      ""),
                              const Divider(),
                              CustomRow(
                                  title: "От кого",
                                  text: state
                                          .modelList.data?[index].sourceUserId
                                          ?.toString() ??
                                      ""),
                              const Divider(),
                              CustomRow(
                                  title: "Кому",
                                  text: state.modelList.data?[index]
                                          .destinationUserId
                                          ?.toString() ??
                                      ""),
                              const Divider(),
                              CustomRow(
                                  title: "Статус",
                                  text: convertStatusToString(
                                      id: state.modelList.data?[index]
                                              .tradeStatusId ??
                                          0)),
                              (state.modelList.data?[index].sourceUserId !=
                                          preferences
                                              .getInt("userNameForTmc") &&
                                      state.modelList.data?[index]
                                              .tradeStatusId ==
                                          1)
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        MaterialButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (context) => AlertDialog(
                                                          title: const Text(
                                                              "Введите комментарий"),
                                                          actions: [
                                                            SizedBox(
                                                              width: double
                                                                  .infinity,
                                                              child:
                                                                  TextFormField(
                                                                controller:
                                                                    controller,
                                                              ),
                                                            ),
                                                            MaterialButton(
                                                              onPressed: () {
                                                                BlocProvider.of<DenyTradeBloc>(context).add(DenyTradeEvent(
                                                                    comment:
                                                                        controller
                                                                            .text,
                                                                    id: state
                                                                            .modelList
                                                                            .data?[index]
                                                                            .id
                                                                            ?.toString() ??
                                                                        ""));
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                  "Отправить"),
                                                            )
                                                          ],
                                                        ));
                                          },
                                          color: Colors.red,
                                          child: const Text("Отклонить"),
                                        ),
                                        MaterialButton(
                                          onPressed: () {
                                            BlocProvider.of<AcceptTradeBloc>(
                                                    context)
                                                .add(AcceptTradeEvent(
                                                    id: state.modelList
                                                            .data?[index].id
                                                            ?.toString() ??
                                                        ""));
                                          },
                                          color: Colors.green,
                                          child: const Text("Принять"),
                                        )
                                      ],
                                    )
                                  : const SizedBox()
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              } else if (state is GetMyTradesError) {
                return Text(state.errorText);
              }
              return const SizedBox();
            },
          ),
          BlocListener<AcceptTradeBloc, AcceptTradeState>(
            listener: (context, state) {
              if (state is AcceptTradeLoading) {
                Loader.show(context);
              } else if (state is AcceptTradeSuccess) {
                Loader.hide();
                _loadTrades();
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text("Вы успешно приняли товар"),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Закрыть"))
                          ],
                        ));
              } else {
                Loader.hide();
              }
            },
            child: const SizedBox(),
          ),
          BlocListener<DenyTradeBloc, DenyTradeState>(
            listener: (context, state) {
              if (state is DenyTradeLoading) {
                Loader.show(context);
              } else if (state is DenyTradeSuccess) {
                Loader.hide();
                _loadTrades();
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text("Вы отклонили трейд"),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Закрыть"))
                          ],
                        ));
              } else if (state is DenyTradeError) {
                Loader.hide();
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text("Не удалось передать товар"),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Закрыть"))
                          ],
                        ));
              }
            },
            child: const SizedBox(),
          ),
        ],
      ),
    );
  }

  String convertStatusToString({required int id}) {
    switch (id) {
      case 1:
        return "В ожидании";
      case 2:
        return "Принят";
      case 3:
        return "Отклонен";
      default:
        return "Неизвестно";
    }
  }

  String? formatTimestamp(String? timestamp) {
    if (timestamp == null) {
      return null;
    }
    try {
      DateTime dateTime = DateTime.parse(timestamp);
      return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
    } catch (e) {
      // Handle the error or return null if the timestamp is not valid
      return null;
    }
  }
}
