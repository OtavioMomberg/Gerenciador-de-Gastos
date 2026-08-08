import 'package:gerenciador_gastos_v2/controllers/database_controller.dart';
import 'package:gerenciador_gastos_v2/services/group_service.dart';

class AppDependencies {
  static final db = DatabaseController.instance();

  static final groupService = GroupService.instance();
}