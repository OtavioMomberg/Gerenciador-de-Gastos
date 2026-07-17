import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/utils/expansible_variables.dart';

class ExpansibleDateBody extends StatelessWidget {
  final ExpansibleController controller;
  final VoidCallback setStateCallback;

  ExpansibleDateBody({
    required this.controller,
    required this.setStateCallback,
    super.key,
  });

  final _expansibleVariables = ExpansibleVariables.instance();

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
              child: ListView.builder(
                itemCount: _expansibleVariables.days.length,
                itemBuilder: (context, index) {
                  return Material(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: ListTile(
                        onTap: () {
                          final day = _expansibleVariables.days[index] < 10
                              ? "0${_expansibleVariables.days[index]}/"
                              : "${_expansibleVariables.days[index]}/";
                          if (_expansibleVariables.groupDate ==
                              "Insira a data de vencimento") {
                            _expansibleVariables.groupDate = "          ";
                          }
                          _expansibleVariables.groupDate = _expansibleVariables
                              .groupDate
                              .replaceRange(0, 3, day);
                          setStateCallback();
                          if (_expansibleVariables.groupDate.length == 10 &&
                              !_expansibleVariables.groupDate.contains(" ")) {
                            controller.collapse();
                          }
                        },
                        tileColor: const Color.fromARGB(255, 210, 232, 236),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        title: Center(
                          child: Text(
                            _expansibleVariables.days[index] < 10
                                ? "0${_expansibleVariables.days[index]}"
                                : _expansibleVariables.days[index].toString(),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _expansibleVariables.months.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Material(
                      child: ListTile(
                        onTap: () {
                          final month = _expansibleVariables.months[index] < 10
                              ? "0${_expansibleVariables.months[index]}/"
                              : "${_expansibleVariables.months[index]}/";
                          if (_expansibleVariables.groupDate ==
                              "Insira a data de vencimento") {
                            _expansibleVariables.groupDate = "          ";
                          }
                          _expansibleVariables.groupDate = _expansibleVariables
                              .groupDate
                              .replaceRange(3, 6, month);
                          setStateCallback();
                          if (_expansibleVariables.groupDate.length == 10 &&
                              !_expansibleVariables.groupDate.contains(" ")) {
                            controller.collapse();
                          }
                        },
                        tileColor: const Color.fromARGB(255, 210, 232, 236),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        title: Center(
                          child: Text(
                            _expansibleVariables.months[index] < 10
                                ? "0${_expansibleVariables.months[index]}"
                                : _expansibleVariables.months[index].toString(),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _expansibleVariables.years.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Material(
                      child: ListTile(
                        onTap: () {
                          final year = _expansibleVariables.years[index]
                              .toString();
                          if (_expansibleVariables.groupDate ==
                              "Insira a data de vencimento") {
                            _expansibleVariables.groupDate = "          ";
                          }
                          _expansibleVariables.groupDate = _expansibleVariables
                              .groupDate
                              .replaceRange(6, 10, year);
                          setStateCallback();
                          if (_expansibleVariables.groupDate.length == 10 &&
                              !_expansibleVariables.groupDate.contains(" ")) {
                            controller.collapse();
                          }
                        },
                        tileColor: const Color.fromARGB(255, 210, 232, 236),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        title: Center(
                          child: Text(
                            _expansibleVariables.years[index].toString(),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
