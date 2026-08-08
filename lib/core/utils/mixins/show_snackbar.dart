import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/presentation/themes/app_themes.dart';

mixin ShowColoredSnackBar {
  Future<void> showColoredSnackBar({
    required BuildContext context, 
    required String msm, 
    required Color txtColor
  }) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: const EdgeInsets.all(10),
        content: Center(
          child: Text(
            msm, 
            style: AppThemes.textStyle
          )
        ),
        behavior: .floating,
        backgroundColor: txtColor.withValues(alpha: 0.5),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppThemes.borderRadius,
          side: BorderSide(color: txtColor)
        ),
        duration: const Duration(seconds: 2)
      )
    );
  }
}