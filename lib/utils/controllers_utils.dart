import 'package:flutter/widgets.dart';

typedef Controllers = List<TextEditingController>;
typedef ExpansibleControllers = List<ExpansibleController>;

class ControllerUtils {
  // GROUP TEXT CONTROLLERS
  TextEditingController? groupID;
  TextEditingController? groupName;
  TextEditingController? groupColor;

  // EXPENSES TEXT CONTROLLERS
  TextEditingController? expenseName;
  TextEditingController? expensePrice;
  TextEditingController? expensePaymentMethod;
  TextEditingController? expenseDate;
  TextEditingController? expenseGroupID;

  // EXPANSIBLE CONTROLLERS
  ExpansibleController? expansibleColorController;
  ExpansibleController? expansibleDateController;
  ExpansibleController? expansiblePaymentController;
  ExpansibleController? expansibleGroupIDController;

  final Controllers expensesList = [];
  final Controllers groupsList = [];

  static final _instance = ControllerUtils._();
  ControllerUtils._();
  factory ControllerUtils.instance() => _instance;

  void getExpenseControllers() {
    expensesList.clear();

    expensesList.add(expenseName = TextEditingController());
    expensesList.add(expensePrice = TextEditingController());
    expensesList.add(expensePaymentMethod = TextEditingController());
    expensesList.add(expenseDate = TextEditingController());
    expensesList.add(expenseGroupID = TextEditingController());
    expansibleDateController = ExpansibleController();
    expansiblePaymentController = ExpansibleController();
    expansibleGroupIDController = ExpansibleController();
  }

  void getGroupControllers() {
    groupsList.clear();

    groupsList.add(groupID = TextEditingController());
    groupsList.add(groupName = TextEditingController());
    groupsList.add(groupColor = TextEditingController());
    expansibleColorController = ExpansibleController();
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
