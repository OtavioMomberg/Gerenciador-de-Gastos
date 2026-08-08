import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/presentation/themes/app_themes.dart';

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
      color: AppThemes.color1,
      shadowColor: AppThemes.color1,
      elevation: 5,
      borderRadius: AppThemes.borderRadius,
      child: SizedBox(
        height: 60,
        child: Center(
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            style: AppThemes.textStyle,
            cursorColor: AppThemes.color4,
            decoration: InputDecoration(
              hintText: "Pesquisar",
              hintStyle: AppThemes.textStyle,
              prefixIcon: const Icon(
                Icons.search,
                color: AppThemes.color4,
                fontWeight: FontWeight.bold,
              ),
              suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    onPressed: () => controller.clear(),
                    icon: const Icon(
                      Icons.close,
                      color: AppThemes.color4,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
              filled: true,
              fillColor: AppThemes.color1,
              border: OutlineInputBorder(
                borderRadius: AppThemes.borderRadius,
                borderSide: BorderSide.none
              )
            )
          )
        )
      )
    );
  }
}
