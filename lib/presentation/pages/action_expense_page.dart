import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/core/di/app_dependencies.dart';
import 'package:gerenciador_gastos_v2/services/expense_service.dart';
import 'package:gerenciador_gastos_v2/presentation/themes/app_themes.dart';
import 'package:gerenciador_gastos_v2/core/utils/mixins/show_error.dart';
import 'package:gerenciador_gastos_v2/core/utils/mixins/show_snackbar.dart';
import 'package:gerenciador_gastos_v2/models/expense_read.dart';
import 'package:gerenciador_gastos_v2/core/utils/controllers_utils.dart';
import 'package:gerenciador_gastos_v2/core/utils/expansible_variables.dart';
import 'package:gerenciador_gastos_v2/core/utils/group_options_enum.dart';
import 'package:gerenciador_gastos_v2/presentation/widgets/button.dart';
import 'package:gerenciador_gastos_v2/presentation/widgets/expansible/date/expansible_date_body.dart';
import 'package:gerenciador_gastos_v2/presentation/widgets/expansible/date/expansible_date_header.dart';
import 'package:gerenciador_gastos_v2/presentation/widgets/expansible/expansible_widget.dart';
import 'package:gerenciador_gastos_v2/presentation/widgets/expansible/groupID/expansible_id_body.dart';
import 'package:gerenciador_gastos_v2/presentation/widgets/expansible/groupID/expansible_id_header.dart';
import 'package:gerenciador_gastos_v2/presentation/widgets/expansible/payment_method/expansible_payment_body.dart';
import 'package:gerenciador_gastos_v2/presentation/widgets/expansible/payment_method/expansible_payment_header.dart';
import 'package:gerenciador_gastos_v2/presentation/widgets/text_input.dart';

class ActionExpensePage extends StatefulWidget {
  final ActionsEnum action;
  final ExpenseRead? expenseData;

  const ActionExpensePage({
    required this.action, 
    this.expenseData, 
    super.key
  });

  @override
  State<ActionExpensePage> createState() => _ActionExpensePageState();
}

class _ActionExpensePageState extends State<ActionExpensePage> with ShowColoredSnackBar, ErrorDialog {
  final _controller = ControllerUtils.instance();
  final _expansibleVariables = ExpansibleVariables.instance();
  final _expenseService = ExpenseService();

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.color3,
        foregroundColor: AppThemes.color4,
        surfaceTintColor: Colors.transparent,
      ),
      backgroundColor: AppThemes.color3,
      body: Container(
        color: AppThemes.color3,
        padding: const EdgeInsets.all(10),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              spacing: 20,
              children: <Widget>[
                Text(
                  widget.action == ActionsEnum.update ? "Atualizar Gasto" : "Adicionar Gasto",
                  style: TextStyle(
                    color: AppThemes.color4,
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
                    paymentList: _expansibleVariables.paymentMethods,
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
                      db: AppDependencies.db,
                      setStateCallback: () => setState((){})
                    ),
                  ),
                Button(
                  label: widget.action == ActionsEnum.update ? "Atualizar" : "Adicionar", 
                  height: 60,
                  function: () {
                    executeAction(
                      isCreate: _expenseService.checkExpenseFields(
                        context: context, 
                        closeDialog: closeDialog
                      )
                    );
                  }
                )
              ]
            )
          ),
        )
      )
    );
  }

  void init() {
    _expenseService.getExpenseControllers();
    
    if (widget.expenseData == null && widget.action == ActionsEnum.create) {
      if (_controller.expenseGroupID!.text.isEmpty) {
        _expansibleVariables.groupName = ExpansibleVariables.name;
        _expansibleVariables.groupDate = ExpansibleVariables.date;
        _expansibleVariables.groupPayment = ExpansibleVariables.payment;
      }
    } else {
      _expenseService.getExpenseData(expenseData: widget.expenseData!);
    }
    _expansibleVariables.buildYear(currentYear: DateTime.now().year);
  }

  void executeAction({required bool isCreate}) async {
    if (isCreate) {
      _expenseService.executeAction(
        idList: [widget.expenseData?.id ?? 0, widget.expenseData?.groupID ?? 0], 
        isCreate: widget.action == ActionsEnum.create
      );
      showResponse(isSuccess: true, isCreate: widget.action == ActionsEnum.create);
      return;
    }
    showResponse(isSuccess: false);
  }

  void showResponse({required bool isSuccess, bool? isCreate}) {
    if (isSuccess) {
      if (!mounted) { return; }
      showColoredSnackBar(
        context: context, 
        msm: (isCreate ?? true) ? "Gasto adicionado com sucesso!" : "Gasto atualizado com sucesso!", 
        txtColor: const Color.fromARGB(255, 210, 232, 236)
      );
      (isCreate ?? true) ? Navigator.pop(context) : Navigator.pop<bool?>(context, true); 

      setState(() {});
      return;
    }
    showError(
      context: context, 
      title: "⚠️  Erro  ⚠️", 
      content: "Campos não preenchidos.", 
      closeDialog: closeDialog
    );
  }

  void closeDialog() {
    if (!mounted) { return; }
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _expenseService.getExpenseControllers();

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
