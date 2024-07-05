import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:planup/tmc/presentation/blocs/get_users_trade_history_bloc/get_user_trade_history_bloc.dart';
import 'package:planup/tmc/presentation/widgets/custom_row.dart';

class TradeHistoryListScreen extends StatefulWidget {
  const TradeHistoryListScreen({super.key});

  @override
  State<TradeHistoryListScreen> createState() => _TradeHistoryListScreenState();
}

class _TradeHistoryListScreenState extends State<TradeHistoryListScreen> {
  @override
  void initState() {
    BlocProvider.of<GetUserTradeHistoryBloc>(context)
        .add(GetUserTradeHistoryEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEDF5FF),
      appBar: AppBar(
        backgroundColor: const Color(0xffEDF5FF),
        title: const Text(
          "История трейдов",
          style: TextStyle(fontFamily: "SanSerif", fontWeight: FontWeight.w500),
        ),
      ),
      body: BlocBuilder<GetUserTradeHistoryBloc, GetUserTradeHistoryState>(
        builder: (context, state) {
          if (state is GetUserTradeHistoryLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is GetUserTradeHistorySuccess) {
            return ListView.builder(
              itemCount: state.modelList.data?.length??0,
              itemBuilder: (context, index) {
                String timestamp =
                    state.modelList.data?[index].createDate?.toString() ?? "";
                String? formattedDate = formatTimestamp(timestamp);

                return Card(
                  elevation: 0.7,
                  shadowColor: Colors.black12,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        CustomRow(
                            title: "Номер товара",
                            text:
                                state.modelList.data?[index].goodId?.toString() ?? ""),
                        const Divider(),
                        CustomRow(
                            title: "Номер трейда",
                            text: state.modelList.data?[index].id?.toString() ?? ""),
                        const Divider(),
                        CustomRow(
                            title: "Дата создания", text: formattedDate ?? ""),
                        const Divider(),
                        CustomRow(
                            title: "Коммент",
                            text: state.modelList.data?[index].comment ?? ""),
                        const Divider(),
                        CustomRow(
                            title: "Номер трейда",
                            text: state.modelList.data?[index].id?.toString() ?? ""),
                        const Divider(),
                        CustomRow(
                            title: "От кого",
                            text:
                                state.modelList.data?[index].sourceUserId?.toString() ??
                                    ""),
                        const Divider(),
                        CustomRow(
                            title: "Кому",
                            text: state.modelList.data?[index].destinationUserId
                                    ?.toString() ??
                                ""),
                        const Divider(),
                        CustomRow(
                            title: "Статус",
                            text: convertStatusToString(
                                id: state.modelList.data?[index].tradeStatusId ?? 0)),
                        const Divider(),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is GetUserTradeHistoryError) {
            return Text(state.errorText);
          }
          return const SizedBox();
        },
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
