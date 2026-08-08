import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/presentation/themes/app_themes.dart';
import 'package:gerenciador_gastos_v2/core/utils/expansible_variables.dart';

class ExpansiblePaymentHeader extends StatelessWidget {
  final ExpansibleController controller;
  final VoidCallback setStateCallback;

  ExpansiblePaymentHeader({
    required this.controller,
    required this.setStateCallback,
    super.key
  });

  final expansibleVariables = ExpansibleVariables.instance();

  @override
  Widget build(BuildContext context) {    
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppThemes.borderRadius,
        border: Border.all(color: AppThemes.color4),
      ),
      child: Row(
        mainAxisAlignment: .spaceEvenly,
        spacing: 10,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                expansibleVariables.groupPayment,
                style: TextStyle(
                  color: AppThemes.color4,
                  fontWeight: expansibleVariables.groupPayment != ExpansibleVariables.payment
                    ? FontWeight.bold : FontWeight.normal
                )
              )
            )
          ),
          Expanded(
            child: IconButton(
              onPressed: () {
                controller.isExpanded
                  ? controller.collapse()
                  : controller.expand();
                setStateCallback();
              },
              icon: Icon(
                controller.isExpanded ? Icons.arrow_upward : Icons.arrow_downward,
                color: AppThemes.color4,
                fontWeight: FontWeight.bold
              )
            )
          )
        ]
      )
    );
  }
}