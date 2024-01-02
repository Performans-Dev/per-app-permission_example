import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_example/data/services/app.dart';
import 'package:permission_example/core/constants/enum.dart';
import 'package:permission_example/data/models/definition.dart';

class DataSource {
  /// Definition of Calendar Read Only permission
  /// Android SDK 24 and later (only Android)
  static PermissionDefinition get calendarReadOnlyPermissionDefinition {
    final PermissionController pc = Get.find();
    return PermissionDefinition(
      type: PermissionType.calendarReadOnly,
      permissionStatus: pc.calendarReadOnlyPermissionStatus,
      checkCallback: pc.checkCalendarReadOnlyPermissionStatus,
      requestCallback: pc.requestCalendarReadOnlyPermission,
      settingsCallback: () async {
        var b = await openAppSettings();

        if (b) {
          await pc.checkCalendarReadOnlyPermissionStatus();
        }
      },
    );
  }

  /// Definition of Camera permission
  /// Android SDK 24 and later
  /// iOS
  static PermissionDefinition get cameraPermissionDefiniton {
    final PermissionController pc = Get.find();
    return PermissionDefinition(
      type: PermissionType.camera,
      permissionStatus: pc.cameraPermissionStatus,
      checkCallback: pc.checkCameraPermissionStatus,
      requestCallback: pc.requestCameraPermission,
      settingsCallback: () async {
        var b = await openAppSettings();

        if (b) {
          await pc.checkCameraPermissionStatus();
        }
      },
    );
  }

  /// Definition of Microphone Recording  permission
  /// required for video capture
  /// iOS
  static PermissionDefinition get microphonePermissionDefinition {
    final PermissionController pc = Get.find();
    return PermissionDefinition(
      type: PermissionType.microphone,
      permissionStatus: pc.microphonePermissionStatus,
      checkCallback: pc.checkBluetoothPermissionStatus,
      requestCallback: pc.requestMicrophonePermission,
      settingsCallback: () async {
        var b = await openAppSettings();

        if (b) {
          await pc.checkCameraPermissionStatus();
        }
      },
    );
  }

  /// Definition for Location Permission
  /// Android SDK 28 and earlier
  /// iOS 11 and earlier
  static PermissionDefinition get locationPermissionDefinition {
    final PermissionController pc = Get.find();
    return PermissionDefinition(
      type: PermissionType.location,
      permissionStatus: pc.permissionLocationStatus,
      checkCallback: pc.checkLocationPermissionStatus,
      requestCallback: pc.requestLocationPermission,
      settingsCallback: () async {
        var b = await openAppSettings();

        if (b) {
          await pc.checkLocationPermissionStatus();
        }
      },
    );
  }

  /// Definition for Location Permission
  /// Android SDK 29 and later
  /// (locationWhenInUse must be granted before requesting this permission on SDK 30+)
  /// iOS 10 and later
  static PermissionDefinition get locationAlwaysPermissionDefinition {
    final PermissionController pc = Get.find();
    return PermissionDefinition(
      type: PermissionType.locationAlways,
      permissionStatus: pc.permissionLocationAlwaysStatus,
      checkCallback: pc.checkLocationAlwaysPermissionStatus,
      requestCallback: pc.requestLocationAlwaysPermission,
      settingsCallback: () async {
        var b = await openAppSettings();

        if (b) {
          await pc.checkLocationAlwaysPermissionStatus();
        }
      },
    );
  }

  /// Definition of Location Always permission
  /// Android SDK 30 and later
  /// iOS 11 and later
  static PermissionDefinition get locationAlwaysPermissionDefinition4Sdk30 {
    final PermissionController pc = Get.find();
    return PermissionDefinition(
        type: PermissionType.locationAlways,
        permissionStatus: pc.permissionLocationAlwaysStatus,
        checkCallback: pc.checkLocationAlwaysPermissionStatus,
        requestCallback: pc.requestLocationAlwaysPermission,
        settingsCallback: () async {
          var b = await openAppSettings();

          if (b) {
            await pc.checkLocationAlwaysPermissionStatus();
          }
        },
        enabled:
            pc.permissionLocationWhenInUseStatus == PermissionStatus.granted);
  }

  /// Definition for Location When In Use Permission
  /// Android SDK 29 and later
  /// iOS 10 and later
  static PermissionDefinition get locationWhenInUsePermissionDefinition {
    final PermissionController pc = Get.find();
    return PermissionDefinition(
      type: PermissionType.locationWhenInUse,
      permissionStatus: pc.permissionLocationWhenInUseStatus,
      checkCallback: pc.checkLocationWhenInUsePermissionStatus,
      requestCallback: pc.requestLocationWhenInUsePermission,
      settingsCallback: () async {
        var b = await openAppSettings();

        if (b) {
          await pc.checkLocationWhenInUsePermissionStatus();
        }
      },
    );
  }

  /// Definition for Bluetooth Permission
  /// iOS 13 and later (only iOS)
  static PermissionDefinition get bluetoothPermissionDefinition {
    final PermissionController pc = Get.find();
    return PermissionDefinition(
      type: PermissionType.bluetooth,
      permissionStatus: pc.bluetoothPermissionStatus,
      checkCallback: pc.checkBluetoothPermissionStatus,
      requestCallback: pc.requestBluetoothPermission,
      settingsCallback: () async {
        var b = await openAppSettings();

        if (b) {
          await pc.checkBluetoothPermissionStatus();
        }
      },
    );
  }

  /// Definition for Bluetooth Scan Permission
  /// Android SDK 31 and later (only Android)
  static PermissionDefinition get bluetoothScanPermissionDefinition {
    final PermissionController pc = Get.find();
    return PermissionDefinition(
      type: PermissionType.bluetoothScan,
      permissionStatus: pc.bluetoothScanPermissionStatus,
      checkCallback: pc.checkBluetoohScanPermissionStatus,
      requestCallback: pc.requestBluetoothScanPermission,
      settingsCallback: () async {
        var b = await openAppSettings();

        if (b) {
          await pc.checkBluetoohScanPermissionStatus();
        }
      },
    );
  }

  /// Definition for Bluetooth Advertise Permission
  /// Android SDK 31 and later (only Android)
  static PermissionDefinition get bluetoothAdvertisePermissionDefinition {
    final PermissionController pc = Get.find();
    return PermissionDefinition(
      type: PermissionType.bluetoothAdvertise,
      permissionStatus: pc.bluetoothAdvertisePermissionStatus,
      checkCallback: pc.checkBluetoothAdvertisePermissionStatus,
      requestCallback: pc.requestBluetoothAdvertisePermission,
      settingsCallback: () async {
        var b = await openAppSettings();

        if (b) {
          await pc.checkBluetoothAdvertisePermissionStatus();
        }
      },
    );
  }

  /// Definition for Bluetooth Connect Permission
  /// Android SDK 31 and later (only Android)
  static PermissionDefinition get bluetoothConnectPermissionDefinition {
    final PermissionController pc = Get.find();
    return PermissionDefinition(
      type: PermissionType.bluetoothConnect,
      permissionStatus: pc.bluetoothConnectPermissionStatus,
      checkCallback: pc.checkBluetoothConnectPermissionStatus,
      requestCallback: pc.requestBluetoothConnectPermission,
      settingsCallback: () async {
        var b = await openAppSettings();

        if (b) {
          await pc.checkBluetoothConnectPermissionStatus();
        }
      },
    );
  }

  /// Definition for Sms Read Send Permission
  /// Android SDK 24 and later (only Android)
  static PermissionDefinition get smsReadSendPermissionDefinition {
    final PermissionController pc = Get.find();
    return PermissionDefinition(
      type: PermissionType.sms,
      permissionStatus: pc.smsPermissionStatus,
      checkCallback: pc.checkSmsPermissionStatus,
      requestCallback: pc.requestSmsPermission,
      settingsCallback: () async {
        var b = await openAppSettings();

        if (b) {
          await pc.checkSmsPermissionStatus();
        }
      },
    );
  }

  /// Definition for Ignore Battery Optimizations Permission
  /// Android SDK 24 and later (only Android)
  static PermissionDefinition get ignoreBatteryOptimizationsDefinition {
    final PermissionController pc = Get.find();
    return PermissionDefinition(
      type: PermissionType.ignoreBatteryOptimizations,
      permissionStatus: pc.ignoreBatteryOptimizationsPermissionStatus,
      checkCallback: pc.checkIgnoreBatteryOptimizationsPermissionStatus,
      requestCallback: pc.requestIgnoreBatteryOptimizationsPermission,
      settingsCallback: () async {
        var b = await openAppSettings();

        if (b) {
          await pc.checkIgnoreBatteryOptimizationsPermissionStatus();
        }
      },
    );
  }

  /// Definition for Calendar Full Access Permission
  /// Android SDK 24 and later (only Android)
  static PermissionDefinition get calendarFullAccessPermissionDefinition {
    final PermissionController pc = Get.find();
    return PermissionDefinition(
      type: PermissionType.calendarFullAccess,
      permissionStatus: pc.calendarFullAccessPermissionStatus,
      checkCallback: pc.checkCalendarFullAccessPermissionStatus,
      requestCallback: pc.requestCalendarFullAccessPermission,
      settingsCallback: () async {
        var b = await openAppSettings();

        if (b) {
          await pc.checkCalendarFullAccessPermissionStatus();
        }
      },
    );
  }

  /// Definition for Contacts Read Write Permission
  /// Android SDK 23 and later
  /// iOS 10 and later
  static PermissionDefinition get contactsReadWritePermissionDefinition {
    final PermissionController pc = Get.find();
    return PermissionDefinition(
      type: PermissionType.contact,
      permissionStatus: pc.contactPermissionStatus,
      checkCallback: pc.checkContactPermissionStatus,
      requestCallback: pc.requestContactPermission,
      settingsCallback: () async {
        var b = await openAppSettings();
        if (b) {
          await pc.checkContactPermissionStatus();
        }
      },
    );
  }

  /// Definition for Activity Recognition Permission
  /// Android SDK 28 and later (only Android)
  static PermissionDefinition get activityRecognitionPermissionDefinition {
    final PermissionController pc = Get.find();
    return PermissionDefinition(
      type: PermissionType.activityRecognition,
      permissionStatus: pc.activityRecognitionPermissionStatus,
      checkCallback: pc.checkActivityRecognitionPermissionStatus,
      requestCallback: pc.requestAppTrackingTrancparencyPermission,
      settingsCallback: () async {
        var b = await openAppSettings();

        if (b) {
          await pc.checkActivityRecognitionPermissionStatus();
        }
      },
    );
  }

  /// Definition for Access Sensors Permission
  /// Android SDK 33 and later
  /// iOS 11 and later
  static PermissionDefinition get accessSensorsPermissionDefinition {
    final PermissionController pc = Get.find();
    return PermissionDefinition(
      type: PermissionType.sensors,
      permissionStatus: pc.sensorsPermissionStatus,
      checkCallback: pc.checkSensorsPermissionStatus,
      requestCallback: pc.requestSensorsPermission,
      settingsCallback: () async {
        var b = await openAppSettings();

        if (b) {
          await pc.checkSensorsPermissionStatus();
        }
      },
    );
  }

  /// Definition for Sensor Always Permission
  /// Android SDK 33 and later
  /// iOS 17 and later
  static PermissionDefinition get sensorsAlwaysPermissionDefinition {
    final PermissionController pc = Get.find();
    return PermissionDefinition(
      type: PermissionType.sensorsAlways,
      permissionStatus: pc.sensorsAlwaysPermissionStatus,
      checkCallback: pc.checkSensorsAlwaysPermissionStatus,
      requestCallback: pc.requestSensorsAlwaysPermission,
      settingsCallback: () async {
        var b = await openAppSettings();

        if (b) {
          await pc.checkSensorsAlwaysPermissionStatus();
        }
      },
    );
  }

  /// Definition for Android Storage And Media Permission
  /// Android SDK 24 and later (only Android)
  static PermissionDefinition get androidStorageAndMediaPermissionDefinition {
    final PermissionController pc = Get.find();
    return PermissionDefinition(
      type: PermissionType.storageAndMedia,
      permissionStatus: pc.permissionGalleryGranted
          ? PermissionStatus.granted
          : PermissionStatus.denied,
      checkCallback: pc.checkStoragePermissionStatus,
      requestCallback: pc.requestStoragePermission,
      settingsCallback: () async {
        var b = await openAppSettings();

        if (b) {
          await pc.checkStoragePermissionStatus();
        }
      },
    );
  }

  /// Definition for iOS Photos Permission
  /// only iOS
  static PermissionDefinition get iOSPhotosPermissionDefinition {
    final PermissionController pc = Get.find();
    return PermissionDefinition(
      type: PermissionType.photos,
      permissionStatus: pc.permissionPhotos,
      checkCallback: pc.checkPhotosPermissionStatus,
      requestCallback: pc.requestPhotosPermission,
      settingsCallback: () async {
        var b = await openAppSettings();

        if (b) {
          await pc.checkPhotosPermissionStatus();
        }
      },
    );
  }

  /// Definition for App Tracking Transparency Permission
  /// iOS (and macOS) 14.5 and later
  static PermissionDefinition get appTrackingTransparencyPermissionDefinition {
    final PermissionController pc = Get.find();
    return PermissionDefinition(
      type: PermissionType.appTrackingTransparency,
      permissionStatus: pc.appTrackingTransparencyPermissionStatus,
      checkCallback: pc.checkAppTrackingTrancparencyPermissionStatus,
      requestCallback: pc.requestAppTrackingTrancparencyPermission,
      settingsCallback: () async {
        var b = await openAppSettings();

        if (b) {
          await pc.checkAppTrackingTrancparencyPermissionStatus();
        }
      },
    );
  }
}
