import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:planup/tmc/presentation/blocs/get_categories_bloc/get_categories_content_bloc.dart';
import 'package:planup/tmc/presentation/widgets/custom_row.dart';

class OneCategoriesContent extends StatefulWidget {
  final String urlRoute;
  const OneCategoriesContent({super.key, required this.urlRoute});

  @override
  State<OneCategoriesContent> createState() => _OneCategoriesContentState();
}

class _OneCategoriesContentState extends State<OneCategoriesContent> {
  @override
  void initState() {
    BlocProvider.of<GetCategoriesContentBloc>(context)
        .add(GetCategoriesContentEvent(urlRoute: widget.urlRoute));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffD5E2F2),
        appBar: AppBar(
          backgroundColor: const Color(0xffD5E2F2),
          title: const Text("Мои материалы"),
        ),
        body: BlocBuilder<GetCategoriesContentBloc, GetCategoriesContentState>(
          builder: (context, state) {
            if (state is GetCategoriesContentLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is GetCategoriesContentSuccess) {
              return ListView.builder(
                  itemCount: state.categoryModelList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        GoRouter.of(context)
                            .pushNamed("detailedInfo", queryParameters: {
                          "manufacture": state
                                  .categoryModelList[index].manufacture?.name ??
                              "",
                          "model":
                              state.categoryModelList[index].model?.name ?? "",
                          "cost":
                              state.categoryModelList[index].cost.toString(),
                          "id": state.categoryModelList[index].id.toString()
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
                                title: "Производитель",
                                text: state.categoryModelList[index].manufacture
                                        ?.name ??
                                    "",
                              ),
                              const Divider(),
                              CustomRow(
                                title: "Модель",
                                text: state
                                        .categoryModelList[index].model?.name ??
                                    "",
                              ),
                              const Divider(),
                              CustomRow(
                                title: "Цена за единицу",
                                text: state.categoryModelList[index].cost
                                    .toString(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            } else if (state is GetCategoriesContentError) {
              return Center(
                child: Text(state.errorText),
              );
            }
            return const SizedBox();
          },
        ));
  }
}

class CardModel {
  final String title;
  final String text;
  CardModel({required this.title, required this.text});
}
