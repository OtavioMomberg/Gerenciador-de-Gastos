import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/utils/expansible_variables.dart';

class ExpansibleDateHeader extends StatelessWidget {
  final ExpansibleController controller;
  final VoidCallback setStateCallback;

  ExpansibleDateHeader({
    required this.controller, 
    required this.setStateCallback,
    super.key
  });

  final expansibleVariables = ExpansibleVariables.instance();

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
            expansibleVariables.groupDate,
            style: const TextStyle(
              color: Color.fromARGB(255, 136, 136, 136),
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: () {
              controller.isExpanded
                ? controller.collapse()
                : controller.expand();
              setStateCallback();
            },
            icon: Icon(
              controller.isExpanded ? Icons.arrow_upward : Icons.arrow_downward,
              color: const Color.fromARGB(255, 136, 136, 136),
              fontWeight: FontWeight.bold
            )
          )
        ]
      )
    );
  }
}