import 'package:flutter/material.dart';

class TextButtonColored extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback function;

  const TextButtonColored({
    required this.icon,
    required this.color,
    required this.label,
    required this.function,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: function,
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: color),
          ),
        ),
      ),
      label: Text(
        label,
        style: TextStyle(color: color),
      ),
      icon: Icon(icon, color: color)
    );
  }
}
