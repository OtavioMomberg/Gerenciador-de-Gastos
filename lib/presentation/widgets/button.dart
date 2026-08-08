import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/presentation/themes/app_themes.dart';

class Button extends StatelessWidget {
  final String label;
  final double height;
  final VoidCallback? function;
  final void Function({required Widget page})? navigation;
  final Widget? page;

  const Button({
    required this.label,
    required this.height,
    this.function,
    this.navigation,
    this.page,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: AppThemes.borderRadius,
      color: AppThemes.color1,
      elevation: 5,
      shadowColor: AppThemes.color1,
      child: InkWell(
        borderRadius: AppThemes.borderRadius,
        onTap: () {
          if (function != null) {
            function!();
            return;
          }
          if (navigation != null && page != null) {
            navigation!(page: page!);
            return;
          }
        },
        child: Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: AppThemes.borderRadius,
            border: Border.all(color: AppThemes.color1),
          ),
          child: Center(
            child: Text(
              label,
              style: AppThemes.textStyle
            )
          )
        )
      )
    );
  }
}