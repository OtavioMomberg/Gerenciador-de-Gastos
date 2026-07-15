import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/widgets/button.dart';

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
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color.fromARGB(255, 136, 136, 136),
                  fontWeight: FontWeight.bold
                )
              ),
              const SizedBox(height: 20)         
            ]
          ),
          actionsAlignment: .center,
          actions: [
              FractionallySizedBox(
              widthFactor: 0.4,
              child: Button(
                label: "Sim", 
                height: 50,
                function: () {
                  response = true;
                  Navigator.pop<bool>(context, response);
                }
              )
            ),
            const SizedBox(width: 10),  
            FractionallySizedBox(
              widthFactor: 0.4,
              child: Button(
                label: "Não", 
                height: 50,
                function: () {
                  response = false;
                  Navigator.pop<bool>(context, response);
                }
              )
            )
          ]
        );
      }
    );
    return response ?? false;
  }
}