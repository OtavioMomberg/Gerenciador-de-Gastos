import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/themes/app_themes.dart';

class ImageWidget extends StatelessWidget {
  final String imagePath;

  const ImageWidget({
    required this.imagePath, 
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppThemes.borderRadius,
      child: Image.asset(
        imagePath,
        filterQuality: FilterQuality.high,
        fit: BoxFit.contain,
        colorBlendMode: BlendMode.darken
      )
    );
  }
}