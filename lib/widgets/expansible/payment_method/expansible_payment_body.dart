import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/themes/app_themes.dart';
import 'package:gerenciador_gastos_v2/utils/controllers_utils.dart';
import 'package:gerenciador_gastos_v2/utils/expansible_variables.dart';
import 'package:gerenciador_gastos_v2/widgets/button.dart';
import 'package:gerenciador_gastos_v2/widgets/text_input.dart';

class ExpansiblePaymentBody extends StatelessWidget {
  final ExpansibleController controller;
  final VoidCallback setStateCallback;
  final List<String> paymentList;

  ExpansiblePaymentBody({
    required this.controller,
    required this.setStateCallback,
    required this.paymentList,
    super.key
  });

  final _expansibleVariables = ExpansibleVariables.instance();
  final _controller = ControllerUtils.instance();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: AppThemes.borderRadius,
        border: Border.all(color: AppThemes.color4),
      ),
      height: 200,
      child: ListView(
        children: <Widget>[
          ...List.generate(paymentList.length, (index) {
            return Padding(
              padding: const EdgeInsets.all(5),
              child: Material(
                child: ListTile(
                  onTap: () {
                    savePaymentMethod(index: index, context: context);
                  },
                  title: Center(
                    child: Text(
                      paymentList[index],
                      style: AppThemes.textStyle
                    )
                  ),
                  tileColor: AppThemes.color1,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppThemes.borderRadius
                  )
                )
              )
            );
          })
        ]
      )
    );
  }

  void savePaymentMethod({required int index, required BuildContext context}) {
    _expansibleVariables.groupPayment = paymentList[index];
    _controller.expensePaymentMethod!.text = paymentList[index];
    controller.collapse();
    setStateCallback();
    if (paymentList[index] == ExpansibleVariables.payment2 && paymentList.length < 4) {
      setInstallments(context: context);
    }
  }

  void setInstallments({required BuildContext context}) {
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppThemes.color3,
        title: Center(
          child: const Text(
            "Parcelas",
            style: AppThemes.textStyle
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