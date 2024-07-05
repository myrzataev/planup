import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:planup/tmc/presentation/blocs/delete_good_bloc/delete_good_bloc.dart';
import 'package:planup/tmc/presentation/screens/all_goods_screen.dart';
import 'package:planup/tmc/presentation/widgets/custom_row.dart';

// ignore: must_be_immutable
class DetailedInfoScreen extends StatelessWidget {
  final String manufacture;
  final String model;
  final String cost;
  final String id;
  final String category;
  File? photo;
  final String barcode;
  final String nazvanieID;
  final String deleted;
  final String goodStatus;

  DetailedInfoScreen(
      {super.key,
      required this.manufacture,
      required this.model,
      required this.cost,
      required this.id,
      required this.category,
      required this.barcode,
      required this.nazvanieID,
      required this.deleted,
      required this.goodStatus,
      this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffD5E2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xffD5E2F2),
        title: const Text("Детальная информация"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        CustomRow(
                          title: "Номер товара",
                          text: id,
                        ),
                        const Divider(),
                        CustomRow(
                          title: "Категория",
                          text: category,
                        ),
                        const Divider(),
                        CustomRow(
                          title: "Производитель",
                          text: manufacture,
                        ),
                        const Divider(),
                        CustomRow(
                          title: "Модель",
                          text: model,
                        ),
                        const Divider(),
                        CustomRow(
                          title: "Цена за единицу",
                          text: cost,
                        ),

                        const Divider(),
                        CustomRow(
                          title: "Статус товара",
                          text: ConvertGoodsStatusToString.goodStatus(
                              id: int.parse(goodStatus)),
                        ),
                        const Divider(),
                        CustomRow(title: "Штрих код", text: barcode),
                        const Divider(),
                        if (photo != null)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            child: Image.file(photo!),
                          ),
                        // const CustomRow(
                        //   title: "Бренд",
                        //   text: "Tp Link",
                        // ),
                        // const Divider(),
                        // const CustomRow(
                        //   title: "Модель",
                        //   text: "D-0023",
                        // ),
                        // const Divider(),
                        // const CustomRow(
                        //   title: "Код",
                        //   text: "ау9212у",
                        // ),
                        // const Divider(),

                        // const Divider(),

                        // const CustomRow(
                        //   title: "Ответственный",
                        //   text: "Мурат Мырзатаев",
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: MaterialButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const Text(
                                        "Вы точно хотите удалить товар?"),
                                    actions: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          MaterialButton(
                                            color: Colors.blueAccent,
                                            onPressed: () {
                                              BlocProvider.of<DeleteGoodBloc>(
                                                      context)
                                                  .add(DeleteGoodEvent(id: id));
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Удалить"),
                                          ),
                                          MaterialButton(
                                            color: Colors.red,
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Отмена"),
                                          )
                                        ],
                                      )
                                    ],
                                  ));
                        },
                        color: Colors.redAccent,
                        child: const Text("Удалить товар"),
                      ),
                    ),
                  ),
                  BlocListener<DeleteGoodBloc, DeleteGoodState>(
                    listener: (context, state) {
                      if (state is DeleteGoodLoading) {
                        Loader.show(context);
                      } else if (state is DeleteGoodSuccess) {
                        Loader.hide();
                        GoRouter.of(context).pop();
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text("Товар успешно удален"),
                                  actions: [
                                    MaterialButton(
                                      color: Colors.blue,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Закрыть"),
                                    )
                                  ],
                                ));
                      } else if (state is DeleteGoodError) {
                        Loader.hide();
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text("Товар не удален"),
                                  actions: [
                                    MaterialButton(
                                      color: Colors.blue,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Закрыть"),
                                    )
                                  ],
                                ));
                      }
                    },
                    child: const SizedBox(),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: MaterialButton(
                        onPressed: () {
                          GoRouter.of(context).pushNamed("editTMC",
                              queryParameters: {
                                "id": id,
                                "nazvanieID": nazvanieID,
                                "deleted": deleted
                              });
                        },
                        color: Colors.blueAccent,
                        child: const Text("Редактировать товар"),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: MaterialButton(
                        onPressed: () {
                          GoRouter.of(context).pushNamed("trade",
                              queryParameters: {"goodId": id});
                        },
                        color: Colors.blueAccent,
                        child: const Text("Передать товар"),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
