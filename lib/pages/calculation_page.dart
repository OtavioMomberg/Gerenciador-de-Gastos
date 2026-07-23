import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/services/database_service.dart';
import 'package:gerenciador_gastos_v2/utils/controllers_utils.dart';
import 'package:gerenciador_gastos_v2/utils/expansible_variables.dart';
import 'package:gerenciador_gastos_v2/utils/mixins/show_error.dart';
import 'package:gerenciador_gastos_v2/widgets/button.dart';
import 'package:gerenciador_gastos_v2/widgets/expansible/expansible_widget.dart';
import 'package:gerenciador_gastos_v2/widgets/expansible/groupID/expansible_id_body.dart';
import 'package:gerenciador_gastos_v2/widgets/expansible/groupID/expansible_id_header.dart';
import 'package:gerenciador_gastos_v2/widgets/expansible/payment_method/expansible_payment_body.dart';
import 'package:gerenciador_gastos_v2/widgets/expansible/payment_method/expansible_payment_header.dart';

class CalculationPage extends StatefulWidget {
  const CalculationPage({super.key});

  @override
  State<CalculationPage> createState() => _CalculationPageState();
}

class _CalculationPageState extends State<CalculationPage> with ErrorDialog {
  final _db = DatabaseService.instance();
  final _controller = ControllerUtils.instance();
  final _expansibleVariables = ExpansibleVariables.instance();
  String result = "";

  @override
  void initState() {
    super.initState();

    _expansibleVariables.groupName = ExpansibleVariables.name;
    _expansibleVariables.groupPayment = ExpansibleVariables.payment;
    _controller.expansibleGroupIDController = ExpansibleController();
    _controller.expansiblePaymentController = ExpansibleController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 234, 242, 252),
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 0
      ),
      backgroundColor: const Color.fromARGB(255, 234, 242, 252),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: const Color.fromARGB(255, 234, 242, 252),
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            spacing: 10,
            children: <Widget>[
              const Text(
                "Calcule seus Gastos",
                style: TextStyle(
                  color: Color.fromARGB(255, 136, 136, 136),
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                )
              ), 
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
              Button(
                label: "Calcular", 
                height: 60,
                function: checkData,
              ),
              if (result.isNotEmpty)...[
                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color.fromARGB(255, 136, 136, 136))
                  ),
                  child: Center(
                    child: Text(
                      result,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 136, 136, 136),
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      )
                    )
                  ),
                )
              ]
            ]
          )
        )
      )
    );
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
    await _db.selectExpensesByGroupAndPaymentMethod(
      groupID: int.parse(_controller.expenseGroupID!.text), 
      paymentMethod: _controller.expensePaymentMethod!.text
    );
    doCalculations();
  }

  void doCalculations() {
    int value = 0;
    for (var expense in _db.expensesWithoutFuture) {
      String price = expense.price.replaceAll(".", "").replaceAll(",", "");
      value += int.parse(price);
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
    _controller.expenseGroupID!.dispose();
    _controller.expensePaymentMethod!.dispose();
    _controller.expansibleGroupIDController!.dispose();
    _controller.expansiblePaymentController!.dispose();
    super.dispose();
  }
}