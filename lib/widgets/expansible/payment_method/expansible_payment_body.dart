import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/utils/controllers_utils.dart';
import 'package:gerenciador_gastos_v2/utils/expansible_variables.dart';
import 'package:gerenciador_gastos_v2/widgets/button.dart';
import 'package:gerenciador_gastos_v2/widgets/text_input.dart';

class ExpansiblePaymentBody extends StatelessWidget {
  final ExpansibleController controller;
  final VoidCallback setStateCallback;

  ExpansiblePaymentBody({
    required this.controller,
    required this.setStateCallback,
    super.key
  });

  final _expansibleVariables = ExpansibleVariables.instance();
  final _controller = ControllerUtils.instance();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color.fromARGB(255, 136, 136, 136)),
      ),
      height: 200,
      child: ListView(
        children: <Widget>[
          ...List.generate(_expansibleVariables.paymentMethods.length, (index) {
            return Padding(
              padding: const EdgeInsets.all(5),
              child: Material(
                child: ListTile(
                  onTap: () {
                    _expansibleVariables.groupPayment = _expansibleVariables.paymentMethods[index];
                    _controller.expensePaymentMethod!.text = _expansibleVariables.paymentMethods[index];
                    controller.collapse();
                    setStateCallback();
                    if (_expansibleVariables.paymentMethods[index] == "Crédito") {
                      setInstallments(context: context);
                    }
                  },
                  title: Center(
                    child: Text(
                      _expansibleVariables.paymentMethods[index],
                      style: TextStyle(
                        color: Color.fromARGB(255, 136, 136, 136),
                        fontWeight: FontWeight.bold
                      )
                    )
                  ),
                  tileColor: const Color.fromARGB(255, 210, 232, 236),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  )
                )
              )
            );
          })
        ]
      )
    );
  }

  void setInstallments({required BuildContext context}) {
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 234, 242, 252),
        title: Center(
          child: const Text(
            "Parcelas",
            style: TextStyle(
              color: Color.fromARGB(255, 136, 136, 136),
              fontWeight: FontWeight.bold
            )
          )
        ),
        content: Column(
          mainAxisSize: .min,
          spacing: 10,
          children: <Widget>[
            TextInput(
              controller: _controller.expenseInstallment!, 
              textHint: "Número de parcelas:",
              inputType: TextInputType.number
            ),
            const SizedBox(height: 10),
            Button(
              label: "Confirmar", 
              height: 60,
              function: () => Navigator.pop(context)
            )
          ]
        )
      )
    );
  }
}