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
          await Future.delayed(Duration(seconds: 2));
          closeDialog();
        });
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 234, 242, 252),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)
          ),
          title: Center(
            child: Text(
              title,
              style: const TextStyle(
                color: Color.fromARGB(255, 136, 136, 136),
                fontWeight: FontWeight.bold
              )
            )
          ),
          content: Column(
            mainAxisSize: .min,
            children: <Widget>[
              const SizedBox(height: 20),
              Text(
                content,
                style: const TextStyle(
                  color: Color.fromARGB(255, 136, 136, 136),
                  fontWeight: FontWeight.bold
                )
              ),
              const SizedBox(height: 20)
            ]
          )
        );
      }
    );
  }
}