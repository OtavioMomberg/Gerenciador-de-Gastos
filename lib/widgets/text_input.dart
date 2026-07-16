import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final TextEditingController controller;
  final String textHint;
  final TextInputType? inputType;

  const TextInput({
    required this.controller,
    required this.textHint,
    this.inputType = TextInputType.text,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      cursorColor: const Color.fromARGB(255, 136, 136, 136),
      style: const TextStyle(
        color: Color.fromARGB(255, 136, 136, 136),
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        hint: Text(
          textHint,
          style: const TextStyle(color: Color.fromARGB(255, 136, 136, 136))
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: const Color.fromARGB(255, 136, 136, 136)
          )
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: const Color.fromARGB(255, 136, 136, 136)
          )
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: const Color.fromARGB(255, 136, 136, 136)
          )
        )
      )
    );
  }
}
