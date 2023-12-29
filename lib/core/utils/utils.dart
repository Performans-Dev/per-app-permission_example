// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:permission_example/core/constants/enum.dart';

class Utils {
  static Future<({OsType osType, double osVersion})> getOs() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    OsType _osType = OsType.unknown;
    double _osVersion = 0.0;

    try {
      if (GetPlatform.isIOS) {
        IosDeviceInfo iosDeviceInfo = await deviceInfoPlugin.iosInfo;
        _osType = OsType.ios;
        String v = iosDeviceInfo.systemVersion;
        _osVersion = double.parse(v);
      } else if (GetPlatform.isAndroid) {
        AndroidDeviceInfo androidDeviceInfo =
            await deviceInfoPlugin.androidInfo;
        _osType = OsType.android;
        String v = androidDeviceInfo.version.release;
        _osVersion = double.parse(v);
      } else if (GetPlatform.isWeb) {
        _osType = OsType.web;
        _osVersion = 1.0;
      } else if (GetPlatform.isLinux) {
        LinuxDeviceInfo linuxDeviceInfo = await deviceInfoPlugin.linuxInfo;
        _osType = OsType.linux;
        String v = linuxDeviceInfo.versionCodename ?? "";
        _osVersion = double.parse(v);
      } else if (GetPlatform.isMacOS) {
        MacOsDeviceInfo macOsDeviceInfo = await deviceInfoPlugin.macOsInfo;
        _osType = OsType.macos;
        String v = macOsDeviceInfo.osRelease;
        _osVersion = double.parse(v);
      } else if (GetPlatform.isWindows) {
        WindowsDeviceInfo windowsDeviceInfo =
            await deviceInfoPlugin.windowsInfo;
        _osType = OsType.windows;
        String v = windowsDeviceInfo.displayVersion;
        _osVersion = double.parse(v);
      }
    } catch (_) {}
    return (osType: _osType, osVersion: _osVersion);
  }
}
