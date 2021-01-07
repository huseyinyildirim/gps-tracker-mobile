//region Core
import 'dart:async';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
//endregion

String _deviceIdentity;

final DeviceInfoPlugin _deviceInfoPlugin = new DeviceInfoPlugin();

Future<String> getDeviceIdentity() async {
  if (_deviceIdentity == '') {
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo info = await _deviceInfoPlugin.androidInfo;
        _deviceIdentity = "${info.device}-${info.id}";
      } else if (Platform.isIOS) {
        IosDeviceInfo info = await _deviceInfoPlugin.iosInfo;
        _deviceIdentity = "${info.model}-${info.identifierForVendor}";
      }
    } on PlatformException {
      _deviceIdentity = "unknown";
    }
  }

  return _deviceIdentity;
}