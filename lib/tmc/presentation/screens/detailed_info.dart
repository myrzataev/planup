import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:planup/tmc/presentation/blocs/delete_good_bloc/delete_good_bloc.dart';
import 'package:planup/tmc/presentation/providers/user_role_provider.dart';
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
  String? photoFromBackend;
 final String statusId;

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
      this.photoFromBackend,
      required this.statusId,
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

                        (photoFromBackend != null ||
                                (photoFromBackend?.isNotEmpty ?? false))
                            ? Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width*0.9,
                                  child: Base64Image(

                                      defaultImagePath:
                                          "asset/images/not-found-img.png",
                                      base64String: photoFromBackend ?? ""),
                                ),
                              )
                            : const SizedBox(),
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
                  (context.watch<GetUserRoleProvider>().isAdmin ?? false)
                      ? SizedBox(
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
                                                    BlocProvider.of<
                                                                DeleteGoodBloc>(
                                                            context)
                                                        .add(DeleteGoodEvent(
                                                            id: id));
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
                        )
                      : const SizedBox(),
                  BlocListener<DeleteGoodBloc, DeleteGoodState>(
                    listener: (context, state) {
                      if (state is DeleteGoodLoading) {
                        Loader.show(context);
                      } else if (state is DeleteGoodSuccess) {
                        Loader.hide();
                        GoRouter.of(context).pushReplacementNamed("tmc7");
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
                              queryParameters: {"goodId": id, "trade": statusId});
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

class Base64Image extends StatelessWidget {
  final String base64String;
  final String defaultImagePath;

  const Base64Image(
      {required this.base64String, required this.defaultImagePath, super.key});

  @override
  Widget build(BuildContext context) {
    try {
      // Remove potential headers
      String cleanedBase64String =
          base64String.replaceAll(RegExp(r'data:image/[^;]+;base64,'), '');
      Uint8List bytes = base64Decode(cleanedBase64String);
      print(isValidImage(bytes));
      // Validate if the decoded bytes form a valid image
      if (isValidImage(bytes)) {
        return Image.memory(bytes);
      } else {
        return Image.asset(defaultImagePath);
      }
    } catch (e) {
      return Image.asset(defaultImagePath);
    }
  }

  bool isValidImage(Uint8List bytes) {
    try {
      // Try to decode image
      final image = Image.memory(bytes);
      return (image != null && bytes.isNotEmpty);
    } catch (e) {
      return false;
    }
  }
}
