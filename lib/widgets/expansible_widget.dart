import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/widgets/expansible_body.dart';
import 'package:gerenciador_gastos_v2/widgets/expansible_header.dart';

class ExpansibleWidget extends StatelessWidget {
  final ExpansibleController controller;
  final VoidCallback setStateCallback;

  const ExpansibleWidget({
    required this.controller, 
    required this.setStateCallback,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Expansible(
      headerBuilder: (context, _) => ExpansibleHeader(controller: controller),
      bodyBuilder: (context, _) => ExpansibleBody(controller: controller, setStateCallback: setStateCallback), 
      controller: controller
    );
  }
}
