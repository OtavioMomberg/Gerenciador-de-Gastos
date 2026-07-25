import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/pages/expenses_calculated_page.dart';
import 'package:gerenciador_gastos_v2/services/database_service.dart';
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
        backgroundColor: const Color.fromARGB(255, 234, 242, 252),
        foregroundColor: const Color.fromARGB(255, 136, 136, 136),
        surfaceTintColor: Colors.transparent,
        title: const Text(
          "Calcule seus Gastos",
          style: TextStyle(
            color: Color.fromARGB(255, 136, 136, 136),
            fontWeight: FontWeight.bold
          )
        )
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
                      color: Color.fromARGB(255, 255, 140, 132),
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
                      color: Color.fromARGB(255, 255, 140, 132),
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
                    color: Color.fromARGB(255, 136, 136, 136),
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  )
                ),
                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color.fromARGB(255, 136, 136, 136))
                  ),
                  child: Center(
                    child: Text(
                      !(result.startsWith("0") && result == "0") 
                        ? "R\$ $result" 
                        : "Sem gastos no ${_controller.expensePaymentMethod!.text}",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 136, 136, 136),
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
                        function: () {
                          String groupName = "";
                          for (var group in _db.groupsWithoutFuture) {
                            if (int.parse(_controller.expenseGroupID!.text) == group.id) {
                              groupName = group.name;
                              break;
                            }
                          }
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
                      )
                    ),
                    Expanded(
                      child: Button(
                        label: "Limpar", 
                        height: 60,
                        function: () {
                          result = "";
                          day.clear();
                          month.clear();
                          _controller.expenseGroupID!.clear();
                          _controller.expensePaymentMethod!.clear();
                          init();
                          setState(() {});
                        }
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

    String? dayFormated;
    String? monthFormated;

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