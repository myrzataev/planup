import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:planup/tmc/data/mock_data/card_categories_model.dart';
import 'package:planup/tmc/data/models/goods_model.dart';
import 'package:planup/tmc/data/models/make_multiple_trade_model.dart';
import 'package:planup/tmc/presentation/blocs/get_all_goods_bloc/get_all_goods_bloc.dart';
import 'package:planup/tmc/presentation/blocs/get_categories_list_bloc/get_categories_bloc.dart';
import 'package:planup/tmc/presentation/blocs/get_my_goods_bloc/get_my_goods_bloc.dart';
import 'package:planup/tmc/presentation/widgets/custom_row.dart';

class AllGoodsScreen extends StatefulWidget {
  const AllGoodsScreen({super.key});

  @override
  State<AllGoodsScreen> createState() => _AllGoodsScreenState();
}

class _AllGoodsScreenState extends State<AllGoodsScreen> {
  List<MyGoodsModel> allGoodsList = [];
  List<MyGoodsModel> allGoodsListCopy = [];
  bool isInitialized = false; // Flag to check if data is already initialized
  String? categoryValue;
  List<CategoriesCardModel> categories = [];
  Set<int> selectedIndices = <int>{};
  List<Trade> tradesList = [];
  bool isMultiSelecting = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetAllGoodsBloc>(context)
        .add(const GetAllGoodsEvent(skip: "1"));
    BlocProvider.of<GetCategoriesBloc>(context).add(GetCategoriesListEvent());
    BlocProvider.of<GetMyGoodsBloc>(context).add(const GetMyGoodsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffD5E2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xffD5E2F2),
        title: const Text("Мои материалы"),
        actions: [
          selectedIndices.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                    onPressed: () {
                      // print(tradesList.length);
                      GoRouter.of(context).pushNamed("trade",
                          queryParameters: {
                            "goodId": "1",
                            "trade": "1",
                            "isMultipleTrade": "true"
                          },
                          extra: tradesList);
                    },
                    color: Colors.greenAccent,
                    child: Text("Передать ${selectedIndices.length} материал"),
                  ),
                )
              : const SizedBox(),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocListener<GetCategoriesBloc, GetCategoriesState>(
            listener: (context, state) {
              if (state is GetCategoriesSuccess) {
                setState(() {
                  categories = state.modelList;
                });
              }
            },
            child: const SizedBox(),
          ),
          BlocBuilder<GetMyGoodsBloc, GetMyGoodsState>(
            builder: (context, state) {
              if (state is GetMyGoodsLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is GetMyGoodsSuccess) {
                if (!isInitialized) {
                  allGoodsList = state.modelList ?? [];
                  allGoodsListCopy = List.from(allGoodsList);
                  isInitialized =
                      true; // Set the flag to true after initialization
                }
                return Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.h, horizontal: 5.w),
                        child: SizedBox(
                          width: double.infinity,
                          child: DropdownButtonFormField(
                            hint: const Text("Выберите категорию"),
                            decoration: InputDecoration(
                              fillColor: const Color(0xffEDF5FF),
                              filled: true,
                              labelText: "Категорий",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            items: categories
                                .map((toElement) => DropdownMenuItem(
                                      value: toElement.type,
                                      child: Text(
                                          toElement.translations?.ru ?? ""),
                                    ))
                                .toList(),
                            value: categoryValue,
                            onChanged: (value) {
                              setState(() {
                                categoryValue = value!;
                                BlocProvider.of<GetMyGoodsBloc>(context)
                                    .add(GetMyGoodsEvent(productType: value));
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.modelList?.length ?? 0,
                          itemBuilder: (context, index) {
                            bool isSelected = selectedIndices.contains(index);
                            return InkWell(
                              onLongPress: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedIndices.remove(index);
                                    tradesList.remove(ListOfDataForMultiTrade(
                                        sourceUserId:
                                            state.modelList[index].userId ?? 0,
                                        goodId: state.modelList[index].id ?? 0,
                                        tradeStatusId: 1));
                                  } else {
                                    selectedIndices.add(index);
                                    tradesList.add(Trade(
                                        sourceUserId:
                                            state.modelList[index].userId ?? 0,
                                        goodId: state.modelList[index].id ?? 0,
                                        tradeStatusId: 1,
                                        destinationUserId: null));
                                  }
                                });
                              },
                              onTap: () {
                                if (selectedIndices.isEmpty) {
                                  GoRouter.of(context).pushNamed("detailedInfo",
                                      queryParameters: {
                                        "manufacture": state.modelList[index]
                                                .product?.manufacture?.name ??
                                            "",
                                        "model": state.modelList[index].product
                                                ?.model?.name ??
                                            "",
                                        "cost": state
                                                .modelList[index].product?.cost
                                                .toString() ??
                                            "Не указано",
                                        "id": state.modelList[index].id
                                                ?.toString() ??
                                            "Не указано",
                                        "category": state
                                                .modelList[index].productType ??
                                            "Не указано",
                                        "barcode":
                                            state.modelList[index].barcode ??
                                                "Не указано",
                                        "goodStatus": state
                                                .modelList[index].goodStatus?.id
                                                .toString() ??
                                            "",
                                        "deleted":
                                            state.modelList[index].deleted ??
                                                "",
                                        "nazvanieID": state
                                                .modelList[index].nazvanieId
                                                ?.toString() ??
                                            "",
                                        "photoFromBackend":
                                            state.modelList[index].photoPath ??
                                                null,
                                        "statusId": state
                                                .modelList[index].goodStatus?.id
                                                .toString() ??
                                            "1",
                                      });
                                } else {
                                  if (selectedIndices.isNotEmpty) {
                                    setState(() {
                                      if (isSelected) {
                                        selectedIndices.remove(index);
                                        tradesList.remove(
                                            ListOfDataForMultiTrade(
                                                sourceUserId: state
                                                        .modelList[index]
                                                        .userId ??
                                                    0,
                                                goodId:
                                                    state.modelList[index].id ??
                                                        0,
                                                tradeStatusId: 1));
                                      } else {
                                        selectedIndices.add(index);
                                        tradesList.add(Trade(
                                            sourceUserId:
                                                state.modelList[index].userId ??
                                                    0,
                                            goodId:
                                                state.modelList[index].id ?? 0,
                                            tradeStatusId: 1,
                                            destinationUserId: null));
                                      }
                                    });
                                  }
                                }
                              },
                              child: Card(
                                elevation: 0.7,
                                shadowColor: Colors.black12,
                                color: isSelected
                                    ? Colors.blue
                                    : const Color(0xffEDF5FF),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      CustomRow(
                                        title: "Номер товара",
                                        text: state.modelList[index].id
                                                .toString() ??
                                            "",
                                      ),
                                      const Divider(),
                                      CustomRow(
                                        title: "Категория",
                                        text: state
                                                .modelList[index].productType ??
                                            "",
                                      ),
                                      const Divider(),
                                      CustomRow(
                                        title: "Статус товара",
                                        text: ConvertGoodsStatusToString
                                            .goodStatus(
                                                id: state.modelList[index]
                                                        .goodStatus?.id ??
                                                    0),
                                      ),
                                      const Divider(),
                                      CustomRow(
                                        title: "Производитель",
                                        text: state.modelList[index].product
                                                ?.manufacture?.name ??
                                            "",
                                      ),
                                      const Divider(),
                                      CustomRow(
                                        title: "Модель",
                                        text: state.modelList[index].product
                                                ?.model?.name ??
                                            "",
                                      ),
                                      const Divider(),
                                      CustomRow(
                                          title: "Цена за единицу",
                                          text: state.modelList[index].product
                                                  ?.cost
                                                  .toString() ??
                                              "Не указано"),
                                      const Divider(),
                                      CustomRow(
                                          title: "Штрих код",
                                          text:
                                              state.modelList[index].barcode ??
                                                  "Не указано"),
                                      const Divider(),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is GetMyGoodsError) {
                return Center(
                  child: Center(child: Text(state.errorText)),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}

abstract class ConvertGoodsStatusToString {
  static String goodStatus({required int id}) {
    switch (id) {
      case 1:
        return "На складе";
      case 2:
        return "у началника участка";
      case 3:
        return "У сервис инженера";
      default:
        return "Неизвестно";
    }
  }
}

class ListOfDataForMultiTrade {
  final int sourceUserId;
  final int goodId;
  final int tradeStatusId;
  ListOfDataForMultiTrade(
      {required this.goodId,
      required this.sourceUserId,
      required this.tradeStatusId});
}
