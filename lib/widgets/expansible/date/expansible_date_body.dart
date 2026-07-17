import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/utils/expansible_variables.dart';
import 'package:gerenciador_gastos_v2/widgets/expansible/date/date_list_view.dart';

class ExpansibleDateBody extends StatelessWidget {
  final ExpansibleController controller;
  final VoidCallback setStateCallback;

  const ExpansibleDateBody({
    required this.controller,
    required this.setStateCallback,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color.fromARGB(255, 136, 136, 136)),
      ),
      height: 200,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          spacing: 5,
          children: <Widget>[
            Expanded(
              child: DateListView(
                controller: controller, 
                setStateCallback: setStateCallback, 
                option: ListOption.days, 
                range: {
                  "start": 0,
                  "end": 3
                }
              )
            ),
            Expanded(
              child: DateListView(
                controller: controller, 
                setStateCallback: setStateCallback, 
                option: ListOption.months, 
                range: {
                  "start": 3,
                  "end": 6
                }
              )
            ),
            Expanded(
              child: DateListView(
                controller: controller, 
                setStateCallback: setStateCallback, 
                option: ListOption.years, 
                range: {
                  "start": 6,
                  "end": 10
                }
              )
            )
          ]
        )
      )
    );
  }
}