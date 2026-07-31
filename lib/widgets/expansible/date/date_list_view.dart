import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/themes/app_themes.dart';
import 'package:gerenciador_gastos_v2/utils/controllers_utils.dart';
import 'package:gerenciador_gastos_v2/utils/expansible_variables.dart';

class DateListView extends StatelessWidget {
  final ExpansibleController controller;
  final ListOption option;
  final Map<String, int> range;
  final VoidCallback setStateCallback;

  DateListView({
    required this.controller,
    required this.option,
    required this.range,
    required this.setStateCallback,
    super.key
  });

  final _expansibleVariables = ExpansibleVariables.instance();
  final _controller = ControllerUtils.instance();
  late final String value;

  @override
  Widget build(BuildContext context) {
    final List<int> list = _expansibleVariables.getList(option: option);

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return Material(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: ListTile(
              onTap: () => validadeDate(index: index, list: list),
              tileColor: AppThemes.color1,
              shape: RoundedRectangleBorder(
                borderRadius: AppThemes.borderRadius,
              ),
              title: Center(
                child: Text(
                  list[index] < 10
                    ? "0${list[index]}"
                    : list[index].toString(),
                  style: AppThemes.textStyle
                )
              )
            )
          )
        );
      }
    );
  }

  void validadeDate({required int index, required List<int> list}) {
    if (option == ListOption.years) {
      value = list[index].toString();
    } else {
      value = list[index] < 10
        ? "0${list[index]}/"
        : "${list[index]}/";
    }        

    if (_expansibleVariables.groupDate == ExpansibleVariables.date) {
      _expansibleVariables.groupDate = _expansibleVariables.emptyStr;
    }
    _expansibleVariables.groupDate = _expansibleVariables.groupDate.replaceRange(range["start"]!, range["end"]!, value);

    setStateCallback();

    if (_expansibleVariables.checkDateStr()) {
      controller.collapse();
      _controller.expenseDate!.text = _expansibleVariables.groupDate;
    }
  }
}
