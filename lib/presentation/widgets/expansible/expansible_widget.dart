import 'package:flutter/material.dart';

class ExpansibleWidget extends StatelessWidget {
  final ExpansibleController controller;
  final Widget header;
  final Widget body;

  const ExpansibleWidget({
    required this.controller, 
    required this.header,
    required this.body,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Expansible(
      headerBuilder: (context, _) => header,
      bodyBuilder: (context, _) => body,
      controller: controller
    );
  }
}
