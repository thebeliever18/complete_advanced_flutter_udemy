import 'package:complete_advanced_flutter/app/app_prefs.dart';
import 'package:complete_advanced_flutter/app/di.dart';
import 'package:complete_advanced_flutter/data/data_source/local_data_source.dart';
import 'package:complete_advanced_flutter/presentation/resources/assets_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/routes_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/strings_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  AppPreferences appPreferences = instance<AppPreferences>();
  LocalDataSource localDataSource = instance<LocalDataSource>();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding:const EdgeInsets.all(AppPadding.p8),
      children: [
        ListTile(
          title:  Text(AppStrings.changeLanguage,style: Theme.of(context).textTheme.headline4,).tr(),
          leading: SvgPicture.asset(ImageAssets.changeLanguage),
          trailing: SvgPicture.asset(ImageAssets.settingsArrow),
          onTap: (){
            _changeLanguage();
          },
        ),
        ListTile(
          title:  Text(AppStrings.contactUs,style: Theme.of(context).textTheme.headline4,).tr(),
          leading: SvgPicture.asset(ImageAssets.contactUs),
          trailing: SvgPicture.asset(ImageAssets.settingsArrow),
          onTap: (){
            _contactUs();
          },
        ),
        ListTile(
          title:  Text(AppStrings.inviteYourFriends,style: Theme.of(context).textTheme.headline4,).tr(),
          leading: SvgPicture.asset(ImageAssets.share),
          trailing: SvgPicture.asset(ImageAssets.settingsArrow),
          onTap: (){
            _inviteFriends();
          },
        ),
        ListTile(
          title:  Text(AppStrings.logout,style: Theme.of(context).textTheme.headline4,).tr(),
          leading: SvgPicture.asset(ImageAssets.logoutIcon),
          trailing: SvgPicture.asset(ImageAssets.settingsArrow),
          onTap: (){
            _logout();
          },
        ),

      ],
    );
  }

  void _changeLanguage(){
    appPreferences.setLanguageChanged();
    Phoenix.rebirth(context);
  }

  void _contactUs(){

  }

  void _inviteFriends(){

  }

  void _logout(){
    localDataSource.clearCache();
    appPreferences.logout();
    Navigator.pushReplacementNamed(context, Routes.loginRoute);
  }
}


 