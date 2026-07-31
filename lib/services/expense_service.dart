import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/models/expense_read.dart';
import 'package:gerenciador_gastos_v2/models/expense_write.dart';
import 'package:gerenciador_gastos_v2/services/database_service.dart';
import 'package:gerenciador_gastos_v2/utils/controllers_utils.dart';
import 'package:gerenciador_gastos_v2/utils/expansible_variables.dart';
import 'package:gerenciador_gastos_v2/utils/mixins/show_error.dart';

class ExpenseService with ErrorDialog {
  final int standardInstallment = 1;
  int _installments = 0;
  late ExpenseWrite _expenseData;

  int get installments => _installments;
  ExpenseWrite get expenseData => _expenseData;

  ExpenseService();

  static final _instance = ExpenseService._();
  ExpenseService._();
  factory ExpenseService.instance() => _instance;

  final _controller = ControllerUtils.instance();
  final _expansibleVariables = ExpansibleVariables.instance();
  final _db = DatabaseService.instance();

  // 0 - expenseID | 1 - groupID
  void executeAction({required List<int> idList, required bool isCreate}) async {
    updateInstallment();
    buildExpenseWriteObject();
    normalizePrice();
    isCreate ? await add() : await update(expenseID: idList[0], groupID: idList[1]);
  }

  void updateInstallment() {
    _installments = _controller.expenseInstallment!.text.isEmpty 
      ? standardInstallment
      : int.parse(_controller.expenseInstallment!.text);
  }

  void buildExpenseWriteObject() {
    _expenseData = ExpenseWrite(
      name: _controller.expenseName!.text, 
      price: _controller.expensePrice!.text, 
      paymentMethod: _controller.expensePaymentMethod!.text, 
      date: _controller.expenseDate!.text, 
      installments: installments,
      groupID: int.parse(_controller.expenseGroupID!.text)
    );
  }

  void normalizePrice() {
    if (expenseData.price.contains(".") || expenseData.price.contains(",")) {
      expenseData.price = expenseData.price.replaceAll(".", "").replaceAll(",", "");
    } else {
      expenseData.price = (int.parse(expenseData.price) * 100).toString();
    }      
    expenseData.price = (
      (int.parse(expenseData.price) / expenseData.installments!) / 100).toStringAsFixed(2);
  }

  Future<void> add() async {
    int firstDay = int.parse(expenseData.date.substring(0, 2));
    for (int i=0; i<installments; i++) {
      await _db.addExpense(expenseData: expenseData);
      expenseData.increaseMonth(day: firstDay);
      expenseData.decreaseInstallment();
    }
  }

  Future<void> update({required int expenseID, required int groupID}) async {
    if (expenseData.paymentMethod == ExpansibleVariables.payment2 && expenseData.installments != null) {
      expenseData.installments = int.tryParse(_controller.expenseInstallment!.text);
      await _db.updateExpense(expenseData: expenseData, expenseID: expenseID);

      int firstDay = int.parse(expenseData.date.substring(0, 2));

      for (int i=0; i<installments-1; i++) {
        expenseData.increaseMonth(day: firstDay);
        expenseData.decreaseInstallment();
        await _db.addExpense(expenseData: expenseData);    
      }
    } else {
      await _db.updateExpense(expenseData: expenseData, expenseID: expenseID);
    }
    await _db.selectExpensesByGroup(groupID: groupID);
  }

  void getExpenseControllers() {
    _controller.expensesList.clear();

    _controller.expensesList.add(_controller.expenseName = TextEditingController());
    _controller.expensesList.add(_controller.expensePrice = TextEditingController());
    _controller.expensesList.add(_controller.expensePaymentMethod = TextEditingController());
    _controller.expensesList.add(_controller.expenseDate = TextEditingController());
    _controller.expensesList.add(_controller.expenseInstallment = TextEditingController());
    _controller.expensesList.add(_controller.expenseGroupID = TextEditingController());

    _controller.expansibleDateController = ExpansibleController();
    _controller.expansiblePaymentController = ExpansibleController();
    _controller.expansibleGroupIDController = ExpansibleController();
  }

  void getExpenseData({required ExpenseRead expenseData}) {
    _controller.expenseName!.text = expenseData.name;
    _controller.expensePrice!.text = expenseData.price;
    _controller.expensePaymentMethod!.text = expenseData.paymentMethod;
    _controller.expenseDate!.text = expenseData.date;
    _controller.expenseGroupID!.text = expenseData.groupID.toString();

    if (_controller.expensePaymentMethod!.text.isNotEmpty) {
      _expansibleVariables.groupPayment = _controller.expensePaymentMethod!.text;
    }
    if (_controller.expenseDate!.text.isNotEmpty) {
      _expansibleVariables.groupDate = _controller.expenseDate!.text;
    }
  }

  bool checkExpenseFields({required BuildContext context, required VoidCallback closeDialog}) {
    if (_controller.expenseName!.text.isEmpty) { return false; }
    if (_controller.expensePrice!.text.isEmpty) { return false; }
    if (_controller.expensePaymentMethod!.text.isEmpty) { return false; }
    if (_controller.expenseDate!.text.isEmpty) { return false; }
    if (_controller.expenseGroupID!.text.isEmpty) { return false; }
    if (!_controller.expenseName!.text[0].contains(RegExp("[aA-zZ]"))) {
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