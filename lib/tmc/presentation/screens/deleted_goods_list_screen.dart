import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:planup/tmc/presentation/blocs/get_deleted_goods_bloc/get_deleted_goods_list_bloc.dart';
import 'package:planup/tmc/presentation/widgets/custom_row.dart';

class DeletedGoodsListScreen extends StatefulWidget {
  const DeletedGoodsListScreen({super.key});

  @override
  State<DeletedGoodsListScreen> createState() => _TradeHistoryListScreenState();
}

class _TradeHistoryListScreenState extends State<DeletedGoodsListScreen> {
  @override
  void initState() {
    BlocProvider.of<GetDeletedGoodsListBloc>(context)
        .add(GetDeletedGoodsListEvent());
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
      body: BlocBuilder<GetDeletedGoodsListBloc, GetDeletedGoodsListState>(
        builder: (context, state) {
          if (state is GetDeletedGoodsListLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is GetDeletedGoodsListSuccess) {
            return ListView.builder(
              itemCount: state.modelList?.length ?? 0,
              itemBuilder: (context, index) {
                String timestamp =
                    state.modelList[index].deleted?.toString() ?? "";
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
                            text: state.modelList[index].id?.toString() ?? ""),
                        const Divider(),
                        CustomRow(
                            title: "Производитель",
                            text: state.modelList[index].product?.manufacture
                                    ?.name ??
                                ""),
                        const Divider(),
                        CustomRow(
                            title: "Модель",
                            text: state.modelList[index].product?.model?.name ??
                                ""),
                        const Divider(),
                        CustomRow(
                            title: "Стоимость",
                            text: "${state.modelList[index].product?.cost
                                    ?.toString() ??
                                ""} сом"),
                        const Divider(),

                        CustomRow(
                            title: "Номер продукта",
                            text: state.modelList[index].product?.id
                                    ?.toString() ??
                                ""),
                        const Divider(),
                        CustomRow(
                            title: "Дата удаления", text: formattedDate ?? ""),
                        const Divider(),

                        // CustomRow(
                        //     title: "Статус",
                        //     text: convertStatusToString(
                        //         id: state.modelList.data?[index].tradeStatusId ?? 0)),
                        // const Divider(),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is GetDeletedGoodsListError) {
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
      DateTime dateTime = DateTime.parse(timestamp).toLocal();
      return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
    } catch (e) {
      // Handle the error or return null if the timestamp is not valid
      return null;
    }
  }
}
