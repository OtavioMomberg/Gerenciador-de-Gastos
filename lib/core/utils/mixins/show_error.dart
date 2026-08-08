import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/presentation/themes/app_themes.dart';

mixin ErrorDialog {
  void showError({
    required BuildContext context, 
    required String title, 
    required String content, 
    required VoidCallback closeDialog
  }) {
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (context) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await Future.delayed(Duration(seconds: 2));
          closeDialog();
        });
        return AlertDialog(
          backgroundColor: AppThemes.color3,
          shape: RoundedRectangleBorder(
            borderRadius: AppThemes.borderRadius
          ),
          title: Center(
            child: Text(
              title,
              style: AppThemes.textStyle
            )
          ),
          content: Column(
            mainAxisSize: .min,
            children: <Widget>[
              const SizedBox(height: 20),
              Text(
                content,
                style: AppThemes.textStyle
              ),
              const SizedBox(height: 20)
            ]
          )
        );
      }
    );
  }
}