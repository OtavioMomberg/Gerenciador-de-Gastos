import 'package:gerenciador_gastos_v2/models/expense_read.dart';
import 'package:gerenciador_gastos_v2/models/expense_write.dart';
import 'package:gerenciador_gastos_v2/models/group_read.dart';
import 'package:gerenciador_gastos_v2/models/group_write.dart';
import 'package:gerenciador_gastos_v2/database/db_columns_info.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

typedef RawQuery = List<Map<String, dynamic>>;

class DB {
  // DATABASE INSTANCE
  Database? _db;

  // SINGLETON INSTANCE
  static final _instance = DB._();
  DB._();
  factory DB.instance() => _instance;

  // CHECK IF DATABASE IS CREATED
  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    }
    _db = await createDatabase();
    return _db!;
  }

  //+=======================================================================+
  //                            DATABASE CREATION
  //+=======================================================================+

  Future<Database> createDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "expenses_manager.db");
    final database = await openDatabase(
      databasePath,
      version: 1,
      onConfigure: (db) async {
        await db.execute("PRAGMA foreign_keys = ON");
      },
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS ${DbColumnsInfo.groupTableName} (
            ${DbColumnsInfo.idGroupTable} INTEGER PRIMARY KEY,
            ${DbColumnsInfo.nameGroupTable} TEXT NOT NULL UNIQUE,
            ${DbColumnsInfo.colorGroupTable} TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS ${DbColumnsInfo.expenseTableName} (
            ${DbColumnsInfo.idExpenseTable} INTEGER PRIMARY KEY,
            ${DbColumnsInfo.nameExpenseTable} TEXT NOT NULL,
            ${DbColumnsInfo.priceExpenseTable} TEXT NOT NULL,
            ${DbColumnsInfo.paymentMethodExpenseTable} TEXT NOT NULL,
            ${DbColumnsInfo.dateExpenseTable} TEXT NOT NULL,
            ${DbColumnsInfo.groupIdExpenseTable} INTEGER NOT NULL, 
            FOREIGN KEY (${DbColumnsInfo.groupIdExpenseTable})
              REFERENCES ${DbColumnsInfo.groupTableName}(${DbColumnsInfo.idGroupTable})
              ON DELETE CASCADE
          )
        ''');
      },
    );
    return database;
  }

  //+==================================================================+
  //                            GROUPS TABLE
  //+==================================================================+

  Future<void> addGroup({required GroupWrite groupData}) async {
    final db = await database;

    try {
      await db.insert(DbColumnsInfo.groupTableName, {
        DbColumnsInfo.nameGroupTable: groupData.name[0].toUpperCase() + groupData.name.substring(1),
        DbColumnsInfo.colorGroupTable: groupData.color,
      });
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<List<GroupRead>> selectGroups() async {
    final db = await database;
    final RawQuery query;

    try {
      query = await db.query(DbColumnsInfo.groupTableName);

      if (query.isEmpty) {
        return [];
      }

      final groups = query.map((group) => GroupRead.fromMap(map: group)).toList();
      return groups;
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<GroupRead?> selectGroupByName({required String name}) async {
    final db = await database;
    final RawQuery query;

    try {
      query = await db.query(
        DbColumnsInfo.groupTableName,
        where: "${DbColumnsInfo.nameGroupTable} = ?",
        whereArgs: [name],
      );

      if (query.isEmpty) {
        return null;
      }

      final group = query.map((group) => GroupRead.fromMap(map: group)).first;
      return group;
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> updateGroup({required GroupWrite groupData, required int groupID}) async {
    final db = await database;

    try {
      final response = await db.update(
        DbColumnsInfo.groupTableName,
        {
          DbColumnsInfo.nameGroupTable: groupData.name[0].toUpperCase() + groupData.name.substring(1),
          DbColumnsInfo.colorGroupTable: groupData.color,
        },
        where: "${DbColumnsInfo.idGroupTable} = ?",
        whereArgs: [groupID],
      );
      if (response == 0) {
        throw Exception("Grupo não encontrado.");
      }
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> deleteGroup({required int groupID}) async {
    final db = await database;

    try {
      final response = await db.delete(
        DbColumnsInfo.groupTableName,
        where: "${DbColumnsInfo.idGroupTable} = ?",
        whereArgs: [groupID],
      );
      if (response == 0) {
        throw Exception("Grupo não encontrado.");
      }
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  //+====================================================================+
  //                            EXPENSES TABLE
  //+====================================================================+

  Future<void> addExpense({required ExpenseWrite expenseData}) async {
    final db = await database;

    try {
      await db.insert(DbColumnsInfo.expenseTableName, {
        DbColumnsInfo.nameExpenseTable: expenseData.name,
        DbColumnsInfo.priceExpenseTable: expenseData.price,
        DbColumnsInfo.paymentMethodExpenseTable: expenseData.paymentMethod,
        DbColumnsInfo.dateExpenseTable: expenseData.date,
        DbColumnsInfo.groupIdExpenseTable: expenseData.groupID,
      });
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<List<ExpenseRead>> selectExpenses({int limit = 100}) async {
    final db = await database;
    final RawQuery query;

    try {
      query = await db.query(
        DbColumnsInfo.expenseTableName,
        orderBy: "${DbColumnsInfo.dateExpenseTable} DESC",
        limit: limit,
      );

      if (query.isEmpty) {
        return [];
      }

      final expenses = query
          .map((expense) => ExpenseRead.fromMap(map: expense))
          .toList();
      return expenses;
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<ExpenseRead> selectExpenseByID({required int expenseID}) async {
    final db = await database;
    final RawQuery query;

    try {
      query = await db.query(
        DbColumnsInfo.expenseTableName,
        where: "${DbColumnsInfo.idExpenseTable} = ?",
        whereArgs: [expenseID],
      );

      if (query.isEmpty) {
        throw Exception("Despesa não encontrada.");
      }

      final expense = query
          .map((expense) => ExpenseRead.fromMap(map: expense))
          .first;
      return expense;
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<List<ExpenseRead>> selectExpensesByGroup({required int groupID}) async {
    final db = await database;
    final RawQuery query;

    try {
      query = await db.query(
        DbColumnsInfo.expenseTableName,
        where: "${DbColumnsInfo.groupIdExpenseTable} = ?",
        whereArgs: [groupID],
      );

      if (query.isEmpty) {
        return [];
      }

      final expenses = query.map((expense) => ExpenseRead.fromMap(map: expense)).toList();
      return expenses;
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> updateExpense({required ExpenseWrite expenseData, required int expenseID}) async {
    final db = await database;

    try {
      final response = await db.update(
        DbColumnsInfo.expenseTableName,
        {
          DbColumnsInfo.nameExpenseTable: expenseData.name,
          DbColumnsInfo.priceExpenseTable: expenseData.price,
          DbColumnsInfo.paymentMethodExpenseTable: expenseData.paymentMethod,
          DbColumnsInfo.dateExpenseTable: expenseData.date,
          DbColumnsInfo.groupIdExpenseTable: expenseData.groupID,
        },
        where: "${DbColumnsInfo.idExpenseTable} = ?",
        whereArgs: [expenseID],
      );
      if (response == 0) {
        throw Exception("Item não encontrado.");
      }
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> deleteExpense({required int expenseID}) async {
    final db = await database;

    try {
      final response = await db.delete(
        DbColumnsInfo.expenseTableName,
        where: "${DbColumnsInfo.idExpenseTable} = ?",
        whereArgs: [expenseID],
      );
      if (response == 0) {
        throw Exception("Item não encontrado.");
      }
    } catch (error) {
      throw Exception(error.toString());
    }
  }
}
