import 'package:advanced_flutter_app/presentation/main/pages/home/view/home_page.dart';
import 'package:advanced_flutter_app/presentation/main/pages/notifications/view/notifications_page.dart';
import 'package:advanced_flutter_app/presentation/main/pages/search/view/search_page.dart';
import 'package:advanced_flutter_app/presentation/main/pages/settings/view/settings_page.dart';
import 'package:advanced_flutter_app/presentation/resources/color_manager.dart';
import 'package:advanced_flutter_app/presentation/resources/strings_manager.dart';
import 'package:advanced_flutter_app/presentation/resources/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class Mainview extends StatefulWidget {
  const Mainview({Key? key}) : super(key: key);

  @override
  State<Mainview> createState() => _MainviewState();
}

class _MainviewState extends State<Mainview> {
  List<Widget> pages = const [
    HomePage(),
    SearchPage(),
    NotificationsPage(),
    SettingsPage()
  ];

  List<String> titles = [
    AppStrings.home.tr(),
    AppStrings.search.tr(),
    AppStrings.notifications.tr(),
    AppStrings.settings.tr()
  ];
  String _title = AppStrings.home.tr();
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        _title,
        style: Theme.of(context).textTheme.titleSmall,
      )),
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(color: ColorManager.lightGrey, spreadRadius: AppSize.s1SP)
        ]),
        child: BottomNavigationBar(
            selectedItemColor: ColorManager.primary,
            unselectedItemColor: ColorManager.grey,
            currentIndex: _currentIndex,
            onTap: onTap,
            items: [
              BottomNavigationBarItem(
                  icon: const Icon(Icons.home_outlined),
                  label: AppStrings.home.tr()),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.search),
                  label: AppStrings.search.tr()),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.notifications),
                  label: AppStrings.notifications.tr()),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.settings),
                  label: AppStrings.settings.tr())
            ]),
      ),
    );
  }

  onTap(int index) {
    setState(() {
      _currentIndex = index;
      _title = titles[index];
    });
  }
}
