import 'package:gerenciador_gastos_v2/database/db.dart';
import 'package:gerenciador_gastos_v2/models/group_read.dart';
import 'package:gerenciador_gastos_v2/models/group_write.dart';

class DatabaseService {
  // DATABASE INSTANCE
  final database = DB.instance();

  // SINGLETON SERVICE INSTANCE
  static final _instance = DatabaseService._();
  DatabaseService._();
  factory DatabaseService.instance() => _instance;

  late Future<List<GroupRead>> groups;

  Future<void> selectGroups() async {
    groups = database.selectGroups();
  }

  Future<void> addGroup({required GroupWrite groupData}) async {
    await database.addGroup(groupData: groupData);
  }
}