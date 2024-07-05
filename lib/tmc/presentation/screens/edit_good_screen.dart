import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:planup/tmc/data/mock_data/card_categories_model.dart';
import 'package:planup/tmc/data/mock_data/good_statuses.dart';
import 'package:planup/tmc/data/models/manufacture_model.dart';
import 'package:planup/tmc/data/models/models_model.dart';
import 'package:planup/tmc/presentation/blocs/create_new_manifacture_bloc/create_new_manifacture_bloc.dart';
import 'package:planup/tmc/presentation/blocs/create_new_model_bloc/create_new_model_bloc.dart';
import 'package:planup/tmc/presentation/blocs/edit_good_bloc/edit_good_bloc.dart';
import 'package:planup/tmc/presentation/blocs/get_manufactures_bloc/get_manufactures_list_bloc.dart';
import 'package:planup/tmc/presentation/blocs/get_models_list_bloc/get_models_list_bloc.dart';

class EditTmcScreen extends StatefulWidget {
  final String id;
  final String deleted;
  final String nazvanieID;
  const EditTmcScreen(
      {super.key,
      required this.id,
      required this.deleted,
      required this.nazvanieID});

  @override
  State<EditTmcScreen> createState() => _CreateTmcScreenState();
}

class _CreateTmcScreenState extends State<EditTmcScreen> {
  final _formkey = GlobalKey<FormState>();

  String categoryDropdownMenuItem =
      CardCategoriesCardData.categoriesList.first.name;
  String manufacturesValue = "";
  bool isManufactureActive = false;
  List<ManufactureModel> manufacturesList = [];
  String modelDropdownsValue = "1";
  String statusDropdownValue = "";
  List<GoodsModelsModel> modelsList = [];
  List<GoodStatusesModel> goodStatusesList = GoodStatusesData.goodStatusesList;
  TextEditingController costController = TextEditingController();
  TextEditingController barCodeController = TextEditingController();
  TextEditingController newManufacturesNameController = TextEditingController();
  TextEditingController newModelsNameController = TextEditingController();
  String newManufacturesValue = "";
  String newModelsValue = "";
  String urlRoute = "";
  String productManufactureId = "";
  String productModelId = "";
  File? image;
  Future pickImage({required bool isFromCamera}) async {
    try {
      final image = await ImagePicker().pickImage(
          source: isFromCamera ? ImageSource.camera : ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (_) {
      // print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffD5E2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xffD5E2F2),
        title: const Text("Редактировать ТМЦ"),
      ),
      body: Form(
          key: _formkey,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
            child: SingleChildScrollView(
              child: MultiBlocListener(
                listeners: [
                  BlocListener<GetManufacturesListBloc,
                      GetManufacturesListState>(
                    listener: (context, state) {
                      if (state is GetManufacturesListLoading) {
                        Loader.show(context,
                            progressIndicator:
                                const CircularProgressIndicator());
                      } else if (state is GetManufacturesListSuccess) {
                        Loader.hide();
                        setState(() {
                          isManufactureActive = true;
                          manufacturesList = state.listModel.toSet().toList();
                        });
                      } else if (state is GetManufacturesListError) {
                        Loader.hide();
                      }
                    },
                  ),
                  BlocListener<GetModelsListBloc, GetModelsListState>(
                    listener: (context, state) {
                      if (state is GetModelsListLoading) {
                        Loader.show(context);
                      } else if (state is GetModelsListSuccess) {
                        Loader.hide();
                        setState(() {
                          modelsList = state.modelsList.toSet().toList();
                        });
                      } else if (state is GetModelsListError) {
                        Loader.hide();
                      }
                    },
                  ),
                ],
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
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
                          onChanged: (value) {
                            setState(() {
                              categoryDropdownMenuItem = value!;
                              urlRoute = value;
                              BlocProvider.of<GetManufacturesListBloc>(context)
                                  .add(GetManufacturesListEvent(
                                      urlRoute:
                                          "${value}_manufactures/?skip=0&limit=5000000"));
                              BlocProvider.of<GetModelsListBloc>(context).add(
                                  GetModelsListEvent(
                                      urlRoute:
                                          "${value}_models/?skip=0&limit=5000000"));
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Обязательное поле";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: SizedBox(
                        width: double.infinity,
                        child: DropdownButtonFormField(
                          isExpanded: true,
                          hint: const Text("Выберите производителя"),
                          decoration: InputDecoration(
                            fillColor: const Color(0xffEDF5FF),
                            filled: true,
                            labelText: "Производитель",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          items: [
                            const DropdownMenuItem(
                              value:
                                  'default', // Add a unique value for the default item
                              child: Text(
                                  'Создать производителя'), // Default item text
                            ),
                            ...manufacturesList
                                .map((element) => DropdownMenuItem(
                                    value: element.id,
                                    child: Text(element.name ?? "")))
                                .toList()
                          ],
                          onChanged: (e) {
                            if (e == 'default') {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title:
                                            const Text("Создать производителя"),
                                        actions: [
                                          Column(
                                            children: [
                                              SizedBox(
                                                width: double.infinity,
                                                child: DropdownButtonFormField(
                                                  hint: const Text(
                                                      "Выберите категорию"),
                                                  decoration: InputDecoration(
                                                    fillColor:
                                                        const Color(0xffEDF5FF),
                                                    filled: true,
                                                    labelText: "Категорий",
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                  ),
                                                  items: CardCategoriesCardData
                                                      .categoriesList
                                                      .map((toElement) =>
                                                          DropdownMenuItem(
                                                            value:
                                                                toElement.name,
                                                            child: Text(
                                                                toElement
                                                                    .value),
                                                          ))
                                                      .toList(),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      newManufacturesValue =
                                                          value!;
                                                    });
                                                  },
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                child: SizedBox(
                                                    width: double.infinity,
                                                    child: TextFormField(
                                                      controller:
                                                          newManufacturesNameController,
                                                      decoration:
                                                          InputDecoration(
                                                        fillColor: const Color(
                                                            0xffEDF5FF),
                                                        filled: true,
                                                        labelText:
                                                            "Название производителя",
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                      ),
                                                    )),
                                              ),
                                              MaterialButton(
                                                color: Colors.blue,
                                                onPressed: () {
                                                  BlocProvider.of<
                                                              CreateNewManifactureBloc>(
                                                          context)
                                                      .add(CreateNewManifactureEvent(
                                                          nameOfManifacture:
                                                              newManufacturesNameController
                                                                  .text,
                                                          urlRoute:
                                                              "${newManufacturesValue}_manufactures"));
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Создать"),
                                              )
                                            ],
                                          )
                                        ],
                                      ));
                            } else {
                              setState(() {
                                manufacturesValue = e.toString();
                              });
                            }
                          },
                          validator: (value) {
                            if (value == null) {
                              return "Обязательное поле";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    BlocListener<CreateNewManifactureBloc,
                        CreateNewManifactureState>(
                      listener: (context, state) {
                        if (state is CreateNewManifactureLoading) {
                          Loader.show(context);
                        } else if (state is CreateNewManifactureSuccess) {
                          Loader.hide();
                          setState(() {
                            manufacturesList.add(state.model);
                          });
                        } else if (state is CreateNewManifactureError) {
                          Loader.hide();
                        }
                      },
                      child: const SizedBox(),
                    ),
                    BlocListener<CreateNewModelBloc, CreateNewModelState>(
                      listener: (context, state) {
                        if (state is CreateNewModelLoading) {
                          Loader.show(context);
                        } else if (state is CreateNewModelSuccess) {
                          Loader.hide();
                          setState(() {
                            modelsList.add(state.model);
                          });
                        } else if (state is CreateNewModelError) {
                          Loader.hide();
                        }
                      },
                      child: const SizedBox(),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: SizedBox(
                        width: double.infinity,
                        child: DropdownButtonFormField(
                          isExpanded: true,
                          hint: const Text("Выберите модель"),
                          decoration: InputDecoration(
                            fillColor: const Color(0xffEDF5FF),
                            filled: true,
                            labelText: "Модель",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          items: [
                            const DropdownMenuItem(
                              value:
                                  'default', // Add a unique value for the default item
                              child: Text(
                                  'Создать новую модель'), // Default item text
                            ),
                            ...modelsList
                                .map((toElement) => DropdownMenuItem(
                                      value: toElement.id,
                                      child: Text(toElement.name ?? ""),
                                    ))
                                .toList(),
                          ],
                          onChanged: (value) {
                            if (value == 'default') {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: const Text("Создать модель"),
                                        actions: [
                                          Column(
                                            children: [
                                              SizedBox(
                                                width: double.infinity,
                                                child: DropdownButtonFormField(
                                                  hint: const Text(
                                                      "Выберите категорию"),
                                                  decoration: InputDecoration(
                                                    fillColor:
                                                        const Color(0xffEDF5FF),
                                                    filled: true,
                                                    labelText: "Категорий",
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                  ),
                                                  items: CardCategoriesCardData
                                                      .categoriesList
                                                      .map((toElement) =>
                                                          DropdownMenuItem(
                                                            value:
                                                                toElement.name,
                                                            child: Text(
                                                                toElement
                                                                    .value),
                                                          ))
                                                      .toList(),
                                                  onChanged: (value) {
                                                    newModelsValue = value!;
                                                  },
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                child: SizedBox(
                                                    width: double.infinity,
                                                    child: TextFormField(
                                                      controller:
                                                          newModelsNameController,
                                                      decoration:
                                                          InputDecoration(
                                                        fillColor: const Color(
                                                            0xffEDF5FF),
                                                        filled: true,
                                                        labelText: "Модель",
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                      ),
                                                    )),
                                              ),
                                              MaterialButton(
                                                color: Colors.blue,
                                                onPressed: () {
                                                  BlocProvider.of<
                                                              CreateNewModelBloc>(
                                                          context)
                                                      .add(CreateNewModelEvent(
                                                          nameOfNewModel:
                                                              newModelsNameController
                                                                  .text,
                                                          urlRoute:
                                                              "${newModelsValue}_models"));
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Создать"),
                                              )
                                            ],
                                          )
                                        ],
                                      ));
                            } else {
                              setState(() {
                                modelDropdownsValue = value!.toString();
                              });
                            }
                          },
                          validator: (value) {
                            if (value == null) {
                              return "Обязательное поле";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: SizedBox(
                        width: double.infinity,
                        child: DropdownButtonFormField(
                          isExpanded: true,
                          hint: const Text("Выберите статус"),
                          decoration: InputDecoration(
                            fillColor: const Color(0xffEDF5FF),
                            filled: true,
                            labelText: "Статус",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          items: goodStatusesList
                              .map((element) => DropdownMenuItem(
                                    value: element.id,
                                    child: Text(element.name),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              statusDropdownValue = value!.toString();
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return "Обязательное поле";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: SizedBox(
                          width: double.infinity,
                          child: TextFormField(
                            controller: costController,
                            decoration: InputDecoration(
                              fillColor: const Color(0xffEDF5FF),
                              filled: true,
                              labelText: "Цена",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Обязательное поле";
                              }
                              return null;
                            },
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: SizedBox(
                          width: double.infinity,
                          child: TextFormField(
                            controller: barCodeController,
                            decoration: InputDecoration(
                              fillColor: const Color(0xffEDF5FF),
                              filled: true,
                              labelText: "Штрих код",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Обязательное поле";
                              }
                              return null;
                            },
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text("Фото товара"),
                            MaterialButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          actions: [
                                            Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    TextButton(
                                                        onPressed: () {
                                                          pickImage(
                                                              isFromCamera:
                                                                  false);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            "Галерея")),
                                                    TextButton(
                                                        onPressed: () {
                                                          pickImage(
                                                              isFromCamera:
                                                                  true);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            "Камера"))
                                                  ],
                                                ),
                                                MaterialButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  color: Colors.redAccent,
                                                  child: const Text("Закрыть"),
                                                )
                                              ],
                                            )
                                          ],
                                        ));
                              },
                              color: Colors.blueAccent,
                              child: const Text("Загрузить"),
                            ),
                          ],
                        ),
                      ),
                    ),
                    image == null
                        ? const SizedBox()
                        : Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            child: SizedBox(
                                width: double.infinity,
                                child: Image.file(image!)),
                          ),
                    Padding(
                      padding: EdgeInsets.only(top: 50.h),
                      child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: MaterialButton(
                            onPressed: () {
                              if (_formkey.currentState!.validate()) {
                                BlocProvider.of<EditGoodBloc>(context).add(
                                    EditGoodEvent(
                                        id: widget.id,
                                        barcode: barCodeController.text,
                                        goodStatusId: statusDropdownValue,
                                        productType: categoryDropdownMenuItem,
                                        deleted: widget.deleted,
                                        nazvanieID: widget.nazvanieID));
                                // BlocProvider.of<CreateCategoryBloc>(context)
                                //     .add(CreateCategoryEvent(
                                //         cost: costController.text,
                                //         productManufactureId: manufacturesValue,
                                //         productModelId: modelDropdownsValue,
                                //         urlRoute: urlRoute));
                              }
                            },
                            color: Colors.greenAccent,
                            child: const Text("Создать товар"),
                          ),
                        ),
                      ),
                    ),
                    // BlocListener<CreateCategoryBloc, CreateCategoryState>(
                    //   listener: (context, state) {
                    //     if (state is CreateCategoryLoading) {
                    //       Loader.show(context);
                    //     } else if (state is CreateCategorySuccess) {
                    //       Loader.hide();
                    //       BlocProvider.of<CreateNewGoodBloc>(context).add(
                    //           CreateNewGoodEvent(
                    //               id: state.model.id.toString(),
                    //               barcode: barCodeController.text,
                    //               goodStatusId: statusDropdownValue,
                    //               productType: categoryDropdownMenuItem,
                    //               photo: image));
                    //     } else if (state is CreateCategoryError) {
                    //       Loader.hide();
                    //     }
                    //   },
                    //   child: const SizedBox(),
                    // ),
                    BlocListener<EditGoodBloc, EditGoodState>(
                      listener: (context, state) {
                        print(state);
                        if (state is EditGoodLoading) {
                          Loader.show(context);
                        } else if (state is EditGoodSuccess) {
                          Loader.hide();
                          GoRouter.of(context).pushReplacementNamed(
                              "detailedInfo",
                              queryParameters: {
                                "category": state.model.productType ?? "",
                                "manufacture":
                                    state.model.product?.manufacture?.name ??
                                        "",
                                "model": state.model.product?.model?.name ?? "",
                                "cost": state.model.product?.cost.toString(),
                                "barcode": state.model.barcode ?? "",
                                "nazvanieID":
                                    state.model.nazvanieId?.toString() ?? "",
                                "deleted": state.model.deleted?.toString() ?? "",
                                "goodStatus": state.model.goodStatus?.id.toString() ?? "",
                                "id": state.model.id.toString(),
                                if (image != null) "photo": image!.path
                              });
                          // showDialog(
                          //   context: context,
                          //   builder: (context) => AlertDialog(
                          //     title:
                          //         const Text("Вы успешно создали новый товар"),
                          //     actions: [
                          //       MaterialButton(
                          //         color: Colors.blueAccent,
                          //         onPressed: () {
                          //           Navigator.pop(context);
                          //         },
                          //         child: const Text("Закрыть"),
                          //       )
                          //     ],
                          //   ),
                          // );
                        } else if (state is EditGoodError) {
                          Loader.hide();

                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Не удалось создать товар"),
                              actions: [
                                MaterialButton(
                                  color: Colors.blueAccent,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Закрыть"),
                                )
                              ],
                            ),
                          );
                        }
                      },
                      child: const SizedBox(),
                    ),
                    // ElevatedButton(
                    //     onPressed: () {
                    //       print(image!.path);
                    //     },
                    //     child: Text("fsg"))
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
