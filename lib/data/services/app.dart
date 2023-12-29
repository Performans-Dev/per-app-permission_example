import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_example/core/constants/enum.dart';
import 'package:permission_example/core/utils/utils.dart';
import 'package:permission_example/data/providers/data.dart';
import 'package:permission_example/data/models/definition.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class PermissionController extends GetxController {
  @override
  void onReady() {
    runInitTask();
    super.onReady();
  }

  ///Determines the data list of the device by executing the initial information,
  /// populates and updates the permission list.
  Future<void> runInitTask() async {
    final deviceData = await Utils.getOs();
    _osType.value = deviceData.osType;
    _osVersion.value = deviceData.osVersion;
    update();
    await populatePermissionList();
  }

  //#region Location

  /// It includes checking location permission statuses, requesting permission, and updating according to permission status.
  /// location: Android SDK 28 and earlier, iOS 11 and earlier
  /// locationAlways:Android SDK 29 and later,iOS 10 and later
  /// (locationWhenInUse must be granted before requesting this permission on SDK 30+)
  ///locationWhenInUse: ndroid SDK 29 and later,iOS 10 and later
  loc.Location location = loc.Location();
  final Rx<PermissionStatus> _permissionLocationStatus =
      PermissionStatus.denied.obs;
  final Rx<PermissionStatus> _permissionLocationAlwaysStatus =
      PermissionStatus.denied.obs;
  final Rx<PermissionStatus> _permissionLocationWhenInUseStatus =
      PermissionStatus.denied.obs;

  PermissionStatus get permissionLocationStatus =>
      _permissionLocationStatus.value;
  PermissionStatus get permissionLocationAlwaysStatus =>
      _permissionLocationAlwaysStatus.value;
  PermissionStatus get permissionLocationWhenInUseStatus =>
      _permissionLocationWhenInUseStatus.value;

  Future<void> checkLocationPermissionStatus() async {
    try {
      PermissionStatus statusLocation = await Permission.location.status;
      _permissionLocationStatus.value = statusLocation;
      update();
      updatePermissionStatusInList(PermissionType.location, statusLocation);
    } on Exception catch (_) {}
  }

  Future<void> checkLocationAlwaysPermissionStatus() async {
    try {
      PermissionStatus statusLocationAlways =
          await Permission.locationAlways.status;
      _permissionLocationAlwaysStatus.value = statusLocationAlways;
      update();
      updatePermissionStatusInList(
          PermissionType.locationAlways, statusLocationAlways);
    } on Exception catch (_) {}
  }

  Future<void> checkLocationWhenInUsePermissionStatus() async {
    try {
      PermissionStatus statusLocationWhenInUse =
          await Permission.locationWhenInUse.status;
      _permissionLocationWhenInUseStatus.value = statusLocationWhenInUse;
      update();
      updatePermissionStatusInList(
          PermissionType.locationWhenInUse, statusLocationWhenInUse);
      updateEnabledStatusInList(
          PermissionType.locationAlways, statusLocationWhenInUse.isGranted);
    } on Exception catch (_) {}
  }

  Future<PermissionStatus> requestLocationPermission() async {
    var status = await Permission.location.request();
    _permissionLocationStatus.value = status;
    updatePermissionStatusInList(PermissionType.location, status);
    return status;
  }

  Future<PermissionStatus> requestLocationAlwaysPermission() async {
    var status = await Permission.locationAlways.request();
    _permissionLocationAlwaysStatus.value = status;
    updatePermissionStatusInList(PermissionType.locationAlways, status);
    return status;
  }

  Future<PermissionStatus> requestLocationWhenInUsePermission() async {
    var status = await Permission.locationWhenInUse.request();
    _permissionLocationWhenInUseStatus.value = status;
    updatePermissionStatusInList(PermissionType.locationWhenInUse, status);
    return status;
  }
  //#endregion

  //#region Camera And Microphone

  /// It includes checking camera and microphone permission statuses, requesting permissions, and updating them according to permission statuses.
  /// it updates the statuses of camera and microphone permission types and keeps these statuses in a list.
  /// Android SDK 24 and later
  /// equired for video capture
  /// iOS
  final Rx<PermissionStatus> _cameraPermissionStatus =
      PermissionStatus.denied.obs;
  PermissionStatus get cameraPermissionStatus => _cameraPermissionStatus.value;

  final Rx<PermissionStatus> _microphonePermissionStatus =
      PermissionStatus.denied.obs;
  PermissionStatus get microphonePermissionStatus =>
      _microphonePermissionStatus.value;

  Future<void> checkCameraPermissionStatus() async {
    try {
      PermissionStatus statusCamera = await Permission.camera.status;
      _cameraPermissionStatus.value = statusCamera;
      PermissionStatus statusMicrophone = await Permission.microphone.status;
      _microphonePermissionStatus.value = statusMicrophone;
      update();
      updatePermissionStatusInList(PermissionType.camera, statusCamera);
      updatePermissionStatusInList(PermissionType.microphone, statusMicrophone);
    } on Exception catch (_) {}
  }

  Future<PermissionStatus> requestCameraPermission() async {
    var status = await Permission.camera.request();
    _cameraPermissionStatus.value = status;
    updatePermissionStatusInList(PermissionType.camera, status);
    return status;
  }

  Future<PermissionStatus> requestMicrophonePermission() async {
    var status = await Permission.microphone.request();
    _microphonePermissionStatus.value = status;
    update();
    updatePermissionStatusInList(PermissionType.microphone, status);
    return status;
  }
  //#endregion

  //#region Bluetooth

  /// Checks general Bluetooth access, browsing, advertising, and connection permissions, updates permission statuses, and handles permission requests.
  /// bluetooth: iOS 13 and later (only iOS)
  /// bluetoothScan: Android SDK 31 and later (only Android)
  /// bluetoothAdvertise: Android SDK 31 and later (only Android)
  /// bluetoothConnect: Android SDK 31 and later (only Android)
  final Rx<PermissionStatus> _bluetoothPermissionStatus =
      PermissionStatus.denied.obs;
  PermissionStatus get bluetoothPermissionStatus =>
      _bluetoothPermissionStatus.value;

  final Rx<PermissionStatus> _bluetoothScanPermissionStatus =
      PermissionStatus.denied.obs;

  PermissionStatus get bluetoothScanPermissionStatus =>
      _bluetoothScanPermissionStatus.value;

  final Rx<PermissionStatus> _bluetoothAdvertisePermissionStatus =
      PermissionStatus.denied.obs;
  PermissionStatus get bluetoothAdvertisePermissionStatus =>
      _bluetoothAdvertisePermissionStatus.value;

  final Rx<PermissionStatus> _bluetoothConnectPermissionStatus =
      PermissionStatus.denied.obs;
  PermissionStatus get bluetoothConnectPermissionStatus =>
      _bluetoothConnectPermissionStatus.value;

  Future<void> checkBluetoothPermissionStatus() async {
    try {
      PermissionStatus statusBluetooth = await Permission.bluetooth.status;
      _bluetoothPermissionStatus.value = statusBluetooth;
      update();
      updatePermissionStatusInList(PermissionType.bluetooth, statusBluetooth);
    } on Exception catch (_) {}
  }

  Future<void> checkBluetoohScanPermissionStatus() async {
    try {
      PermissionStatus s = await Permission.bluetoothScan.status;
      _bluetoothScanPermissionStatus.value = s;
      update();
      updatePermissionStatusInList(PermissionType.bluetoothScan, s);
    } on Exception catch (_) {}
  }

  Future<void> checkBluetoothAdvertisePermissionStatus() async {
    try {
      PermissionStatus s = await Permission.bluetoothAdvertise.status;
      _bluetoothAdvertisePermissionStatus.value = s;
      update();
      updatePermissionStatusInList(PermissionType.bluetoothAdvertise, s);
    } on Exception catch (_) {}
  }

  Future<void> checkBluetoothConnectPermissionStatus() async {
    try {
      PermissionStatus s = await Permission.bluetoothConnect.status;
      _bluetoothConnectPermissionStatus.value = s;
      update();
      updatePermissionStatusInList(PermissionType.bluetoothConnect, s);
    } on Exception catch (_) {}
  }

  Future<PermissionStatus> requestBluetoothPermission() async {
    var status = await Permission.bluetooth.request();
    _bluetoothPermissionStatus.value = status;
    updatePermissionStatusInList(PermissionType.bluetooth, status);
    return status;
  }

  Future<PermissionStatus> requestBluetoothScanPermission() async {
    var status = await Permission.bluetoothScan.request();
    _bluetoothScanPermissionStatus.value = status;
    updatePermissionStatusInList(PermissionType.bluetoothScan, status);
    return status;
  }

  Future<PermissionStatus> requestBluetoothAdvertisePermission() async {
    var status = await Permission.bluetoothAdvertise.request();
    _bluetoothAdvertisePermissionStatus.value = status;
    updatePermissionStatusInList(PermissionType.bluetoothAdvertise, status);
    return status;
  }

  Future<PermissionStatus> requestBluetoothConnectPermission() async {
    var status = await Permission.bluetoothConnect.request();
    _bluetoothConnectPermissionStatus.value = status;
    updatePermissionStatusInList(PermissionType.bluetoothConnect, status);
    return status;
  }
  //#endregion

  //#region SMS

  /// Controls SMS permission and manages splitting of permissions.
  /// Android SDK 24 and later (only Android)
  final Rx<PermissionStatus> _permissionSmsStatus = PermissionStatus.denied.obs;
  PermissionStatus get smsPermissionStatus => _permissionSmsStatus.value;

  Future<void> checkSmsPermissionStatus() async {
    try {
      PermissionStatus statusSms = await Permission.sms.status;
      _permissionSmsStatus.value = statusSms;
      update();
      updatePermissionStatusInList(PermissionType.sms, statusSms);
    } on Exception catch (_) {}
  }

  Future<PermissionStatus> requestSmsPermission() async {
    var s = await Permission.sms.request();
    _permissionSmsStatus.value = s;
    updatePermissionStatusInList(PermissionType.sms, s);
    return s;
  }

  //#endregion

  //#region Calender

  ///Checks calendar leave statuses and manages leave requests, updating both "readOnly" and "fullAccess" calendar leave statuses.
  ///Android SDK 24 and later (only Android)
  final Rx<PermissionStatus> _calendarReadOnlyPermissionStatus =
      PermissionStatus.denied.obs;
  PermissionStatus get calendarReadOnlyPermissionStatus =>
      _calendarReadOnlyPermissionStatus.value;

  final Rx<PermissionStatus> _calendarFullAccessPermissionStatus =
      PermissionStatus.denied.obs;
  PermissionStatus get calendarFullAccessPermissionStatus =>
      _calendarFullAccessPermissionStatus.value;

  Future<void> checkCalendarFullAccessPermissionStatus() async {
    try {
      PermissionStatus s = await Permission.calendarFullAccess.status;
      _calendarFullAccessPermissionStatus.value = s;
      update();
      updatePermissionStatusInList(PermissionType.calendarFullAccess, s);
    } on Exception catch (_) {}
  }

  Future<void> checkCalendarReadOnlyPermissionStatus() async {
    try {
      PermissionStatus s = await Permission.calendarReadOnly.status;
      _calendarReadOnlyPermissionStatus.value = s;
      update();
      updatePermissionStatusInList(PermissionType.calendarReadOnly, s);
    } on Exception catch (_) {}
  }

  Future<PermissionStatus> requestCalendarReadOnlyPermission() async {
    var s = await Permission.calendarReadOnly.request();
    _calendarReadOnlyPermissionStatus.value = s;
    updatePermissionStatusInList(PermissionType.calendarReadOnly, s);
    return s;
  }

  Future<PermissionStatus> requestCalendarFullAccessPermission() async {
    var s = await Permission.calendarFullAccess.request();
    _calendarFullAccessPermissionStatus.value = s;
    updatePermissionStatusInList(PermissionType.calendarFullAccess, s);
    return s;
  }

  //#endregion

  //#region Contact

  /// Contacts check leave status and manage leave requests.
  /// The person updates the leave status and updates the relevant leave type in the permission list.
  /// Android SDK 23 and later - iOS 10 and later
  final Rx<PermissionStatus> _contactPermissionStatus =
      PermissionStatus.denied.obs;
  PermissionStatus get contactPermissionStatus =>
      _contactPermissionStatus.value;

  Future<void> checkContactPermissionStatus() async {
    try {
      PermissionStatus s = await Permission.contacts.status;
      _contactPermissionStatus.value = s;
      update();
      updatePermissionStatusInList(PermissionType.contact, s);
    } on Exception catch (_) {}
  }

  Future<PermissionStatus> requestContactPermission() async {
    var statusContact = await Permission.contacts.request();
    _contactPermissionStatus.value = statusContact;
    updatePermissionStatusInList(PermissionType.contact, statusContact);
    return statusContact;
  }
  //#endregion

  //#region App Tracking Trancparency

  /// App Tracking Transparency checks permission status and manages leave requests.
  /// Application tracking transparency updates the permission status and updates the corresponding permission type in the permission list.
  /// iOS (and macOS) 14.5 and later
  final Rx<PermissionStatus> _appTrackingTransparencyPermissionStatus =
      PermissionStatus.denied.obs;
  PermissionStatus get appTrackingTransparencyPermissionStatus =>
      _appTrackingTransparencyPermissionStatus.value;

  Future<void> checkAppTrackingTrancparencyPermissionStatus() async {
    try {
      PermissionStatus s = await Permission.appTrackingTransparency.status;
      _appTrackingTransparencyPermissionStatus.value = s;
      update();
      updatePermissionStatusInList(PermissionType.appTrackingTransparency, s);
    } on Exception catch (_) {}
  }

  Future<PermissionStatus> requestAppTrackingTrancparencyPermission() async {
    var s = await Permission.appTrackingTransparency.request();
    _appTrackingTransparencyPermissionStatus.value = s;
    updatePermissionStatusInList(PermissionType.appTrackingTransparency, s);
    return s;
  }

  //#endregion

  //#region Activity Recognition

  /// Activity recognition checks leave status and manages leave requests.
  /// Activity recognition updates the permission status and updates the corresponding permission type in the permission list.
  /// Android SDK 28 and later (only Android)
  final Rx<PermissionStatus> _activityRecognitionPermissionStatus =
      PermissionStatus.denied.obs;
  PermissionStatus get activityRecognitionPermissionStatus =>
      _activityRecognitionPermissionStatus.value;

  Future<void> checkActivityRecognitionPermissionStatus() async {
    try {
      PermissionStatus s = await Permission.activityRecognition.status;
      _activityRecognitionPermissionStatus.value = s;
      update();
      updatePermissionStatusInList(PermissionType.activityRecognition, s);
    } on Exception catch (_) {}
  }

  Future<PermissionStatus> requestActivityRecognitionPermission() async {
    var s = await Permission.activityRecognition.request();
    _activityRecognitionPermissionStatus.value = s;
    updatePermissionStatusInList(PermissionType.activityRecognition, s);
    return s;
  }

  //#endregion

  //#region IgnoreBattery Optimizations

  /// Ignore battery optimizations checks permission status and manages permission requests.
  /// Ignoring battery optimizations updates the permission status and updates the corresponding permission type in the permission list.
  /// Android SDK 24 and later (only Android)
  final Rx<PermissionStatus> _ignoreBatteryOptimizationsPermissionStatus =
      PermissionStatus.denied.obs;
  PermissionStatus get ignoreBatteryOptimizationsPermissionStatus =>
      _ignoreBatteryOptimizationsPermissionStatus.value;

  Future<void> checkIgnoreBatteryOptimizationsPermissionStatus() async {
    try {
      PermissionStatus s = await Permission.ignoreBatteryOptimizations.status;
      _ignoreBatteryOptimizationsPermissionStatus.value = s;
      update();
      updatePermissionStatusInList(
          PermissionType.ignoreBatteryOptimizations, s);
    } on Exception catch (_) {}
  }

  Future<PermissionStatus> requestIgnoreBatteryOptimizationsPermission() async {
    var s = await Permission.ignoreBatteryOptimizations.request();
    _ignoreBatteryOptimizationsPermissionStatus.value = s;
    updatePermissionStatusInList(PermissionType.ignoreBatteryOptimizations, s);
    return s;
  }

  //#endregion

  //#region Sensor
  /// The sensor checks leave statuses and manages leave requests.
  /// The sensor updates the permission statuses and updates the relevant permission types in the permission list.
  /// accessSensor-sensorsAlways: Android SDK 33 and later
  /// accessSensor: iOS 11 and later
  /// sensorsAlways: iOS 17 and later

  final Rx<PermissionStatus> _sensorsPermissionStatus =
      PermissionStatus.denied.obs;
  PermissionStatus get sensorsPermissionStatus =>
      _sensorsPermissionStatus.value;

  Future<void> checkSensorsPermissionStatus() async {
    try {
      PermissionStatus s = await Permission.sensors.status;
      _sensorsPermissionStatus.value = s;
      update();
      updatePermissionStatusInList(PermissionType.sensors, s);
    } on Exception catch (_) {}
  }

  Future<PermissionStatus> requestSensorsPermission() async {
    var status = await Permission.sensors.request();
    _sensorsPermissionStatus.value = status;
    updatePermissionStatusInList(PermissionType.sensors, status);
    return status;
  }

  final Rx<PermissionStatus> _sensorsAlwaysPermissionStatus =
      PermissionStatus.denied.obs;
  PermissionStatus get sensorsAlwaysPermissionStatus =>
      _sensorsAlwaysPermissionStatus.value;

  Future<void> checkSensorsAlwaysPermissionStatus() async {
    try {
      PermissionStatus s = await Permission.sensorsAlways.status;
      _sensorsAlwaysPermissionStatus.value = s;
      update();
      updatePermissionStatusInList(PermissionType.sensorsAlways, s);
    } on Exception catch (_) {}
  }

  Future<PermissionStatus> requestSensorsAlwaysPermission() async {
    var status = await Permission.sensorsAlways.request();
    _sensorsAlwaysPermissionStatus.value = status;
    updatePermissionStatusInList(PermissionType.sensorsAlways, status);
    return status;
  }

  //#endregion

  //#region PHOTOS
  /// Checks photo permit status and manages permit requests.
  /// Updates the photo permit status and updates the relevant permit type in the permit list.
  /// only iOS
  final Rx<PermissionStatus> _permissionPhotos = PermissionStatus.denied.obs;
  PermissionStatus get permissionPhotos => _permissionPhotos.value;
  Future<void> checkPhotosPermissionStatus() async {
    try {
      PermissionStatus p = await Permission.photos.status;

      update();

      updatePermissionStatusInList(PermissionType.photos, p);
    } on Exception catch (_) {}
  }

  Future<PermissionStatus> requestPhotosPermission() async {
    var status = await Permission.photos.request();
    _permissionPhotos.value = status;
    updatePermissionStatusInList(PermissionType.photos, status);
    return status;
  }
//#endregion

  //#region Storage

  /// Checks storage permission statuses, manages permission requests,
  /// and updates permission statuses for storage, photos, videos, and audio recordings.
  /// Android SDK 24 and later (only Android)
  final RxBool _isAndroid13 = false.obs;
  bool get isAndroid13 => _isAndroid13.value;

  final RxBool _permissionGalleryGranted = false.obs;
  bool get permissionGalleryGranted => _permissionGalleryGranted.value;

  Future<void> checkStoragePermissionStatus() async {
    try {
      bool storage = true;
      bool videos = true;
      bool photos = true;
      bool audio = true;
      if (GetPlatform.isIOS) {
        videos = await Permission.photos.status.isGranted;
        photos = await Permission.photos.status.isGranted;
      } else {
        storage = await Permission.storage.status.isGranted;

        if (isAndroid13) {
          videos = await Permission.photos.status.isGranted;
          photos = await Permission.photos.status.isGranted;
          audio = await Permission.audio.status.isGranted;
        }
      }

      _permissionGalleryGranted.value = storage && videos && photos && audio;

      PermissionStatus s = await Permission.storage.status;
      update();
      updatePermissionStatusInList(PermissionType.storageAndMedia, s);
    } on Exception catch (_) {}
  }

  Future<PermissionStatus> requestStoragePermission() async {
    PermissionStatus s;

    if (GetPlatform.isIOS) {
      s = await Permission.photos.request();
    } else {
      s = await Permission.storage.request();

      if (isAndroid13) {
        await Permission.photos.request();
        await Permission.photos.request();
      }
    }

    _permissionGalleryGranted.value = s.isGranted;
    updatePermissionStatusInList(PermissionType.storageAndMedia, s);
    return s;
  }
  //#endregion

  //#region Device Type And Version

  /// This code, contains variables that keep track of device type and operating system version.
  /// The osType variable holds the operating system type of the device, and the osVersion variable holds the operating system version number.
  final Rx<OsType> _osType = OsType.unknown.obs;
  OsType get osType => _osType.value;

  final Rx<double> _osVersion = 0.0.obs;
  double get osVersion => _osVersion.value;
  //#endregion

  //#region Permission List

  /// 'checkPermissionStatus' function checks various permission statuses depending on the device's operating system.
  /// 'populatePermissionList' function adds the available permissions to the list and updates the permission list, depending on the device's operating system and version.
  final RxList<PermissionDefinition> _permissionList =
      <PermissionDefinition>[].obs;
  List<PermissionDefinition> get permissionList => _permissionList;

  Future<void> checkPermissionStatus() async {
    if (osType == OsType.android) {
      await checkLocationPermissionStatus();
      await checkCameraPermissionStatus();
      await checkBluetoohScanPermissionStatus();
      await checkBluetoothAdvertisePermissionStatus();
      await checkBluetoothConnectPermissionStatus();
      await checkSmsPermissionStatus();
      await checkIgnoreBatteryOptimizationsPermissionStatus();
      await checkCalendarFullAccessPermissionStatus();
      await checkCalendarReadOnlyPermissionStatus();
      await checkContactPermissionStatus();
      await checkSensorsPermissionStatus(); //
      await checkSensorsAlwaysPermissionStatus(); //
      await checkStoragePermissionStatus();
      await checkLocationPermissionStatus();
      await checkLocationAlwaysPermissionStatus();
      await checkLocationWhenInUsePermissionStatus();
      await checkActivityRecognitionPermissionStatus();
    } else if (osType == OsType.ios) {
      await checkLocationPermissionStatus();
      await checkCameraPermissionStatus();
      await checkBluetoothPermissionStatus();
      await checkContactPermissionStatus();
      await checkSensorsPermissionStatus();
      await checkSensorsAlwaysPermissionStatus();
      await checkPhotosPermissionStatus();
      await checkAppTrackingTrancparencyPermissionStatus();
      await checkLocationAlwaysPermissionStatus();
      await checkLocationWhenInUsePermissionStatus();
      // await checkNotificationPermissionStatus();
    }
  }

  Future<void> populatePermissionList() async {
    await checkPermissionStatus();
    List<PermissionDefinition> list = [];

    ///LOCATION
    if (osType == OsType.android && osVersion <= 9.0) {
      list.add(DataSource.locationPermissionDefinition);
    } else if ((osType == OsType.android &&
            osVersion >= 10.0 &&
            osVersion < 11.0) ||
        (osType == OsType.ios && osVersion >= 10.0)) {
      list.add(DataSource.locationWhenInUsePermissionDefinition);
      list.add(DataSource.locationAlwaysPermissionDefinition);
    } else if (osVersion >= 11.0) {
      list.add(DataSource.locationWhenInUsePermissionDefinition);
      list.add(DataSource.locationAlwaysPermissionDefinition4Sdk30);
    }

    /// CAMERA
    if ((osType == OsType.android && osVersion >= 7.0) ||
        osType == OsType.ios) {
      list.add(DataSource.cameraPermissionDefiniton);
    }

    /// MICROPHONE
    if ((osType == OsType.android && osVersion >= 7.0) ||
        osType == OsType.ios) {
      list.add(DataSource.microphonePermissionDefinition);
    }

    /// BLUETOOTH
    if (osType == OsType.ios && osVersion >= 13.0) {
      list.add(DataSource.bluetoothPermissionDefinition);
    }

    /// BLUETOOTH SCAN
    if (osType == OsType.android && osVersion >= 12) {
      list.add(DataSource.bluetoothScanPermissionDefinition);

      /// BLUETOOTH ADVERTİSE
      if (osType == OsType.android && osVersion >= 12) {
        list.add(DataSource.bluetoothAdvertisePermissionDefinition);
      }
    }

    ///BLUETOOTH CONNECT
    if (osType == OsType.android && osVersion >= 12) {
      list.add(DataSource.bluetoothConnectPermissionDefinition);
    }

    ///SMS
    if (osType == OsType.android && osVersion >= 7.0) {
      list.add(DataSource.smsReadSendPermissionDefinition);
    }

    /// IGNORE BATTERY OPTIMIZATIONS
    if (osType == OsType.android) {
      list.add(DataSource.ignoreBatteryOptimizationsDefinition);
    }

    ///CALENDAR READ ONLY
    if (osType == OsType.android && osVersion >= 7.0) {
      list.add(DataSource.calendarReadOnlyPermissionDefinition);
    }

    ///CALENDAR FULL ACCESS
    if (osType == OsType.android && osVersion >= 7.0) {
      list.add(DataSource.calendarFullAccessPermissionDefinition);
    }

    /// CONTACT
    if ((osType == OsType.android && osVersion >= 6) ||
        (osType == OsType.ios && osVersion >= 10.0)) {
      list.add(DataSource.contactsReadWritePermissionDefinition);
    }

    /// ACTIVITY RECOGNITION
    if (osType == OsType.android && osVersion >= 9.0) {
      list.add(DataSource.activityRecognitionPermissionDefinition);
    }

    ///SENSORS
    if ((osType == OsType.android && osVersion >= 13.0) ||
        (osType == OsType.ios && osVersion >= 11.0)) {
      list.add(DataSource.accessSensorsPermissionDefinition);
    }

    /// SENSOR ALWAYS
    if ((osType == OsType.android && osVersion >= 13.0) ||
        (osType == OsType.ios && osVersion >= 17.0)) {
      list.add(DataSource.sensorsAlwaysPermissionDefinition);
    }

    /// STORAGE
    if (osType == OsType.android && osVersion >= 7.0) {
      list.add(DataSource.androidStorageAndMediaPermissionDefinition);
    }

    /// PHOTOS
    if (osType == OsType.ios) {
      list.add(DataSource.iOSPhotosPermissionDefinition);
    }

    /// APP TRACKING TRANSPARENCY
    if (osType == OsType.ios || osType == OsType.macos) {
      if (osVersion >= 14.5) {
        list.add(DataSource.appTrackingTransparencyPermissionDefinition);
      }
    }

    /// Notification
    if (osType == OsType.ios) {
      //   list.add(DataSource.notificationPermissionDefinition);
    }
    _permissionList.assignAll(list);

    update();
  }
  //#endregion

  //#region HELPER

  /// Helper function that updates permission list
  /// PermissionType type: item to update
  /// PermissionStatus status: value to update
  void updatePermissionStatusInList(
      PermissionType type, PermissionStatus status) {
    if (permissionList.isNotEmpty) {
      int index = permissionList.indexWhere((e) => e.type == type);
      PermissionDefinition item = permissionList[index];
      PermissionDefinition newItem = PermissionDefinition(
        type: item.type,
        permissionStatus: status,
        checkCallback: item.checkCallback,
        settingsCallback: item.settingsCallback,
        requestCallback: item.requestCallback,
        enabled: item.enabled,
      );
      _permissionList.removeAt(index);
      _permissionList.insert(index, newItem);
      update();
    }
  }

  /// Helper function updates the activity status for a specific permission type.
  /// Finds the element with the specified permission type, updates its activity status, and then updates the entire permission list.
  /// Helper function is generally used to enable or disable users' permissions
  void updateEnabledStatusInList(PermissionType type, bool status) {
    if (permissionList.isNotEmpty) {
      int index = permissionList.indexWhere((e) => e.type == type);
      PermissionDefinition item = permissionList[index];
      PermissionDefinition newItem = PermissionDefinition(
        type: item.type,
        permissionStatus: item.permissionStatus,
        checkCallback: item.checkCallback,
        settingsCallback: item.settingsCallback,
        requestCallback: item.requestCallback,
        enabled: status,
      );
      _permissionList.removeAt(index);
      _permissionList.insert(index, newItem);
      update();
    }
  }

  //#endregion

  //#region Notification Permission
  /// This block of code manages notification permissions.
  /// The requestNotificationPermission function requests platform-specific notification permissions for iOS and Android.
  /// The isAndroidPermissionGranted function checks the status of notification permissions on Android and updates the notificationsEnabled variable.
  Future<void> requestNotificationPermission() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      final bool? grantedNotificationPermission =
          await androidImplementation?.requestNotificationsPermission();
    }
  }

  Future<void> isAndroidPermissionGranted() async {
    if (Platform.isAndroid) {
      final bool granted = await flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.areNotificationsEnabled() ??
          false;
    }
  }
  //#endregion
}
