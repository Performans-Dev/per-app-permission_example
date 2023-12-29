import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_example/data/services/app.dart';
import 'package:permission_example/core/utils/ui.dart';

class PermissionListScreen extends StatefulWidget {
  const PermissionListScreen({Key? key}) : super(key: key);

  @override
  State<PermissionListScreen> createState() => _PermissionListScreenState();
}

class _PermissionListScreenState extends State<PermissionListScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state case AppLifecycleState.resumed) {
      final PermissionController pc = Get.find();
      pc.checkPermissionStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PermissionController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Permission List"),
          ),
          body: controller.permissionList.isNotEmpty
              ? ListView.builder(
                  itemCount: controller.permissionList.length + 1,
                  itemBuilder: (context, index) {
                    return index >= controller.permissionList.length
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: ListTile(
                              title: const Text("Notification"),
                              trailing: GetPlatform.isAndroid
                                  ? const Icon(Icons.check)
                                  : null,
                              onTap: () {
                                controller.requestNotificationPermission();
                              },
                            ),
                          )
                        : UI.buildPermissionListTile(
                            controller.permissionList[index]);
                  },
                )
              : const Center(
                  child: Text("Unable to show permission list"),
                ),
        );
      },
    );
  }
}
