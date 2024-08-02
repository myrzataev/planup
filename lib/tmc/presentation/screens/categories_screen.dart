import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:planup/tmc/presentation/widgets/custom_categories_card.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffD5E2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xffD5E2F2),
        title: const Text("Мои материалы"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomCategoriesCard(
              onTap: () {
                GoRouter.of(context).pushNamed("oneCategory",
                    queryParameters: {"urlRoute": "cable/?skip=0&limit=5000"});
              },
              title: "Кабели",
            ),
            CustomCategoriesCard(
              onTap: () {
                GoRouter.of(context).pushNamed("oneCategory", queryParameters: {
                  "urlRoute": "adapter/?skip=0&limit=5000"
                });
              },
              title: "Адаптеры",
            ),
            CustomCategoriesCard(
              onTap: () {
                GoRouter.of(context).pushNamed("oneCategory",
                    queryParameters: {"urlRoute": "clamp/?skip=0&limit=5000"});
              },
              title: "Зажимы",
            ),
            CustomCategoriesCard(
              onTap: () {
                GoRouter.of(context).pushNamed("oneCategory", queryParameters: {
                  "urlRoute": "media_converter/?skip=0&limit=5000"
                });
              },
              title: "Медиаконвертер",
            ),
            CustomCategoriesCard(
              onTap: () {
                GoRouter.of(context).pushNamed("oneCategory",
                    queryParameters: {"urlRoute": "odf/?skip=0&limit=5000"});
              },
              title: "ОДФ",
            ),
            CustomCategoriesCard(
              onTap: () {
                GoRouter.of(context).pushNamed("oneCategory",
                    queryParameters: {"urlRoute": "onu/?skip=0&limit=5000"});
              },
              title: "ОНУ",
            ),
            CustomCategoriesCard(
              onTap: () {
                GoRouter.of(context).pushNamed("oneCategory", queryParameters: {
                  "urlRoute": "patch_cord/?skip=0&limit=5000"
                });
              },
              title: "Соединительный шнур",
            ),
            CustomCategoriesCard(
              onTap: () {
                GoRouter.of(context).pushNamed("oneCategory", queryParameters: {
                  "urlRoute": "set_top_box/?skip=0&limit=5000"
                });
              },
              title: "Телеприставка",
            ),
            CustomCategoriesCard(
              onTap: () {
                GoRouter.of(context).pushNamed("oneCategory", queryParameters: {
                  "urlRoute": "sfp_module/?skip=0&limit=5000"
                });
              },
              title: "модуль SFP",
            ),
            CustomCategoriesCard(
              onTap: () {
                GoRouter.of(context).pushNamed("oneCategory", queryParameters: {
                  "urlRoute": "splitter/?skip=0&limit=5000"
                });
              },
              title: "Разделитель",
            ),
            CustomCategoriesCard(
              onTap: () {
                GoRouter.of(context).pushNamed("oneCategory", queryParameters: {
                  "urlRoute": "straight_bracket/?skip=0&limit=5000"
                });
              },
              title: "Кронштейн",
            ),
            CustomCategoriesCard(
              onTap: () {
                GoRouter.of(context).pushNamed("oneCategory", queryParameters: {
                  "urlRoute": "utp_cable/?skip=0&limit=5000"
                });
              },
              title: "utp-кабели",
            ),
          ],
        ),
      ),
    );
  }
}

