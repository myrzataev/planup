import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications_platform_interface/src/types.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:planup/core/network/diosettings.dart';
import 'package:planup/core/notification/push_notification.dart';
import 'package:planup/core/services/shared_preferences_init.dart';
import 'package:planup/navigation/app_navigation.dart';
import 'package:planup/news/data/datasource/news_list_ds.dart';
import 'package:planup/news/data/repository/news_list_model.dart';
import 'package:planup/news/presentation/blocs/bloc/news_list_bloc.dart';
import 'package:planup/study/data/datasource/video_list_ds.dart';
import 'package:planup/study/data/repository/video_list_repoimpl.dart';
import 'package:planup/study/presentation/blocs/bloc/video_list_bloc.dart';
import 'package:planup/tmc/data/data_source/accept_trade_ds.dart';
import 'package:planup/tmc/data/data_source/create_category_ds.dart';
import 'package:planup/tmc/data/data_source/create_new_good_ds.dart';
import 'package:planup/tmc/data/data_source/create_new_manifacture_ds.dart';
import 'package:planup/tmc/data/data_source/create_new_model_ds.dart';
import 'package:planup/tmc/data/data_source/delete_goods_ds.dart';
import 'package:planup/tmc/data/data_source/deny_trade_ds.dart';
import 'package:planup/tmc/data/data_source/edit_good_ds.dart';
import 'package:planup/tmc/data/data_source/get_all_goods_ds.dart';
import 'package:planup/tmc/data/data_source/get_categories_content_ds.dart';
import 'package:planup/tmc/data/data_source/get_categories_list_ds.dart';
import 'package:planup/tmc/data/data_source/get_deleted_goods_ds.dart';
import 'package:planup/tmc/data/data_source/get_manufactures_list_ds.dart';
import 'package:planup/tmc/data/data_source/get_models_list_ds.dart';
import 'package:planup/tmc/data/data_source/get_my_goods_ds.dart';
import 'package:planup/tmc/data/data_source/get_my_trades_ds.dart';
import 'package:planup/tmc/data/data_source/get_trade_history_ds.dart';
import 'package:planup/tmc/data/data_source/get_user_trade_history_ds.dart';
import 'package:planup/tmc/data/data_source/get_users_ds.dart';
import 'package:planup/tmc/data/data_source/login_ds.dart';
import 'package:planup/tmc/data/data_source/trade_multiple_goods_ds.dart';
import 'package:planup/tmc/data/data_source/transfer_good_ds.dart';
import 'package:planup/tmc/data/repositories/accept_trade_repo_impl.dart';
import 'package:planup/tmc/data/repositories/create_category_impl.dart';
import 'package:planup/tmc/data/repositories/create_new_good_impl.dart';
import 'package:planup/tmc/data/repositories/create_new_manifacture_impl.dart';
import 'package:planup/tmc/data/repositories/create_new_model_impl.dart';
import 'package:planup/tmc/data/repositories/delete_goods_impl.dart';
import 'package:planup/tmc/data/repositories/deny_trade_impl.dart';
import 'package:planup/tmc/data/repositories/edit_good_repo_impl.dart';
import 'package:planup/tmc/data/repositories/get_all_goods_impl.dart';
import 'package:planup/tmc/data/repositories/get_categories_content_impl.dart';
import 'package:planup/tmc/data/repositories/get_categories_list_impl.dart';
import 'package:planup/tmc/data/repositories/get_deleted_goods_impl.dart';
import 'package:planup/tmc/data/repositories/get_manufactures_list.dart';
import 'package:planup/tmc/data/repositories/get_models_list.dart';
import 'package:planup/tmc/data/repositories/get_my_goods_impl.dart';
import 'package:planup/tmc/data/repositories/get_my_trades_impl.dart';
import 'package:planup/tmc/data/repositories/get_trade_hitory_impl.dart';
import 'package:planup/tmc/data/repositories/get_users_repo_impl.dart';
import 'package:planup/tmc/data/repositories/get_users_trade_histrory_impl.dart';
import 'package:planup/tmc/data/repositories/login_repo_impl.dart';
import 'package:planup/tmc/data/repositories/trade_multiple_goods_impl.dart';
import 'package:planup/tmc/data/repositories/transfer_good_impl.dart';
import 'package:planup/tmc/presentation/blocs/accept_trade_bloc/accept_trade_bloc.dart';
import 'package:planup/tmc/presentation/blocs/create_category_bloc/create_category_bloc.dart';
import 'package:planup/tmc/presentation/blocs/create_new_good_bloc/create_new_good_bloc.dart';
import 'package:planup/tmc/presentation/blocs/create_new_manifacture_bloc/create_new_manifacture_bloc.dart';
import 'package:planup/tmc/presentation/blocs/create_new_model_bloc/create_new_model_bloc.dart';
import 'package:planup/tmc/presentation/blocs/delete_good_bloc/delete_good_bloc.dart';
import 'package:planup/tmc/presentation/blocs/deny_trade_bloc/deny_trade_bloc.dart';
import 'package:planup/tmc/presentation/blocs/edit_good_bloc/edit_good_bloc.dart';
import 'package:planup/tmc/presentation/blocs/get_all_goods_bloc/get_all_goods_bloc.dart';
import 'package:planup/tmc/presentation/blocs/get_categories_bloc/get_categories_content_bloc.dart';
import 'package:planup/tmc/presentation/blocs/get_categories_list_bloc/get_categories_bloc.dart';
import 'package:planup/tmc/presentation/blocs/get_deleted_goods_bloc/get_deleted_goods_list_bloc.dart';
import 'package:planup/tmc/presentation/blocs/get_manufactures_bloc/get_manufactures_list_bloc.dart';
import 'package:planup/tmc/presentation/blocs/get_models_list_bloc/get_models_list_bloc.dart';
import 'package:planup/tmc/presentation/blocs/get_my_goods_bloc/get_my_goods_bloc.dart';
import 'package:planup/tmc/presentation/blocs/get_my_trades_bloc/get_my_trades_bloc.dart';
import 'package:planup/tmc/presentation/blocs/get_trades_history_bloc/get_trades_history_bloc.dart';
import 'package:planup/tmc/presentation/blocs/get_users_bloc/get_users_bloc.dart';
import 'package:planup/tmc/presentation/blocs/get_users_trade_history_bloc/get_user_trade_history_bloc.dart';
import 'package:planup/tmc/presentation/blocs/login_bloc/login_bloc.dart';
import 'package:planup/tmc/presentation/blocs/trade_multiple_goods_bloc/trade_multiple_goods_bloc.dart';
import 'package:planup/tmc/presentation/blocs/transfer_good_bloc/transfer_good_bloc.dart';
import 'package:planup/tmc/presentation/providers/user_role_provider.dart';
import 'package:planup/views/home/blocs/send_pdf_bloc/send_pdf_bloc.dart';
import 'package:planup/views/home/repositories/send_pdf_repo.dart';
import 'package:planup/views/start.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'login_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';

Future _firebaseBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (message.notification != null) {
    print("some notification received ${message.notification!.title}");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(
      (message) => _firebaseBackgroundMessage(message));
  initPrefs();
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {}
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    debugPrint("Hi i am opening");
    if (message.notification != null) {
      RegExp regex = RegExp(r"\d+"); // Matches one or more digits
      Match match = regex
          .firstMatch(message.notification?.body ?? "Номер наряда: 30401")!;
      String parsedNumber = match.group(0)!;
      AppNavigation.router.goNamed("workFromNotification",
          queryParameters: {"workId": parsedNumber ?? ""});
    }
    // Handle notification tap
    // ... (same as previous example)
  });
  await setupServiceLocator();

//   @pragma("vm:entry-point")
//   Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print("Handling a background message: ${message.notification?.body ?? ""}");
// }
  // FirebaseMessagingService.initialize();
  runApp(MyApp());
}

@override
void initState() {
  requestPermission();
  setupFirebaseMessagingListeners();
}

late SharedPreferences preferences;

void initPrefs() async {
  preferences = await SharedPreferences.getInstance();
}

void requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
      alert: true, badge: true, sound: true, announcement: true);
  print('User granted permission: ${settings.authorizationStatus}');

  PermissionStatus galleryStatus = await Permission.photos.status;
  if (galleryStatus.isGranted) {
    print('Доступ к галерее разрешен');
  } else if (galleryStatus.isDenied) {
    // Обработка случая, когда доступ к галерее отклонен
    print('Доступ к галерее отклонен');
  } else {
    // Обработка других случаев (например, когда доступ к галерее навсегда запрещен)
    print('Доступ к галерее неопределен');
  }
}

void setupFirebaseMessagingListeners() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      FirebaseMessagingService.onNotificationTap(
          message as NotificationResponse);
    }
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => SharedPreferencesRepository()),
        RepositoryProvider(create: (context) => DioSettings()),
        RepositoryProvider(
            create: (context) => VideoListDataSource(
                dio: RepositoryProvider.of<DioSettings>(context).dio)),
        RepositoryProvider(
            create: (context) => VideoListRepoimpl(
                dataSource:
                    RepositoryProvider.of<VideoListDataSource>(context))),
        RepositoryProvider(
            create: (context) => NewsListDataSource(
                dio: RepositoryProvider.of<DioSettings>(context).dio)),
        RepositoryProvider(
            create: (context) => NewsListRepoImpl(
                dataSource:
                    RepositoryProvider.of<NewsListDataSource>(context))),
        RepositoryProvider(
            create: (context) => LoginDs(
                dio: RepositoryProvider.of<DioSettings>(context).dio1,
                preferences:
                    RepositoryProvider.of<SharedPreferencesRepository>(context)
                        .prefs)),
        RepositoryProvider(
            create: (context) => LoginRepoImpl(
                dataSource: RepositoryProvider.of<LoginDs>(context))),
        RepositoryProvider(
            create: (context) => GetAllGoodsDs(
                dio: RepositoryProvider.of<DioSettings>(context).dio1)),
        RepositoryProvider(
            create: (context) => GetAllGoodsImpl(
                dataSource: RepositoryProvider.of<GetAllGoodsDs>(context))),
        RepositoryProvider(
            create: (context) => GetCategoriesContentDataSource(
                dio: RepositoryProvider.of<DioSettings>(context).dio1)),
        RepositoryProvider(
            create: (context) => GetCategoriesContentImpl(
                dataSource:
                    RepositoryProvider.of<GetCategoriesContentDataSource>(
                        context))),
        RepositoryProvider(
            create: (context) => GetManufacturesListDataSource(
                preferences:
                    RepositoryProvider.of<SharedPreferencesRepository>(context)
                        .prefs,
                dio: RepositoryProvider.of<DioSettings>(context).dio1)),
        RepositoryProvider(
            create: (context) => GetManufacturesListRepoImpl(
                dataSource:
                    RepositoryProvider.of<GetManufacturesListDataSource>(
                        context))),
        RepositoryProvider(
            create: (context) => GetModelsListDs(
                preferences:
                    RepositoryProvider.of<SharedPreferencesRepository>(context)
                        .prefs,
                dio: RepositoryProvider.of<DioSettings>(context).dio1)),
        RepositoryProvider(
            create: (context) => GetModelsListRepoImpl(
                dataSource: RepositoryProvider.of<GetModelsListDs>(context))),
        RepositoryProvider(
            create: (context) => DeleteGoodsDs(
                dio: RepositoryProvider.of<DioSettings>(context).dio1)),
        RepositoryProvider(
            create: (context) => DeleteGoodsImpl(
                dataSource: RepositoryProvider.of<DeleteGoodsDs>(context))),
        RepositoryProvider(
            create: (context) => CreateCategoryDs(
                preferences:
                    RepositoryProvider.of<SharedPreferencesRepository>(context)
                        .prefs,
                dio: RepositoryProvider.of<DioSettings>(context).dio1)),
        RepositoryProvider(
            create: (context) => CreateCategoryImpl(
                dataSource: RepositoryProvider.of<CreateCategoryDs>(context))),
        RepositoryProvider(
          create: (context) => CreateNewManifactureDs(
              preferences:
                  RepositoryProvider.of<SharedPreferencesRepository>(context)
                      .prefs,
              dio: RepositoryProvider.of<DioSettings>(context).dio1),
        ),
        RepositoryProvider(
            create: (context) => CreateNewManifactureImpl(
                dataSource:
                    RepositoryProvider.of<CreateNewManifactureDs>(context))),
        RepositoryProvider(
            create: (context) => CreateNewModelDs(
                preferences:
                    RepositoryProvider.of<SharedPreferencesRepository>(context)
                        .prefs,
                dio: RepositoryProvider.of<DioSettings>(context).dio1)),
        RepositoryProvider(
            create: (context) => CreateNewModelImpl(
                dataSource: RepositoryProvider.of<CreateNewModelDs>(context))),
        RepositoryProvider(
            create: (context) => CreateNewGoodDs(
                preferences:
                    RepositoryProvider.of<SharedPreferencesRepository>(context)
                        .prefs,
                dio: RepositoryProvider.of<DioSettings>(context).dio1)),
        RepositoryProvider(
            create: (context) => CreateNewGoodImpl(
                dataSource: RepositoryProvider.of<CreateNewGoodDs>(context))),
        RepositoryProvider(
            create: (context) => EditGoodDataSource(
                dio: RepositoryProvider.of<DioSettings>(context).dio1)),
        RepositoryProvider(
            create: (context) => EditGoodRepoImpl(
                dataSource:
                    RepositoryProvider.of<EditGoodDataSource>(context))),
        RepositoryProvider(
            create: (context) => GetUsersDataSource(
                dio: RepositoryProvider.of<DioSettings>(context).dio1)),
        RepositoryProvider(
            create: (context) => GetUsersRepoImpl(
                dataSource:
                    RepositoryProvider.of<GetUsersDataSource>(context))),
        RepositoryProvider(
            create: (context) => TransferGoodDs(
                dio: RepositoryProvider.of<DioSettings>(context).dio1,
                preferences:
                    RepositoryProvider.of<SharedPreferencesRepository>(context)
                        .prefs)),
        RepositoryProvider(
            create: (context) => TransferGoodImpl(
                dataSource: RepositoryProvider.of<TransferGoodDs>(context))),
        RepositoryProvider(
            create: (context) => GetTradeHistoryDs(
                dio: RepositoryProvider.of<DioSettings>(context).dio1,
                preferences:
                    RepositoryProvider.of<SharedPreferencesRepository>(context)
                        .prefs)),
        RepositoryProvider(
            create: (context) => GetTransactionsHitoryImpl(
                dataSource: RepositoryProvider.of<GetTradeHistoryDs>(context))),
        RepositoryProvider(
            create: (context) => GetMyTradesDs(
                dio: RepositoryProvider.of<DioSettings>(context).dio1,
                preferences:
                    RepositoryProvider.of<SharedPreferencesRepository>(context)
                        .prefs)),
        RepositoryProvider(
            create: (context) => GetMyTradesImpl(
                dataSource: RepositoryProvider.of<GetMyTradesDs>(context))),
        RepositoryProvider(
            create: (context) => AcceptTradeDs(
                dio: RepositoryProvider.of<DioSettings>(context).dio1,
                preferences:
                    RepositoryProvider.of<SharedPreferencesRepository>(context)
                        .prefs)),
        RepositoryProvider(
            create: (context) => AcceptTradeRepoImpl(
                dataSource: RepositoryProvider.of<AcceptTradeDs>(context))),
        RepositoryProvider(
            create: (context) => DenyTradeDs(
                dio: RepositoryProvider.of<DioSettings>(context).dio1,
                preferences:
                    RepositoryProvider.of<SharedPreferencesRepository>(context)
                        .prefs)),
        RepositoryProvider(
            create: (context) => DenyTradeImpl(
                dataSource: RepositoryProvider.of<DenyTradeDs>(context))),
        RepositoryProvider(
            create: (context) => GetUserTradeHistoryDs(
                dio: RepositoryProvider.of<DioSettings>(context).dio1,
                preferences:
                    RepositoryProvider.of<SharedPreferencesRepository>(context)
                        .prefs)),
        RepositoryProvider(
            create: (context) => GetUsersTradeHistroryImpl(
                dataSource:
                    RepositoryProvider.of<GetUserTradeHistoryDs>(context))),
        RepositoryProvider(
            create: (context) => GetDeletedGoodsDs(
                dio: RepositoryProvider.of<DioSettings>(context).dio1)),
        RepositoryProvider(
            create: (context) => GetDeletedGoodsImpl(
                deletedGoodsDs:
                    RepositoryProvider.of<GetDeletedGoodsDs>(context))),
        RepositoryProvider(
            create: (context) => GetCategoriesListDs(
                dio: RepositoryProvider.of<DioSettings>(context).dio1)),
        RepositoryProvider(
            create: (context) => GetCategoriesListImpl(
                dataSource:
                    RepositoryProvider.of<GetCategoriesListDs>(context))),
        RepositoryProvider(
            create: (context) => GetMyGoodsDs(
                dio: RepositoryProvider.of<DioSettings>(context).dio1,
                preferences:
                    RepositoryProvider.of<SharedPreferencesRepository>(context)
                        .prefs)),
        RepositoryProvider(
            create: (context) => GetMyGoodsImpl(
                dataSource: RepositoryProvider.of<GetMyGoodsDs>(context))),
        RepositoryProvider(
            create: (context) => TradeMultipleGoodsDs(
                dio: RepositoryProvider.of<DioSettings>(context).dio1,
                preferences:
                    RepositoryProvider.of<SharedPreferencesRepository>(context)
                        .prefs)),
        RepositoryProvider(
            create: (context) => TradeMultipleGoodsImpl(
                dataSource:
                    RepositoryProvider.of<TradeMultipleGoodsDs>(context))),
        RepositoryProvider(
            create: (context) => SendPdfRepo(
                dio: RepositoryProvider.of<DioSettings>(context).dio3))
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => VideoListBloc(
                  repoimpl: RepositoryProvider.of<VideoListRepoimpl>(context))),
          BlocProvider(
              create: (context) => NewsListBloc(
                  repoImpl: RepositoryProvider.of<NewsListRepoImpl>(context))),
          BlocProvider(
              create: (context) => LoginBloc(
                  repoImpl: RepositoryProvider.of<LoginRepoImpl>(context))),
          BlocProvider(
              create: (context) => GetAllGoodsBloc(
                  reposImpl: RepositoryProvider.of<GetAllGoodsImpl>(context))),
          BlocProvider(
              create: (context) => GetCategoriesContentBloc(
                  repoImpl: RepositoryProvider.of<GetCategoriesContentImpl>(
                      context))),
          BlocProvider(
              create: (context) => GetManufacturesListBloc(
                  repoImpl: RepositoryProvider.of<GetManufacturesListRepoImpl>(
                      context))),
          BlocProvider(
              create: (context) => GetModelsListBloc(
                  repoImpl:
                      RepositoryProvider.of<GetModelsListRepoImpl>(context))),
          BlocProvider(
              create: (context) => DeleteGoodBloc(
                  repoImpl: RepositoryProvider.of<DeleteGoodsImpl>(context))),
          BlocProvider(
              create: (context) => CreateCategoryBloc(
                  repositoryImpl:
                      RepositoryProvider.of<CreateCategoryImpl>(context))),
          BlocProvider(
              create: (context) => CreateNewManifactureBloc(
                  repoImpl: RepositoryProvider.of<CreateNewManifactureImpl>(
                      context))),
          BlocProvider(
              create: (context) => CreateNewModelBloc(
                  repoImpl:
                      RepositoryProvider.of<CreateNewModelImpl>(context))),
          BlocProvider(
              create: (context) => CreateNewGoodBloc(
                  repoImpl: RepositoryProvider.of<CreateNewGoodImpl>(context))),
          BlocProvider(
              create: (context) => EditGoodBloc(
                  repoImpl: RepositoryProvider.of<EditGoodRepoImpl>(context))),
          BlocProvider(
              create: (context) => GetUsersBloc(
                  repoImpl: RepositoryProvider.of<GetUsersRepoImpl>(context))),
          BlocProvider(
              create: (context) => TransferGoodBloc(
                  repoImpl: RepositoryProvider.of<TransferGoodImpl>(context))),
          BlocProvider(
              create: (context) => GetTradesHistoryBloc(
                  repoImpl: RepositoryProvider.of<GetTransactionsHitoryImpl>(
                      context))),
          BlocProvider(
              create: (context) => GetMyTradesBloc(
                  repositoryImpl:
                      RepositoryProvider.of<GetMyTradesImpl>(context))),
          BlocProvider(
              create: (context) => AcceptTradeBloc(
                  repoImpl:
                      RepositoryProvider.of<AcceptTradeRepoImpl>(context))),
          BlocProvider(
              create: (context) => DenyTradeBloc(
                  repoImpl: RepositoryProvider.of<DenyTradeImpl>(context))),
          BlocProvider(
              create: (context) => GetUserTradeHistoryBloc(
                  repoImpl: RepositoryProvider.of<GetUsersTradeHistroryImpl>(
                      context))),
          BlocProvider(
              create: (context) => GetDeletedGoodsListBloc(
                  repoImpl:
                      RepositoryProvider.of<GetDeletedGoodsImpl>(context))),
          BlocProvider(
              create: (context) => GetCategoriesBloc(
                  repoImpl:
                      RepositoryProvider.of<GetCategoriesListImpl>(context))),
          BlocProvider(
              create: (context) => GetMyGoodsBloc(
                  repoImpl: RepositoryProvider.of<GetMyGoodsImpl>(context))),
          BlocProvider(
              create: (context) => TradeMultipleGoodsBloc(
                  repoImpl:
                      RepositoryProvider.of<TradeMultipleGoodsImpl>(context))),
          BlocProvider(
              create: (context) => SendPdfBloc(
                  repo: RepositoryProvider.of<SendPdfRepo>(context)))
        ],
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => GetUserRoleProvider())
          ],
          child: ScreenUtilInit(
            designSize: const Size(360, 784),
            minTextAdapt: true,
            splitScreenMode: true,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              themeMode: ThemeMode.dark, // Установка тёмной темы
              darkTheme:
                  ThemeData.dark(), // Использование встроенной тёмной темы

              title: 'PlanUp',

              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                // Add other localization delegates you need
              ],
              supportedLocales: [
                const Locale('en', ''), // English
                const Locale('es', ''), // Spanish
                // Add other locales your app supports
              ],
              home: FutureBuilder(
                future: _tryAutoLogin(),
                builder: (context, snapshot) {
                  // Check if the future is complete
                  if (snapshot.connectionState == ConnectionState.done) {
                    // If we have data, it means auto login was successful
                    if (snapshot.hasData && snapshot.data == true) {
                      return Start();
                    } else {
                      return LoginScreen();
                      // return Start();
                    }
                  }
                  // While we're waiting, show a progress indicator
                  return Scaffold(
                    backgroundColor: Color.fromRGBO(25, 11, 54, 1.0),
                    body: Center(
                      child: Image.asset(
                        'asset/images/splash.png', // Путь к вашей картинке в assets
                        width:
                            200, // Установите размеры картинки по вашему усмотрению
                        height: 200,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  final storage = FlutterSecureStorage();

  Future<bool> _tryAutoLogin() async {
    try {
      final username = await storage.read(key: 'username');
      final password = await storage.read(key: 'password');

      if (username != null && password != null) {
        final uri = Uri.parse(
            'http://planup.skynet.kg:8000/accounts/mobile_app_login_view/');
        // Content-Type for form data
        final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
        // Encode the body as form data
        final body = {
          'username': username,
          'password': password,
          'version': "mobile"
        };
        try {
          final response = await http.post(uri, headers: headers, body: body);
          if (response.statusCode == 200) {
            var responseData = await json.decode(response.body);
            int? squares_id = responseData["squares_id"];
            preferences.setInt("squares_id", squares_id ?? 0);
            PackageInfo packageInfo = await PackageInfo.fromPlatform();
            final storage = FlutterSecureStorage();
            final version = packageInfo.version;
            await storage.write(key: 'version', value: version);
            final data = json.decode(response.body);
            String? token = await FirebaseMessaging.instance.getToken();
            debugPrint("This is device token: $token");
            await storage.write(key: 'Token', value: token);
            await storage.write(
                key: 'user_id', value: data['user_id'].toString());
            await storage.write(key: 'username', value: data['username']);
            await storage.write(key: 'full_name', value: data['full_name']);
            await storage.write(
                key: 'phone_number', value: data['phone_number']);
            await storage.write(key: 'one_c_code', value: data['one_c_code']);
            await storage.write(key: 'bitrix_id', value: data['bitrix_id']);
            await storage.write(key: 'region', value: data['region']);
            await storage.write(key: 'permission', value: data['permission']);
            await storage.write(key: 'username', value: username);
            await storage.write(key: 'password', value: password);
            final uri = Uri.parse(
                'http://planup.skynet.kg:8000/planup/update_device_token/');
            final headers = {
              'Content-Type': 'application/x-www-form-urlencoded'
            };
            final user_id = await storage.read(key: 'user_id');
            final body = {'user_id': user_id, 'token': token};
            final responses =
                await http.post(uri, headers: headers, body: body);
          }
        } catch (e) {
          // Handle any errors that occur during the request
          print('Error occurred: $e');
        }

        return true;
      }
    } catch (e) {
      print('Error during auto login: $e');
    }
    return false;
  }
}
