import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/presentation/themes/app_themes.dart';

class TextWithDivider extends StatelessWidget {
  final String content;
  final bool useDivider;

  const TextWithDivider({
    required this.content,
    this.useDivider = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (!useDivider) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Text(content, style: AppThemes.textStyle),
      );
    }

    return Column(
      crossAxisAlignment: .start,
      children: <Widget>[
        Text(content, style: AppThemes.textStyle),
        const Divider(color: AppThemes.color4),
      ],
    );
  }
}
