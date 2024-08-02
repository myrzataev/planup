import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:planup/core/services/shared_preferences_init.dart';
import 'package:planup/tmc/data/models/make_multiple_trade_model.dart';
import 'package:planup/tmc/data/models/users_model.dart';
import 'package:planup/tmc/presentation/blocs/get_users_bloc/get_users_bloc.dart';
import 'package:planup/tmc/presentation/blocs/trade_multiple_goods_bloc/trade_multiple_goods_bloc.dart';
import 'package:planup/tmc/presentation/blocs/transfer_good_bloc/transfer_good_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TradeGoodsScreen extends StatefulWidget {
  final String goodID;
  final String statusId;
  final bool isMultipleTrade;
  final List<Trade>? goodsList;
  const TradeGoodsScreen(
      {super.key,
      required this.goodID,
      required this.statusId,
      this.isMultipleTrade = false,
      this.goodsList});

  @override
  State<TradeGoodsScreen> createState() => _TradeGoodsScreenState();
}

class _TradeGoodsScreenState extends State<TradeGoodsScreen> {
  List<UsersModel> usersList = [];
  String? value;
  bool isUserChoosed = false;
  TextEditingController controller = TextEditingController();
  SharedPreferences preferences = locator<SharedPreferences>();
  int? destinationUserId;
  TextEditingController commentController = TextEditingController();

  void _submit() {
    setState(() {
      widget.goodsList?.forEach((trade) {
        trade.destinationUserId = destinationUserId;
      });
    });

    // Navigate to the submission screen or handle the trades list as needed
  }

  @override
  void initState() {
    BlocProvider.of<GetUsersBloc>(context).add(GetUsersEvent());
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffD5E2F2),
        appBar: AppBar(
          backgroundColor: const Color(0xffD5E2F2),
          title: const Text("Трейд"),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.w),
          child: BlocConsumer<GetUsersBloc, GetUsersState>(
            listener: (context, state) {
              if (state is GetUsersSuccess) {
                setState(() {
                  usersList = state.model;
                });
              }
            },
            builder: (context, state) {
              if (state is GetUsersLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is GetUsersSuccess) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Выберите пользователя для передачи товара",
                        style: TextStyle(
                            fontFamily: "SanSerif",
                            fontWeight: FontWeight.w700,
                            fontSize: 25.sp),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        child: Text(
                          "После передачи товара другому у вас больше не будет доступа к нему!",
                          style: TextStyle(
                              fontFamily: "SanSerif",
                              fontWeight: FontWeight.w700,
                              fontSize: 20.sp,
                              color: Colors.black87.withOpacity(0.5)),
                        ),
                      ),
                      SizedBox(
                          width: double.infinity,
                          child: DropdownMenu<String>(
                            width: 330.w,
                            label: const Text("Выберите пользователья"),
                            controller: controller,
                            requestFocusOnTap: true,
                            dropdownMenuEntries: usersList
                                .map((toElement) => DropdownMenuEntry(
                                    value: toElement.id?.toString() ?? "",
                                    label: toElement.fullName ?? ""))
                                .toList(),
                            enableFilter: true,
                            onSelected: (value) {
                              setState(() {
                                isUserChoosed = true;
                                destinationUserId = int.parse(value ?? "0");
                                _submit();
                              });
                            },
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: MaterialButton(
                          onPressed: isUserChoosed
                              ? () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: const Text("Комментарий"),
                                            actions: [
                                              Column(
                                                children: [
                                                  TextFormField(
                                                    controller:
                                                        commentController,
                                                  ),
                                                  MaterialButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    color: Colors.red,
                                                    child:
                                                        const Text("Закрыть"),
                                                  ),
                                                  MaterialButton(
                                                    onPressed: () {
                                                      widget.isMultipleTrade
                                                          ? BlocProvider.of<TradeMultipleGoodsBloc>(context).add(
                                                              TradeMultipleGoodsEvent(
                                                                  model: MakeMultipleTradeModel(
                                                                      trades: widget
                                                                          .goodsList)))
                                                          : BlocProvider.of<TransferGoodBloc>(context).add(TransferGoodEvent(
                                                              sourceUserId: preferences
                                                                      .getInt(
                                                                          "userNameForTmc")
                                                                      ?.toString() ??
                                                                  "",
                                                              destinationUserId:
                                                                  destinationUserId ??
                                                                      0,
                                                              goodID:
                                                                  widget.goodID,
                                                              tradeStatusId:
                                                                  widget
                                                                      .statusId,
                                                              comment:
                                                                  commentController
                                                                      .text));
                                                      Navigator.pop(context);
                                                    },
                                                    color: Colors.blue,
                                                    child:
                                                        const Text("Передать"),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ));
                                }
                              : null,
                          color: Colors.blueAccent,
                          child: const Text("Передать"),
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            print(
                                widget.goodsList?.first.destinationUserId ?? 0);
                          },
                          child: const Text("dfafa")),
                      widget.isMultipleTrade
                          ? BlocListener<TradeMultipleGoodsBloc, TradeMultipleGoodsState>(
                              listener: (context, state) {
                                if (state is TradeMultipleGoodsLoading) {
                                  Loader.show(context);
                                } else if (state is TradeMultipleGoodsSuccess) {
                                  Loader.hide();
                                  context.goNamed("allgoods");
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: const Text(
                                                "Вы успешно передали товар"),
                                            actions: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("Закрыть"))
                                            ],
                                          ));
                                } else if (state is TradeMultipleGoodsError) {
                                  Loader.hide();
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  Text(state.errorText),
                                                ],
                                              ),
                                            ),
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
                            )
                          : BlocListener<TransferGoodBloc, TransferGoodState>(
                              listener: (context, state) {
                                if (state is TransferGoodLoading) {
                                  Loader.show(context);
                                } else if (state is TransferGoodSuccess) {
                                  Loader.hide();
                                  context.goNamed("allgoods");
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: const Text(
                                                "Вы успешно передали товар"),
                                            actions: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("Закрыть"))
                                            ],
                                          ));
                                } else if (state is TransferGoodError) {
                                  Loader.hide();
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: Text(state.errorText),
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
                            )
                    ],
                  ),
                );
              } else if (state is GetUsersError) {
                return Text(state.errorText);
              }
              return const SizedBox();
            },
          ),
        ));
  }
}
