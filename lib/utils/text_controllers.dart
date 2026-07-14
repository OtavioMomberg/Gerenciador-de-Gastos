import 'package:flutter/widgets.dart';

typedef Controllers = List<TextEditingController>;

class TextControllers {
  // GROUP TEXT CONTROLLERS
  final TextEditingController groupID = TextEditingController();
  final TextEditingController groupName = TextEditingController();
  final TextEditingController groupColor = TextEditingController();

  // EXPENSES TEXT CONTROLLERS
  final TextEditingController expenseName = TextEditingController();
  final TextEditingController expensePrice = TextEditingController();
  final TextEditingController expensePaymentMethod = TextEditingController();
  final TextEditingController expenseDate = TextEditingController();

  final Controllers expensesList = [];
  final Controllers groupsList = [];

  static final _instance = TextControllers._();
  TextControllers._();
  factory TextControllers.instance() => _instance;

  void getExpenseControllers() {
    expensesList.clear();

    expensesList.add(expenseName);
    expensesList.add(expensePrice);
    expensesList.add(expensePaymentMethod);
    expensesList.add(expenseDate);
  }

  void getGroupControllers() {
    groupsList.clear();

    groupsList.add(groupID);
    groupsList.add(groupName);
    groupsList.add(groupColor);
  }

  void clearExpensesList() {
    for (var expense in expensesList) {
      expense.clear();
    }
  }

  void clearGroupsList() {
    for (var group in groupsList) {
      group.clear();
    }
  }
}