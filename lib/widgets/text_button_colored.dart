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
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(10),
      color: const Color.fromARGB(255, 234, 242, 252),
      shadowColor: const Color.fromARGB(255, 234, 242, 252),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        splashColor: const Color.fromARGB(255, 210, 232, 236),
        highlightColor: const Color.fromARGB(255, 210, 232, 236),
        onTap: function,
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10)
          ),
          child: Row(
            mainAxisAlignment: .center,
            spacing: 10,
            children: <Widget>[
              Text(
                label,
                style: TextStyle(color: color)
              ),
              Icon(icon, color: color)
            ]
          )
        )
      ),
    );
  }
}
