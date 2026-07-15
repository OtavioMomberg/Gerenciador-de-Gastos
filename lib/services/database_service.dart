import 'package:gerenciador_gastos_v2/database/db.dart';
import 'package:gerenciador_gastos_v2/models/expense_read.dart';
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
  late List<ExpenseRead> expenses;

  // GROUP ACTIONS
  void selectGroups() {
    groups = database.selectGroups();
  }

  Future<void> addGroup({required GroupWrite groupData}) async {
    await database.addGroup(groupData: groupData);
  }

  Future<void> updateGroup({required GroupWrite groupData, required int groupID}) async {
    await database.updateGroup(groupData: groupData, groupID: groupID);
  }

  Future<void> deleteGroup({required int groupID}) async {
    await database.deleteGroup(groupID: groupID);
  }

  // EXPENSE ACTIONS
  void selectExpensesByGroup({required int groupID}) async {
    final expensesFuture = database.selectExpensesByGroup(groupID: groupID);
    expenses = await expensesFuture;
  }
}
