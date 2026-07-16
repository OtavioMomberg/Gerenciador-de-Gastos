import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/utils/expansible_variables_expense_page.dart';

class ExpansibleIdHeader extends StatelessWidget {
  final ExpansibleController controller;
  
  ExpansibleIdHeader({
    required this.controller,
    super.key
  });

  final expansibleVariables = ExpansibleVariablesExpensePage.instance();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color.fromARGB(255, 136, 136, 136)),
      ),
      child: Row(
        mainAxisAlignment: .spaceEvenly,
        spacing: 10,
        children: [
          Text(
            expansibleVariables.groupName,
            style: const TextStyle(
              color: Color.fromARGB(255, 136, 136, 136),
              fontWeight: FontWeight.bold
            )
          ),
          IconButton(
            onPressed: () {
              controller.isExpanded
                ? controller.collapse()
                : controller.expand();
            },
            icon: Icon(
              controller.isExpanded
                ? Icons.arrow_upward
                : Icons.arrow_downward,
              color: const Color.fromARGB(255, 136, 136, 136),
              fontWeight: FontWeight.bold
            )
          )
        ]
      )
    );
  }
}