import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/themes/app_themes.dart';
import 'package:gerenciador_gastos_v2/utils/color_conversion.dart';

class ExpansibleHeader extends StatelessWidget {
  final ExpansibleController controller;
  final VoidCallback setStateCallback;

  ExpansibleHeader({
    required this.controller, 
    required this.setStateCallback,
    super.key
  });

  final _color = ColorConversion.instance();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppThemes.borderRadius,
        border: Border.all(color: AppThemes.color4),
      ),
      child: Row(
        mainAxisAlignment: .center,
        spacing: 10,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: AppThemes.borderRadius,
              color: _color.cor
            ),
            margin: EdgeInsets.all(5),
            height: 60,
            width: size.width * 0.5,
            child: Center(
              child: Text(
                _color.cor == AppThemes.color3 ? "Selecione uma cor" : "",
                style: const TextStyle(color: AppThemes.color4)
              )
            )
          ),
          IconButton(
            onPressed: () {
              controller.isExpanded
                ? controller.collapse()
                : controller.expand();
              setStateCallback();
            },
            icon: Icon(
              controller.isExpanded
                ? Icons.arrow_upward
                : Icons.arrow_downward,
              color: AppThemes.color4,
              fontWeight: FontWeight.bold
            )
          )
        ]
      )
    );
  }
}
