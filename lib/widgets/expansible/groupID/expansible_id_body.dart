import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/services/database_service.dart';
import 'package:gerenciador_gastos_v2/themes/app_themes.dart';
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
  final _expansibleVariables = ExpansibleVariables.instance();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: AppThemes.borderRadius,
        border: Border.all(color: AppThemes.color4),
      ),
      height: 250,
      child: ListView.builder(
        itemCount: _db.groupsWithoutFuture.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(5),
            child: Material(
              child: ListTile(
                onTap: () => saveGroupID(index: index),
                title: Center(
                  child: Text(
                    _db.groupsWithoutFuture[index].name,
                    style: AppThemes.textStyle
                  )
                ),
                tileColor: AppThemes.color1,
                shape: RoundedRectangleBorder(
                  borderRadius: AppThemes.borderRadius
                )
              )
            )
          );
        }
      )
    );
  }
  
  void saveGroupID({required int index}) {
    _expansibleVariables.groupName = _db.groupsWithoutFuture[index].name;
    _controller.expenseGroupID!.text = _db.groupsWithoutFuture[index].id.toString();
    setStateCallback();
    controller.collapse();
  }
}
