import 'package:flutter/material.dart';

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
            style: const TextStyle(
              color: Color.fromARGB(255, 136, 136, 136),
              fontWeight: FontWeight.bold
            )
          )
        ),
        backgroundColor: txtColor,
        shape: StadiumBorder(
          side: BorderSide(color: txtColor.withValues(alpha: 0.7)),
        ),
        duration: const Duration(seconds: 2)
      )
    );
  }
}