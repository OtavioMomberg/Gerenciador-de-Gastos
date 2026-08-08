import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/presentation/themes/app_themes.dart';

class TextButtonColored extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback function;

  const TextButtonColored({
    required this.label,
    required this.color,
    required this.icon,
    required this.function,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      borderRadius: AppThemes.borderRadius,
      color: AppThemes.color3,
      shadowColor: AppThemes.color3,
      child: InkWell(
        borderRadius: AppThemes.borderRadius,
        splashColor: AppThemes.color1,
        highlightColor: AppThemes.color1,
        onTap: function,
        child: Container(
          height: 60,
          decoration: BoxDecoration(borderRadius: AppThemes.borderRadius),
          child: Row(
            mainAxisAlignment: .center,
            spacing: 10,
            children: <Widget>[
              Text(
                label,
                style: AppThemes.textStyle
              ),
              Icon(icon, color: color)
            ]
          )
        )
      )
    );
  }
}
