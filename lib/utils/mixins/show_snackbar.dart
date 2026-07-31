import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/themes/app_themes.dart';

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
        backgroundColor: txtColor.withValues(alpha: 0.9),
        shape: StadiumBorder(
          side: BorderSide(color: txtColor.withValues(alpha: 0.7))
        ),
        duration: const Duration(seconds: 2)
      )
    );
  }
}