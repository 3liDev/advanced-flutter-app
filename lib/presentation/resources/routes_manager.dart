import 'package:advanced_flutter_app/presentation/forgot_password/view/forgot_password_view.dart';
import 'package:advanced_flutter_app/presentation/login/view/login_view.dart';
import 'package:advanced_flutter_app/presentation/main/main_view.dart';
import 'package:advanced_flutter_app/presentation/onboarding/view/onboarding_view.dart';
import 'package:advanced_flutter_app/presentation/register/view/register_view.dart';
import 'package:advanced_flutter_app/presentation/resources/strings_manager.dart';
import 'package:advanced_flutter_app/presentation/splash/splash_view.dart';
import 'package:advanced_flutter_app/presentation/store_details/view/store_details_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../app/di.dart';

class Routes {
  static const String splashRoute = "/";
  static const String loginRoute = "/login";
  static const String registerRoute = "/register";
  static const String forgotPasswordRoute = "/forgotPassword";
  static const String onBoardingRoute = "/onBoarding";
  static const String mainRoute = "/main"; // home screen
  static const String storeDetailsRoute = "/storeDetails";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case Routes.loginRoute:
        initLoginModule();
        return MaterialPageRoute(builder: (_) => const LoginView());
      case Routes.onBoardingRoute:
        return MaterialPageRoute(builder: (_) => const OnBoardingView());
      case Routes.registerRoute:
        initRegisterModule();
        return MaterialPageRoute(builder: (_) => const RegisterView());
      case Routes.forgotPasswordRoute:
        initForgotPasswordModule();
        return MaterialPageRoute(builder: (_) => const ForgotPasswordView());
      case Routes.mainRoute:
        initHomeModule();
        return MaterialPageRoute(builder: (_) => const Mainview());
      case Routes.storeDetailsRoute:
        initStoreDetailModule();
        return MaterialPageRoute(builder: (_) => const StoreDetailsView());
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(AppStrings.noRouteFound.tr()),
              ),
              body: Center(
                child: Text(AppStrings.noRouteFound.tr()),
              ),
            ));
  }
}
