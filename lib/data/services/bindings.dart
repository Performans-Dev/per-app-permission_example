import 'package:get/get.dart';
import 'package:permission_example/data/services/app.dart';

class AwaitBindings extends Bindings {
  @override
  Future<void> dependencies() async {
    await Get.putAsync<PermissionController>(
      () async => PermissionController(),
      permanent: true,
    );
  }
}
