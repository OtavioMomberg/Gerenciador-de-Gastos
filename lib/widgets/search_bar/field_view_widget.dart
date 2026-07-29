import 'package:flutter/material.dart';

class FieldViewWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onFieldSubmitted;

  const FieldViewWidget({
    required this.controller,
    required this.focusNode,
    required this.onFieldSubmitted,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromARGB(255, 210, 232, 236),
      shadowColor: const Color.fromARGB(255, 210, 232, 236),
      elevation: 5,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 60,
        child: Center(
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            style: const TextStyle(
              color: Color.fromARGB(255, 136, 136, 136),
              fontWeight: FontWeight.bold,
            ),
            cursorColor: const Color.fromARGB(255, 136, 136, 136),
            decoration: InputDecoration(
              hintText: "Pesquisar",
              hintStyle: const TextStyle(
                color: Color.fromARGB(255, 136, 136, 136),
                fontWeight: FontWeight.bold,
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: Color.fromARGB(255, 136, 136, 136),
                fontWeight: FontWeight.bold,
              ),
              suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    onPressed: () => controller.clear(),
                    icon: const Icon(
                      Icons.close,
                      color: Color.fromARGB(255, 136, 136, 136),
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
              filled: true,
              fillColor: const Color.fromARGB(255, 210, 232, 236),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none
              )
            )
          )
        )
      )
    );
  }
}
