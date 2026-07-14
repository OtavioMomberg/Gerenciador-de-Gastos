import 'package:flutter/material.dart';

mixin ConfirmationDialog {
  Future<bool> confirmDialog({
    required BuildContext context, 
    required String title, 
    required String content
  }) async {
    bool? response;
    response = await showDialog<bool?>(
      context: context, 
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Center(child: Text(title)),
          content: SizedBox.square(
            dimension: 250,
            child: Center(
              child: Text(
                content,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold)
              )
            )
          ),
          actionsAlignment: .center,
          actionsPadding: const EdgeInsets.all(10),
          actions: [
            ElevatedButton(
              onPressed: () {
                response = true;
                Navigator.pop<bool>(context, response);
              }, 
              child: const Text("Sim")
            ),
            
            ElevatedButton(
              onPressed: () {
                response = false;
                Navigator.pop<bool>(context, response);
              },  
              child: const Text("Não")
            )
          ]
        );
      }
    );
    return response ?? false;
  }
}