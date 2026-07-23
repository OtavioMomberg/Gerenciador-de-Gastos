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
      _controller.getExpenseData(expenseData: widget.expenseData!);
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
                function: executeAction
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

  void executeAction() async {
    if (_controller.checkExpenseFields(context: context, closeDialog: closeDialog)) {
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
      if (expenseData.price.contains(".") || expenseData.price.contains(",")) {
        expenseData.price = expenseData.price.replaceAll(".", "").replaceAll(",", "");
      } else {
        expenseData.price = (int.parse(expenseData.price) * 100).toString();
      }
      
      expenseData.price = ((int.parse(expenseData.price) / expenseData.installments!) / 100).toStringAsFixed(2);

      if (check) {
        int firstDay = int.parse(expenseData.date.substring(0, 2));
        for (int i=0; i<installments; i++) {
          await _db.addExpense(expenseData: expenseData);
          expenseData.increaseMonth(day: firstDay);
          expenseData.decreaseInstallment();
        }
      } else {
        if (expenseData.paymentMethod == "Crédito" && expenseData.installments != null) {
          expenseData.installments = int.tryParse(_controller.expenseInstallment!.text);
          await _db.updateExpense(expenseData: expenseData, expenseID: widget.expenseData!.id);

          int firstDay = int.parse(expenseData.date.substring(0, 2));

          for (int i=0; i<installments-1; i++) {
            expenseData.increaseMonth(day: firstDay);
            expenseData.decreaseInstallment();
            await _db.addExpense(expenseData: expenseData);    
          }
        } else {
          await _db.updateExpense(expenseData: expenseData, expenseID: widget.expenseData!.id);
        }
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
    check ? Navigator.pop(context) : Navigator.pop<bool?>(context, true); 

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
