import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/utils/controllers_utils.dart';
import 'package:gerenciador_gastos_v2/utils/expansible_variables.dart';

class DateListView extends StatelessWidget {
  final ExpansibleController controller;
  final VoidCallback setStateCallback;
  final ListOption option;
  final Map<String, int> range;

  DateListView({
    required this.controller,
    required this.setStateCallback,
    required this.option,
    required this.range,
    super.key
  });

  final _expansibleVariables = ExpansibleVariables.instance();
  final _controller = ControllerUtils.instance();
  late final String value;

  @override
  Widget build(BuildContext context) {
    final list = _expansibleVariables.getList(option: option);

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return Material(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: ListTile(
              onTap: () {          
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
              },
              tileColor: const Color.fromARGB(255, 210, 232, 236),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: Center(
                child: Text(
                  list[index] < 10
                    ? "0${list[index]}"
                    : list[index].toString(),
                  style: TextStyle(
                    color: Color.fromARGB(255, 136, 136, 136),
                    fontWeight: FontWeight.bold
                  )
                )
              )
            )
          )
        );
      }
    );
  }
}
