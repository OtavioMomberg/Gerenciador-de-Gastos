import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/utils/color_conversion.dart';

class ExpansibleHeader extends StatelessWidget {
  final ExpansibleController controller;

  ExpansibleHeader({required this.controller, super.key});

  final _color = ColorConversion.instance();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color.fromARGB(255, 136, 136, 136)),
      ),
      child: Row(
        mainAxisAlignment: .center,
        spacing: 10,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: _color.cor
            ),
            margin: EdgeInsets.all(5),
            height: 60,
            width: size.width * 0.5,
            child: Center(
              child: Text(
                _color.cor == Color.fromARGB(255, 234, 242, 252) ? "Selecione uma cor" : "",
                style: const TextStyle(
                  color: Color.fromARGB(255, 136, 136, 136),
                  fontWeight: FontWeight.bold
                )

              )
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
