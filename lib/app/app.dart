import 'package:advanced_flutter_app/app/app_prefs.dart';
import 'package:advanced_flutter_app/app/di.dart';
import 'package:advanced_flutter_app/presentation/resources/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../presentation/resources/routes_manager.dart';

class MyApp extends StatefulWidget {
  // const MyApp({Key? key}) : super(key: key); //default constructor

//named constructor

  // ignore: prefer_const_constructors_in_immutables
  MyApp._internal();

  static final MyApp _instance =
      MyApp._internal(); // singleton or single instance

  factory MyApp() => _instance; //factory
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppPreferences _appPreferences = instance<AppPreferences>();

  @override
  void didChangeDependencies() {
    _appPreferences.getLocale().then((locale) => {context.setLocale(locale)});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(480, 800),
      // const Size(375, 667),
      // const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (child) => MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: RouteGenerator.getRoute,
        initialRoute: Routes.splashRoute,
        theme: getApplicationTheme(),
      ),
    );
  }
}
