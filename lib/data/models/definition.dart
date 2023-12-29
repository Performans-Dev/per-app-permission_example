import 'package:permission_handler/permission_handler.dart';
import 'package:permission_example/core/constants/enum.dart';

class PermissionDefinition {
  final PermissionType type;
  final PermissionStatus permissionStatus;
  final Function() requestCallback;
  final Function()? settingsCallback;
  final Function() checkCallback;
  final bool enabled;
  PermissionDefinition({
    required this.type,
    required this.permissionStatus,
    required this.requestCallback,
    this.settingsCallback,
    required this.checkCallback,
    this.enabled = true,
  });
}
