import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:complete_advanced_flutter/domain/model/model.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';

Future<DeviceInfo> getDeviceDetails() async {
  String name = 'unknown';
  String identifier = 'unknown';
  String version = 'unknown';

  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  AndroidId androidId = const AndroidId();
  try {
    if (Platform.isAndroid) {
      //return android device info
      var build = await deviceInfoPlugin.androidInfo;
      name = "${build.brand} ${build.model}";
      identifier = (await androidId.getId())!;
      version = build.version.codename;
    } else if (Platform.isIOS) {
      //return ios device info
      var build = await deviceInfoPlugin.iosInfo;
      name = "${build.name!} ${build.model!}";
      identifier = build.identifierForVendor!;
      version = build.systemVersion!;
    }
  } on PlatformException {
    //return default data here
    return DeviceInfo(name, identifier, version);
  }
  return DeviceInfo(name, identifier, version);
}

bool isEmailValid(String email){
  return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
}
