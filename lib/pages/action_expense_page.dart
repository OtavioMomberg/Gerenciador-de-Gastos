import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/models/expense_read.dart';
//import 'package:gerenciador_gastos_v2/services/database_service.dart';
import 'package:gerenciador_gastos_v2/utils/controllers_utils.dart';
import 'package:gerenciador_gastos_v2/utils/expansible_variables_expense_page.dart';
import 'package:gerenciador_gastos_v2/utils/group_options_enum.dart';
import 'package:gerenciador_gastos_v2/widgets/button.dart';
//import 'package:gerenciador_gastos_v2/widgets/expansible/date/expansible_date_body.dart';
//import 'package:gerenciador_gastos_v2/widgets/expansible/date/expansible_date_header.dart';
import 'package:gerenciador_gastos_v2/widgets/expansible/expansible_widget.dart';
import 'package:gerenciador_gastos_v2/widgets/expansible/groupID/expansible_id_body.dart';
import 'package:gerenciador_gastos_v2/widgets/expansible/groupID/expansible_id_header.dart';
import 'package:gerenciador_gastos_v2/widgets/text_input.dart';

class ActionExpensePage extends StatefulWidget {
  final ActionsEnum action;
  final ExpenseRead? expenseData;

  const ActionExpensePage({required this.action, this.expenseData, super.key});

  @override
  State<ActionExpensePage> createState() => _ActionExpensePageState();
}

class _ActionExpensePageState extends State<ActionExpensePage> {
  final _controller = ControllerUtils.instance();
  final _expansibleVariables = ExpansibleVariablesExpensePage.instance();
  //final _db = DatabaseService.instance();

  @override
  void initState() {
    super.initState();

    initControllers();

    if (widget.expenseData != null && widget.action == ActionsEnum.update) {
      getData();
    }

    if (_controller.expenseGroupID!.text.isEmpty) {
      _expansibleVariables.groupName = "Insira o nome de um grupo";
    }
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
              const Text(
                "Adicionar Gasto",
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
              if (widget.action == ActionsEnum.create)
                ExpansibleWidget(
                  controller: _controller.expansibleGroupIDController!,
                  header: ExpansibleIdHeader(
                    controller: _controller.expansibleGroupIDController!
                  ),
                  body: ExpansibleIdBody(
                    controller: _controller.expansibleGroupIDController!,
                    setStateCallback: () => setState(() {})
                  )
                ),
              Button(label: "Adicionar", height: 60)
            ]
          ),
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
