
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:planup/tmc/data/mock_data/card_categories_model.dart';
import 'package:planup/tmc/data/models/all_goods_model.dart';
import 'package:planup/tmc/presentation/blocs/get_all_goods_bloc/get_all_goods_bloc.dart';
import 'package:planup/tmc/presentation/widgets/custom_row.dart';

class AllGoodsScreen extends StatefulWidget {
  const AllGoodsScreen({super.key});

  @override
  State<AllGoodsScreen> createState() => _AllGoodsScreenState();
}

class _AllGoodsScreenState extends State<AllGoodsScreen> {
  List<Datum> allGoodsList = [];
  List<Datum> allGoodsListCopy = [];
  bool isInitialized = false; // Flag to check if data is already initialized
  String? categoryValue;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetAllGoodsBloc>(context)
        .add(const GetAllGoodsEvent(skip: "1"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffD5E2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xffD5E2F2),
        title: const Text("Мои ТМЦ"),
      ),
      body: BlocBuilder<GetAllGoodsBloc, GetAllGoodsState>(
        builder: (context, state) {
          print('Current state: $state');
          if (state is GetAllGoodsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is GetAllGoodsSuccess) {
            if (!isInitialized) {
              allGoodsList = state.allGoodsModelList.data??[];
              allGoodsListCopy = List.from(allGoodsList);
              isInitialized = true; // Set the flag to true after initialization
            }
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 5.w),
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
                      items: CardCategoriesCardData.categoriesList
                          .map((toElement) => DropdownMenuItem(
                                value: toElement.name,
                                child: Text(toElement.value),
                              ))
                          .toList(),
                      value: categoryValue,
                      onChanged: (value) {
                        setState(() {
                          categoryValue = value!;
                          BlocProvider.of<GetAllGoodsBloc>(context).add(
                              GetAllGoodsEvent(skip: "1", productType: value));
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.allGoodsModelList.data?.length??0,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          GoRouter.of(context)
                              .pushNamed("detailedInfo", queryParameters: {
                            "manufacture": state.allGoodsModelList.data?[index]
                                    .product?.manufacture?.name ??
                                "",
                            "model": state.allGoodsModelList.data?[index].product
                                    ?.model?.name ??
                                "",
                            "cost": state.allGoodsModelList.data?[index].product?.cost
                                    .toString() ??
                                "Не указано",
                            "id":
                                state.allGoodsModelList.data?[index].id?.toString() ??
                                    "Не указано",
                            "category":
                                state.allGoodsModelList.data?[index].productType ??
                                    "Не указано",
                            "barcode": state.allGoodsModelList.data?[index].barcode ??
                                "Не указано",
                            "goodStatus":
                                state.allGoodsModelList.data?[index].goodStatus?.id.toString() ??
                                    "",
                            "deleted":
                                state.allGoodsModelList.data?[index].deleted ?? "",
                            "nazvanieID": state
                                    .allGoodsModelList.data?[index].nazvanieId
                                    ?.toString() ??
                                ""
                          });
                        },
                        child: Card(
                          elevation: 0.7,
                          shadowColor: Colors.black12,
                          color: const Color(0xffEDF5FF),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                CustomRow(
                                  title: "Номер товара",
                                  text: state.allGoodsModelList.data?[index].id
                                      .toString()??"",
                                ),
                                const Divider(),
                                CustomRow(
                                  title: "Категория",
                                  text: state.allGoodsModelList.data?[index]
                                          .productType ??
                                      "",
                                ),
                                const Divider(),
                                CustomRow(
                                  title: "Статус товара",
                                  text: ConvertGoodsStatusToString.goodStatus(
                                      id: state.allGoodsModelList.data?[index]
                                              .goodStatus?.id ??
                                          0),
                                ),
                                const Divider(),
                                CustomRow(
                                  title: "Производитель",
                                  text: state.allGoodsModelList.data?[index].product
                                          ?.manufacture?.name ??
                                      "",
                                ),
                                const Divider(),
                                CustomRow(
                                  title: "Модель",
                                  text: state.allGoodsModelList.data?[index].product
                                          ?.model?.name ??
                                      "",
                                ),
                                const Divider(),
                                CustomRow(
                                    title: "Цена за единицу",
                                    text: state.allGoodsModelList.data?[index].product
                                            ?.cost
                                            .toString() ??
                                        "Не указано"),
                                const Divider(),
                                CustomRow(
                                    title: "Штрих код",
                                    text: state
                                            .allGoodsModelList.data?[index].barcode ??
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
            );
          } else if (state is GetAllGoodsError) {
            return Center(
              child: Text(state.errorText),
            );
          }
          return const SizedBox();
        },
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
        return "у НУ";
      case 3:
        return "У СИ";
      default:
        return "Неизвестно";
    }
  }
}
