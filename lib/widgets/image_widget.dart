import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final String imagePath;

  const ImageWidget({required this.imagePath, super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        imagePath,
        filterQuality: FilterQuality.high,
        fit: BoxFit.contain,
        colorBlendMode: BlendMode.darken
      )
    );
  }
}