import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/themes/app_themes.dart';

class TextWithDivider extends StatelessWidget {
  final String content;

  const TextWithDivider({
    required this.content, 
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: <Widget>[
        Text(
          content,
          style: AppThemes.textStyle
        ),
        const Divider(color: AppThemes.color4)
      ]
    );
  }
}
