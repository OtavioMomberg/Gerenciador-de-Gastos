import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/utils/mixins/show_error.dart';
import 'package:gerenciador_gastos_v2/utils/mixins/show_snackbar.dart';
import 'package:gerenciador_gastos_v2/models/expense_read.dart';
import 'package:gerenciador_gastos_v2/models/expense_write.dart';
import 'package:gerenciador_gastos_v2/services/database_service.dart';
import 'package:gerenciador_gastos_v2/utils/controllers_utils.dart';
import 'package:gerenciador_gastos_v2/utils/expansible_variables.dart';
import 'package:gerenciador_gastos_v2/utils/group_options_enum.dart';
import 'package:gerenciador_gastos_v2/widgets/button.dart';
import 'package:gerenciador_gastos_v2/widgets/expansible/date/expansible_date_body.dart';
import 'package:gerenciador_gastos_v2/widgets/expansible/date/expansible_date_header.dart';
import 'package:gerenciador_gastos_v2/widgets/expansible/expansible_widget.dart';
import 'package:gerenciador_gastos_v2/widgets/expansible/groupID/expansible_id_body.dart';
import 'package:gerenciador_gastos_v2/widgets/expansible/groupID/expansible_id_header.dart';
import 'package:gerenciador_gastos_v2/widgets/expansible/payment_method/expansible_payment_body.dart';
import 'package:gerenciador_gastos_v2/widgets/expansible/payment_method/expansible_payment_header.dart';
import 'package:gerenciador_gastos_v2/widgets/text_input.dart';

class ActionExpensePage extends StatefulWidget {
  final ActionsEnum action;
  final ExpenseRead? expenseData;

  const ActionExpensePage({required this.action, this.expenseData, super.key});

  @override
  State<ActionExpensePage> createState() => _ActionExpensePageState();
}

class _ActionExpensePageState extends State<ActionExpensePage> with ShowColoredSnackBar, ErrorDialog {
  final _controller = ControllerUtils.instance();
  final _expansibleVariables = ExpansibleVariables.instance();
  final _db = DatabaseService.instance();

  @override
  void initState() {
    super.initState();

    initControllers();

    if (widget.expenseData == null && widget.action == ActionsEnum.create) {
      if (_controller.expenseGroupID!.text.isEmpty) {
        _expansibleVariables.groupName = ExpansibleVariables.name;
        _expansibleVariables.groupDate = ExpansibleVariables.date;
        _expansibleVariables.groupPayment = ExpansibleVariables.payment;
      }
    } else {
      getData();
    }

    _expansibleVariables.buildYear(currentYear: DateTime.now().year);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 234, 242, 252),
        foregroundColor: const Color.fromARGB(255, 136, 136, 136),
        surfaceTintColor: Colors.transparent,
      ),
      backgroundColor: const Color.fromARGB(255, 234, 242, 252),
      body: Container(
        color: const Color.fromARGB(255, 234, 242, 252),
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            spacing: 20,
            children: <Widget>[
              Text(
                widget.action == ActionsEnum.update 
                ? "Atualizar Gasto" : "Adicionar Gasto",
                style: TextStyle(
                  color: Color.fromARGB(255, 136, 136, 136),
                  fontSize: 30,
                  fontWeight: FontWeight.bold
                )
              ),
              const SizedBox(height: 10),
              TextInput(
                controller: _controller.expenseName!,
                textHint: "Local da compra:"
              ),
              TextInput(
                controller: _controller.expensePrice!,
                textHint: "Preço:",
                inputType: TextInputType.number
              ),
              ExpansibleWidget(
                controller: _controller.expansiblePaymentController!,
                header: ExpansiblePaymentHeader(
                  controller: _controller.expansiblePaymentController!,
                  setStateCallback: () => setState((){})
                ),
                body: ExpansiblePaymentBody(
                  controller: _controller.expansiblePaymentController!,
                  setStateCallback: () => setState(() {})
                )
              ),
              ExpansibleWidget(
                controller: _controller.expansibleDateController!,
                header: ExpansibleDateHeader(
                  controller: _controller.expansibleDateController!,
                  setStateCallback: () => setState((){})
                ),
                body: ExpansibleDateBody(
                  controller: _controller.expansibleDateController!,
                  setStateCallback: () => setState(() {})
                )
              ),
              if (widget.action == ActionsEnum.create)
                ExpansibleWidget(
                  controller: _controller.expansibleGroupIDController!,
                  header: ExpansibleIdHeader(
                    controller: _controller.expansibleGroupIDController!,
                    setStateCallback: () => setState((){})
                  ),
                  body: ExpansibleIdBody(
                    controller: _controller.expansibleGroupIDController!,
                    setStateCallback: () => setState(() {})
                  )
                ),
              Button(
                label: widget.action == ActionsEnum.update ? "Atualizar" : "Adicionar", 
                height: 60,
                function: addExpense
              )
            ]
          )
        )
      )
    );
  }

  void initControllers() {
    _controller.getExpenseControllers();
  }

  void getData() {
    _controller.expenseName!.text = widget.expenseData!.name;
    _controller.expensePrice!.text = widget.expenseData!.price;
    _controller.expensePaymentMethod!.text = widget.expenseData!.paymentMethod;
    _controller.expenseDate!.text = widget.expenseData!.date;
    _controller.expenseGroupID!.text = widget.expenseData!.groupID.toString();

    if (_controller.expensePaymentMethod!.text.isNotEmpty) {
      _expansibleVariables.groupPayment = _controller.expensePaymentMethod!.text;
    }
    if (_controller.expenseDate!.text.isNotEmpty) {
      _expansibleVariables.groupDate = _controller.expenseDate!.text;
    }
  }

  bool checkFields() {
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

  void addExpense() async {
    if (checkFields()) {
      final int installments = _controller.expenseInstallment!.text.isEmpty 
        ? 1
        : int.parse(_controller.expenseInstallment!.text);

      final expenseData = ExpenseWrite(
        name: _controller.expenseName!.text, 
        price: _controller.expensePrice!.text, 
        paymentMethod: _controller.expensePaymentMethod!.text, 
        date: _controller.expenseDate!.text, 
        installments: installments,
        groupID: int.parse(_controller.expenseGroupID!.text)
      );

      final check = widget.action == ActionsEnum.create;

      if (check) {
        int day = int.parse(expenseData.date.substring(0, 2));

        for (int i=0; i<installments; i++) {
          await _db.addExpense(expenseData: expenseData);
          expenseData.increaseMonth(day: day);
          expenseData.decreaseInstallment();
        }
      } else {
        await _db.updateExpense(expenseData: expenseData, expenseID: widget.expenseData!.id);
        await _db.selectExpensesByGroup(groupID: widget.expenseData!.groupID);
      }
      showSnackBar(check: check);
      return;
    }
    showError(
      context: context, 
      title: "⚠️  Erro  ⚠️", 
      content: "Campos não preenchidos.", 
      closeDialog: closeDialog
    );
  }

  void showSnackBar({required bool check}) {
   showColoredSnackBar(
    context: context, 
    msm: check ? "Gasto adicionado com sucesso!" : "Gasto atualizado com sucesso!", 
    txtColor: const Color.fromARGB(255, 210, 232, 236)
    );
    Navigator.pop(context); 

    if (!mounted) { return; }
    setState(() {});
  }

  void closeDialog() {
    if (!mounted) {
      return;
    }
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _controller.getExpenseControllers();

    if (_controller.expensesList.isNotEmpty) {
      for (var expense in _controller.expensesList) {
        expense.dispose();
      }
    }
    _controller.expansibleDateController!.dispose();
    _controller.expansiblePaymentController!.dispose();
    _controller.expansibleGroupIDController!.dispose();
    super.dispose();
  }
}
