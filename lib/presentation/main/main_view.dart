import 'package:complete_advanced_flutter/presentation/main/home/home_page.dart';
import 'package:complete_advanced_flutter/presentation/main/notifications_page.dart';
import 'package:complete_advanced_flutter/presentation/main/search_page.dart';
import 'package:complete_advanced_flutter/presentation/main/settings_page.dart';
import 'package:complete_advanced_flutter/presentation/resources/color_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/strings_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
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

  String title = AppStrings.home.tr();
  var currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      body: pages[currentIndex],
      bottomNavigationBar: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(color: ColorManager.lightGrey, spreadRadius: AppSize.s1)
          ]),
          child: BottomNavigationBar(
            selectedItemColor: ColorManager.primary,
            unselectedItemColor: ColorManager.grey,
            currentIndex: currentIndex,
            onTap: onTap,
            items:  [
              BottomNavigationBarItem(
                  icon: const Icon(Icons.home), label: AppStrings.home.tr()),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search), label: AppStrings.search.tr()),
              BottomNavigationBarItem(
                  icon: Icon(Icons.notifications),
                  label: AppStrings.notifications.tr()),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: AppStrings.settings.tr()),
            ],
          )),
    );
  }

  onTap(int value) {
    setState(() {
      currentIndex = value;
      title = titles[value];
    });
  }
}
