import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/themes/app_themes.dart';

class TextInput extends StatelessWidget {
  final String textHint;
  final TextEditingController controller;
  final TextInputType? inputType;

  const TextInput({
    required this.textHint,
    required this.controller,
    this.inputType = TextInputType.text,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      cursorColor: AppThemes.color1,
      style: AppThemes.textStyle,
      decoration: InputDecoration(
        hint: Text(
          textHint,
          style: AppThemes.textStyle
        ),
        border: OutlineInputBorder(
          borderRadius: AppThemes.borderRadius,
          borderSide: BorderSide(
            color: AppThemes.color1
          )
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppThemes.borderRadius,
          borderSide: BorderSide(
            color: AppThemes.color1
          )
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppThemes.borderRadius,
          borderSide: BorderSide(
            color: AppThemes.color1
          )
        )
      )
    );
  }
}
