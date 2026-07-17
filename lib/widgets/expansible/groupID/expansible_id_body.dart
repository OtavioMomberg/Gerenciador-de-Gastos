import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/services/database_service.dart';
import 'package:gerenciador_gastos_v2/utils/controllers_utils.dart';
import 'package:gerenciador_gastos_v2/utils/expansible_variables.dart';

class ExpansibleIdBody extends StatelessWidget {
  final ExpansibleController controller;
  final VoidCallback setStateCallback;

  ExpansibleIdBody({
    required this.controller,
    required this.setStateCallback,
    super.key,
  });

  final _controller = ControllerUtils.instance();
  final _db = DatabaseService.instance();
  final expansibleVariables = ExpansibleVariables.instance();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color.fromARGB(255, 136, 136, 136)),
      ),
      height: 250,
      child: ListView.builder(
        itemCount: _db.groupsWithoutFuture.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: InkWell(
              onTap: () {
                expansibleVariables.groupName = _db.groupsWithoutFuture[index].name;
                _controller.expenseGroupID!.text = _db.groupsWithoutFuture[index].id.toString();
                setStateCallback();
                controller.collapse();
              },
              child: Center(
                child: Text(
                  "${_db.groupsWithoutFuture[index].name}\n",
                  style: TextStyle(
                    color: Color.fromARGB(255, 136, 136, 136),
                    fontWeight: FontWeight.bold
                  )
                )
              )
            )
          );
        }
      )
    );
  }
}
