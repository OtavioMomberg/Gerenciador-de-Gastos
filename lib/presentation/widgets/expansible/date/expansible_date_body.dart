import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/presentation/themes/app_themes.dart';
import 'package:gerenciador_gastos_v2/core/utils/expansible_variables.dart';
import 'package:gerenciador_gastos_v2/presentation/widgets/expansible/date/date_list_view.dart';

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
        borderRadius: AppThemes.borderRadius,
        border: Border.all(color: AppThemes.color4),
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
                range: {"start": 0, "end": 3}
              )
            ),
            Expanded(
              child: DateListView(
                controller: controller, 
                setStateCallback: setStateCallback, 
                option: ListOption.months, 
                range: {"start": 3, "end": 6}
              )
            ),
            Expanded(
              child: DateListView(
                controller: controller, 
                setStateCallback: setStateCallback, 
                option: ListOption.years, 
                range: {"start": 6, "end": 10}
              )
            )
          ]
        )
      )
    );
  }
}