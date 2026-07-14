import 'package:flutter/material.dart';

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
          await Future.delayed(Duration(seconds: 3));
          closeDialog();
        });
        return AlertDialog(
          title: Center(child: Text(title)),
          content: SizedBox.square(
            dimension: 250,
            child: Center(
              child: Text(
                content,
                style: const TextStyle(fontWeight: FontWeight.bold)
              )
            )
          )
        );
      }
    );
  }
}