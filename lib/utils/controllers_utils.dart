import 'package:flutter/widgets.dart';
import 'package:gerenciador_gastos_v2/models/expense_read.dart';
import 'package:gerenciador_gastos_v2/utils/expansible_variables.dart';
import 'package:gerenciador_gastos_v2/utils/mixins/show_error.dart';

typedef Controllers = List<TextEditingController>;
typedef ExpansibleControllers = List<ExpansibleController>;

class ControllerUtils with ErrorDialog {
  final _expansibleVariables = ExpansibleVariables.instance();

  // GROUP TEXT CONTROLLERS
  TextEditingController? groupID;
  TextEditingController? groupName;
  TextEditingController? groupColor;

  // EXPENSES TEXT CONTROLLERS
  TextEditingController? expenseName;
  TextEditingController? expensePrice;
  TextEditingController? expensePaymentMethod;
  TextEditingController? expenseDate;
  TextEditingController? expenseInstallment;
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
    expensesList.add(expenseInstallment = TextEditingController());
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

  void getExpenseData({required ExpenseRead expenseData}) {
    expenseName!.text = expenseData.name;
    expensePrice!.text = expenseData.price;
    expensePaymentMethod!.text = expenseData.paymentMethod;
    expenseDate!.text = expenseData.date;
    expenseGroupID!.text = expenseData.groupID.toString();

    if (expensePaymentMethod!.text.isNotEmpty) {
      _expansibleVariables.groupPayment = expensePaymentMethod!.text;
    }
    if (expenseDate!.text.isNotEmpty) {
      _expansibleVariables.groupDate = expenseDate!.text;
    }
  }

  bool checkExpenseFields({required BuildContext context, required VoidCallback closeDialog}) {
    if (expenseName!.text.isEmpty) { return false; }
    if (expensePrice!.text.isEmpty) { return false; }
    if (expensePaymentMethod!.text.isEmpty) { return false; }
    if (expenseDate!.text.isEmpty) { return false; }
    if (expenseGroupID!.text.isEmpty) { return false; }
    if (!expenseName!.text[0].contains(RegExp("[aA-zZ]"))) {
      showError(
        context: context,
        title: "⚠️  Erro  ⚠️",
        content: "O nome deve começar com uma letra.",
        closeDialog: closeDialog,
      );
      return false;
    }
    return true;
  }
}
