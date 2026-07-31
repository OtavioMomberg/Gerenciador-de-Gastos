import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/pages/expenses_calculated_page.dart';
import 'package:gerenciador_gastos_v2/services/database_service.dart';
import 'package:gerenciador_gastos_v2/themes/app_themes.dart';
import 'package:gerenciador_gastos_v2/utils/controllers_utils.dart';
import 'package:gerenciador_gastos_v2/utils/expansible_variables.dart';
import 'package:gerenciador_gastos_v2/utils/mixins/change_page.dart';
import 'package:gerenciador_gastos_v2/utils/mixins/show_error.dart';
import 'package:gerenciador_gastos_v2/widgets/button.dart';
import 'package:gerenciador_gastos_v2/widgets/expansible/expansible_widget.dart';
import 'package:gerenciador_gastos_v2/widgets/expansible/groupID/expansible_id_body.dart';
import 'package:gerenciador_gastos_v2/widgets/expansible/groupID/expansible_id_header.dart';
import 'package:gerenciador_gastos_v2/widgets/expansible/payment_method/expansible_payment_body.dart';
import 'package:gerenciador_gastos_v2/widgets/expansible/payment_method/expansible_payment_header.dart';
import 'package:gerenciador_gastos_v2/widgets/text_input.dart';

class CalculationPage extends StatefulWidget {
  const CalculationPage({super.key});

  @override
  State<CalculationPage> createState() => _CalculationPageState();
}

class _CalculationPageState extends State<CalculationPage> with ErrorDialog, ChangePage {
  final _db = DatabaseService.instance();
  final _controller = ControllerUtils.instance();
  final _expansibleVariables = ExpansibleVariables.instance();
  final day = TextEditingController();
  final month = TextEditingController();
  String result = "";

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
        title: const Text(
          "Calcule seus Gastos",
          style: AppThemes.textStyle
        )
      ),
      backgroundColor: AppThemes.color3,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: AppThemes.color3,
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            spacing: 10,
            children: <Widget>[
              const SizedBox(height: 40),
              ExpansibleWidget(
                header: ExpansibleIdHeader(
                  controller: _controller.expansibleGroupIDController!, 
                  setStateCallback: () => setState((){})
                ), 
                body: ExpansibleIdBody(
                  controller: _controller.expansibleGroupIDController!,
                  setStateCallback: () => setState((){})
                ), 
                controller: _controller.expansibleGroupIDController!
              ),
              ExpansibleWidget(
                header: ExpansiblePaymentHeader(
                  controller: _controller.expansiblePaymentController!, 
                  setStateCallback: () => setState((){})
                ), 
                body: ExpansiblePaymentBody(
                  controller: _controller.expansiblePaymentController!,
                  paymentList: _expansibleVariables.paymentMethodsCalculation,
                  setStateCallback: () => setState((){})
                ), 
                controller: _controller.expansiblePaymentController!
              ),
              Column(
                crossAxisAlignment: .start,
                children: <Widget>[
                  const Text(
                    "(*Opcional)",
                    style: TextStyle(
                      color: AppThemes.color2,
                      fontWeight: FontWeight.bold
                    )
                  ),
                  TextInput(
                    controller: day,
                    textHint: "Dia:",
                    inputType: TextInputType.number
                  )
                ]
              ),
              Column(
                crossAxisAlignment: .start,
                children: <Widget>[
                  const Text(
                    "(*Opcional)",
                    style: TextStyle(
                      color: AppThemes.color2,
                      fontWeight: FontWeight.bold
                    )
                  ),
                  TextInput(
                    controller: month,
                    textHint: "Mês:",
                    inputType: TextInputType.number
                  )
                ]
              ),
              const SizedBox(height: 10),
              Button(
                label: "Calcular", 
                height: 60,
                function: checkData,
              ),
              if (result.isNotEmpty)...[
                const SizedBox(height: 20),
                const Text(
                  "Resultado",
                  style: TextStyle(
                    color: AppThemes.color4,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  )
                ),
                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: AppThemes.borderRadius,
                    border: Border.all(color: AppThemes.color4)
                  ),
                  child: Center(
                    child: Text(
                      !(result.startsWith("0") && result == "0") 
                        ? "R\$ $result" 
                        : "Sem gastos no ${_controller.expensePaymentMethod!.text}",
                      style: TextStyle(
                        color: AppThemes.color4,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      )
                    )
                  )
                ),
                Row(
                  spacing: 10,
                  children: <Widget>[
                    Expanded(
                      child: Button(
                        label: "Ver gastos calculados",
                        height: 60,
                        function: () => checkCalculatePage(),
                      )
                    ),
                    Expanded(
                      child: Button(
                        label: "Limpar", 
                        height: 60,
                        function: () => clearFields(),
                      )
                    )
                  ]
                )  
              ]
            ]
          )
        )
      )
    );
  }

  void init() {
    _expansibleVariables.groupName = ExpansibleVariables.name;
    _expansibleVariables.groupPayment = ExpansibleVariables.payment;

    _controller.expenseGroupID = TextEditingController();
    _controller.expensePaymentMethod = TextEditingController();
    _controller.expansibleGroupIDController = ExpansibleController();
    _controller.expansiblePaymentController = ExpansibleController();
  }

  void checkCalculatePage() {
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
    setState(() {});
  }

  void checkData() async {
    if (_controller.expenseGroupID!.text.isEmpty || _controller.expensePaymentMethod!.text.isEmpty) {
      showError(
        context: context, 
        title: "🚨  Atenção  🚨", 
        content: "Todos os campos devem ser preenchidos", 
        closeDialog: closeDialog
      );
      return;
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
    doCalculations();
  }

  void doCalculations() {
    double value = 0;
    for (var expense in _db.expensesWithoutFuture) {
      String price = expense.price.replaceAll(",", ".");
      value += (double.parse(price) * 100);
    }
    result = (value / 100).toString();
    setState(() {});
  }

  void closeDialog() {
    _controller.expenseGroupID!.clear();
    _controller.expensePaymentMethod!.clear();
    if (!mounted) {
      return;
    }
    Navigator.pop(context);
  }

  @override
  void dispose() {
    day.dispose();
    month.dispose();
    _controller.expenseGroupID!.dispose();
    _controller.expensePaymentMethod!.dispose();
    _controller.expansibleGroupIDController!.dispose();
    _controller.expansiblePaymentController!.dispose();
    super.dispose();
  }
}