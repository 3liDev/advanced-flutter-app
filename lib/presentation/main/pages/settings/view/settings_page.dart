import 'package:advanced_flutter_app/app/app_prefs.dart';
import 'package:advanced_flutter_app/app/di.dart';
import 'package:advanced_flutter_app/data/data_source/local_data_source.dart';
import 'package:advanced_flutter_app/presentation/resources/assets_manager.dart';
import 'package:advanced_flutter_app/presentation/resources/language_manager.dart';
import 'package:advanced_flutter_app/presentation/resources/routes_manager.dart';
import 'package:advanced_flutter_app/presentation/resources/strings_manager.dart';
import 'package:advanced_flutter_app/presentation/resources/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  final LocalDataSource _localDataSource = instance<LocalDataSource>();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(AppPadding.p8SP),
      children: [
        ListTile(
          leading: SvgPicture.asset(ImageAssets.changeLangIc),
          title: Text(
            AppStrings.changeLanguage.tr(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          trailing: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(isRtl() ? math.pi : 0),
            child: SvgPicture.asset(ImageAssets.settingsRightArrowIc),
          ),
          onTap: () {
            _changeLanguage();
          },
        ),
        ListTile(
          leading: SvgPicture.asset(ImageAssets.contactUsIc),
          title: Text(
            AppStrings.contactUs.tr(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          trailing: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(isRtl() ? math.pi : 0),
            child: SvgPicture.asset(ImageAssets.settingsRightArrowIc),
          ),
          onTap: () {
            _contactUS();
          },
        ),
        ListTile(
          leading: SvgPicture.asset(ImageAssets.inviteFriendsIc),
          title: Text(
            AppStrings.inviteYourFriends.tr(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          trailing: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(isRtl() ? math.pi : 0),
            child: SvgPicture.asset(ImageAssets.settingsRightArrowIc),
          ),
          onTap: () {
            _inviteFriends();
          },
        ),
        ListTile(
          leading: SvgPicture.asset(ImageAssets.logoutIc),
          title: Text(
            AppStrings.logout.tr(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          trailing: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(isRtl() ? math.pi : 0),
            child: SvgPicture.asset(ImageAssets.settingsRightArrowIc),
          ),
          onTap: () {
            _logout();
          },
        ),
      ],
    );
  }

  bool isRtl() {
    return context.locale == arabicLocale;
  }

  _changeLanguage() {
    _appPreferences.changeLanguage();
    Phoenix.rebirth(context);
  }

  _contactUS() {
    // its a task for you to open any webpage using URL
  }
  _inviteFriends() {
    // its a task for you to share app name to friends
  }

  _logout() {
    // app prefs make that user logged out
    _appPreferences.logout();

    // clear cache of logged out user
    _localDataSource.clearCache();

    // navigate to login screen
    Navigator.pushReplacementNamed(context, Routes.loginRoute);
  }
}
