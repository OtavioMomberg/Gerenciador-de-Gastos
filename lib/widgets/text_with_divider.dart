import 'package:flutter/material.dart';

class TextWithDivider extends StatelessWidget {
  final String content;
  const TextWithDivider({required this.content, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: <Widget>[
        Text(
          content,
          style: TextStyle(
            color: const Color.fromARGB(255, 136, 136, 136),
            fontWeight: FontWeight.bold
          )
        ),
        const Divider(color: Color.fromARGB(255, 136, 136, 136))
      ]
    );
  }
}
