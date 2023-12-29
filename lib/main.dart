import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_example/data/services/bindings.dart';
import 'package:permission_example/screens/list.dart';

void main() async {
  await AwaitBindings().dependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: AwaitBindings(),
      debugShowCheckedModeBanner: true,
      theme: ThemeData(useMaterial3: true),
      home: const PermissionListScreen(),
    );
  }
}
