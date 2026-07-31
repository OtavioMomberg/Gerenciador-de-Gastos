import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/pages/expenses_calculated_page.dart';
import 'package:gerenciador_gastos_v2/services/database_service.dart';
import 'package:gerenciador_gastos_v2/utils/controllers_utils.dart';
import 'package:gerenciador_gastos_v2/utils/expansible_variables.dart';
import 'package:gerenciador_gastos_v2/utils/mixins/change_page.dart';
import 'package:gerenciador_gastos_v2/utils/mixins/show_error.dart';

class CalculationService with ChangePage, ErrorDialog {
  String result = "";
  final day = TextEditingController();
  final month = TextEditingController();
  final _controller = ControllerUtils.instance();
  final _expansibleVariables = ExpansibleVariables.instance();
  final _db = DatabaseService.instance();

  void init() {
    _expansibleVariables.groupName = ExpansibleVariables.name;
    _expansibleVariables.groupPayment = ExpansibleVariables.payment;

    _controller.expenseGroupID = TextEditingController();
    _controller.expensePaymentMethod = TextEditingController();
    _controller.expansibleGroupIDController = ExpansibleController();
    _controller.expansiblePaymentController = ExpansibleController();
  }

  void checkCalculatePage({required BuildContext context}) {
    String groupName = "";
    for (var group in _db.groupsWithoutFuture) {
      if (int.parse(_controller.expenseGroupID!.text) == group.id) {
        groupName = group.name;
        break;
      }
    }
    if (groupName.isEmpty) { return; }

    goNextPage(
      context: context, 
      index: 0, 
      page: ExpensesCalculatedPage(
        groupName: groupName, 
        paymentMethod: _controller.expensePaymentMethod!.text, 
        expenses: _db.expensesWithoutFuture
      )
    );
  }
  
  void clearFields() {
    result = "";
    day.clear();
    month.clear();
    _controller.expenseGroupID!.clear();
    _controller.expensePaymentMethod!.clear();
    init();
  }

  Future<bool> checkData({required BuildContext context, required VoidCallback closeDialog}) async {
    if (_controller.expenseGroupID!.text.isEmpty || _controller.expensePaymentMethod!.text.isEmpty) {
      showError(
        context: context, 
        title: "🚨  Atenção  🚨", 
        content: "Todos os campos devem ser preenchidos", 
        closeDialog: closeDialog
      );
      return false;
    }

    String? monthFormated;
    String? dayFormated;

    if (day.text.isNotEmpty && month.text.isNotEmpty) {
      dayFormated = day.text;
      monthFormated = month.text;
    }

    await _db.selectExpensesByGroupAndPaymentMethod(
      groupID: int.parse(_controller.expenseGroupID!.text), 
      paymentMethod: _controller.expensePaymentMethod!.text,
      day: dayFormated,
      month: monthFormated
    );

    dayFormated = null;
    monthFormated = null;
    return true;
  }

  void doCalculations() {
    double value = 0;
    for (var expense in _db.expensesWithoutFuture) {
      String price = expense.price.replaceAll(",", ".");
      value += (double.parse(price) * 100);
    }
    result = (value / 100).toString();
  }
}