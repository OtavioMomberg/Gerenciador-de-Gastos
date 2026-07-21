import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String label;
  final double height;
  final VoidCallback? function;
  final void Function({required Widget page})? navigation;
  final Widget? page;

  const Button({
    required this.label,
    required this.height,
    this.function,
    this.navigation,
    this.page,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: const Color.fromARGB(255, 210, 232, 236),
      elevation: 5,
      shadowColor: const Color.fromARGB(255, 196, 222, 226),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (function != null) {
            function!();
            return;
          }
          if (navigation != null && page != null) {
            navigation!(page: page!);
            return;
          }
        },
        child: Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color.fromARGB(255, 210, 232, 236)),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Color.fromARGB(255, 136, 136, 136),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
