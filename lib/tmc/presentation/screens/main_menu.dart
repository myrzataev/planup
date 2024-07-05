import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:planup/core/services/shared_preferences_init.dart';
import 'package:planup/tmc/presentation/blocs/login_bloc/login_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  SharedPreferences preferences = locator<SharedPreferences>();
  final storage = const FlutterSecureStorage();
  String? userName;
  String? password;
  bool? isAuthorized;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    userName = await storage.read(key: 'username');
    password = await storage.read(key: 'password');
    isAuthorized = preferences.getBool("isAuthorized");
    print(userName);
    print(password);
    print(isAuthorized);
    callBloc();
  }

  void callBloc() {
    BlocProvider.of<LoginBloc>(context)
        .add(LoginEvent(password: password ?? "", userName: userName ?? ""));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffD3E3F2),
        appBar: AppBar(
          backgroundColor: const Color(0xffD5E2F2),
          title: const Text(
            "ТМЦ",
            style: TextStyle(fontFamily: "SanSerif"),
          ),
        ),
        body: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              setState(() {
                preferences.setBool("isAuthorized", true);
                preferences.setString(
                    "bearerToken", state.model.accessToken ?? "");
                preferences.setInt("userNameForTmc", state.model.userId ?? 0);
              });
            }
          },
          builder: (context, state) {
            if (state is LoginLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is LoginSuccess) {
              return Column(children: [
                (state.model.permissionName == null ||
                        (state.model.permissionName == "Заведующий склада")
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        child: CustomTmcCard(
                          onTap: () {
                            GoRouter.of(context).pushNamed("createTMC");
                          },
                          icon: "asset/images/settings.png",
                          text: "Создать ТМЦ",
                        ),
                      )
                    : const SizedBox()),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  child: CustomTmcCard(
                    onTap: () {
                      GoRouter.of(context).pushNamed("chooseAction");
                    },
                    icon: "asset/images/team.png",
                    text: "Принять/Выдать ТМЦ",
                  ),
                ),
                // Padding(
                //   padding:
                //       const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                //   child: CustomTmcCard(
                //     onTap: () {
                //       GoRouter.of(context).pushNamed("trade");
                //     },
                //     icon: "asset/images/refund.png",
                //     text: "Отправка/возврат товара",
                //   ),
                // ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  child: CustomTmcCard(
                    onTap: () {
                      GoRouter.of(context).pushNamed("allgoods");
                    },
                    icon: "asset/images/portfolio.png",
                    text: "Мои ТМЦ",
                  ),
                ),
                // ElevatedButton(
                //     onPressed: () {
                //       print(preferences.getString("bearerToken"));
                //     },
                //     child: Text("fasne"))
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                //   child: CustomTmcCard(
                //     onTap: () {
                //       GoRouter.of(context).pushNamed("allgoods");
                //     },
                //     icon: "asset/images/trash.png",
                //     text: "Списание",
                //   ),
                // ),
              ]);
            } else if (state is LoginError) {
              return Text(state.errorText);
            }
            return const SizedBox();
          },
        ));
  }
}

class CustomTmcCard extends StatelessWidget {
  final String icon;
  final String text;
  final Function onTap;
  const CustomTmcCard(
      {super.key, required this.icon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        alignment: Alignment.center,
        height: 70,
        decoration: BoxDecoration(
          color: const Color(0xffEDF5FF),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Image.asset(icon),
              ),
            ),
            Text(
              text,
              style: const TextStyle(fontFamily: "SanSerif"),
            )
          ],
        ),
      ),
    );
  }
}
