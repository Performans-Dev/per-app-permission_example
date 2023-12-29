import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_example/core/constants/enum.dart';
import 'package:permission_example/data/models/definition.dart';

class UI {
  static String titleOfPermission(PermissionDefinition p) {
    switch (p.type) {
      case PermissionType.camera:
        return "Camera";
      case PermissionType.microphone:
        return "Microphone";
      case PermissionType.location:
        return "Location";
      case PermissionType.locationAlways:
        return "Location Always";
      case PermissionType.locationWhenInUse:
        return "Location WhenInUse";
      case PermissionType.bluetooth:
        return "Bluetooth";
      case PermissionType.bluetoothScan:
        return "Bluetooth Scan";
      case PermissionType.bluetoothAdvertise:
        return "Bluetooth Advertise";
      case PermissionType.bluetoothConnect:
        return "Bluetooth Connect";
      case PermissionType.account:
        return "Account";
      case PermissionType.activityRecognition:
        return "Activity Recognition";
      case PermissionType.health:
        return "Health";
      case PermissionType.sms:
        return "Sms";
      case PermissionType.calendarReadOnly:
        return "Calendar ReadOnly";
      case PermissionType.calendarFullAccess:
        return "Calendar Full Access";
      case PermissionType.contact:
        return "Contact";
      case PermissionType.appTrackingTransparency:
        return "App Tracking Transparency";
      case PermissionType.ignoreBatteryOptimizations:
        return "IgnoreBattery Optimizations";
      case PermissionType.sensors:
        return "Sensors";
      case PermissionType.sensorsAlways:
        return "Sensors Always";
      case PermissionType.storageAndMedia:
        return "Storage and Media";
      case PermissionType.photos:
        return "Photos";
      default:
        return "Unknown";
    }
  }

  static Widget buildPermissionListTile(PermissionDefinition p) {
    return Opacity(
      opacity: p.enabled ? 1 : 0.3,
      child: ListTile(
        title: Text(UI.titleOfPermission(p)),
        subtitle: Text("${p.permissionStatus}"),
        onTap: p.enabled
            ? () async {
                if (p.permissionStatus == PermissionStatus.granted) {
                } else {
                  if ((p.permissionStatus ==
                              PermissionStatus.permanentlyDenied ||
                          p.permissionStatus == PermissionStatus.limited) &&
                      p.settingsCallback != null) {
                    await p.settingsCallback!();
                  } else {
                    await p.requestCallback();
                  }
                  await p.checkCallback();
                }
              }
            : null,
        trailing: buildListTileTrailingWidget(p.permissionStatus),
      ),
    );
  }

  static Widget buildListTileTrailingWidget(PermissionStatus s) {
    switch (s) {
      case PermissionStatus.denied:
        return Icon(Icons.remove_moderator_outlined,
            color: Colors.red.shade300);
      case PermissionStatus.granted:
        return Icon(Icons.verified_user_outlined, color: Colors.green.shade300);
      case PermissionStatus.permanentlyDenied:
        return Icon(Icons.settings, color: Colors.orange.shade300);
      case PermissionStatus.restricted:
        return Icon(Icons.shield_moon_outlined, color: Colors.red.shade300);
      case PermissionStatus.limited:
        return Icon(Icons.lock_outline, color: Colors.red.shade300);
      case PermissionStatus.provisional:
        return Icon(Icons.visibility_off_outlined, color: Colors.red.shade300);
    }
  }
}
