import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/controllers/database_controller.dart';
import 'package:gerenciador_gastos_v2/presentation/themes/app_themes.dart';
import 'package:gerenciador_gastos_v2/core/utils/controllers_utils.dart';
import 'package:gerenciador_gastos_v2/core/utils/expansible_variables.dart';

class ExpansibleIdBody extends StatelessWidget {
  final ExpansibleController controller;
  final DatabaseController db;
  final VoidCallback setStateCallback;

  ExpansibleIdBody({
    required this.controller,
    required this.db,
    required this.setStateCallback,
    super.key,
  });

  final _controller = ControllerUtils.instance();
  final _expansibleVariables = ExpansibleVariables.instance();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: AppThemes.borderRadius,
        border: Border.all(color: AppThemes.color4),
      ),
      height:
          (db.groupsWithoutFuture.length * 60) +
          (db.groupsWithoutFuture.length * 10),
      child: ListView.builder(
        itemCount: db.groupsWithoutFuture.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(5),
            child: Material(
              borderRadius: AppThemes.borderRadius,
              color: AppThemes.color1,
              child: ListTile(
                onTap: () => saveGroupID(index: index),
                title: Center(
                  child: Text(
                    db.groupsWithoutFuture[index].name,
                    style: AppThemes.textStyle,
                  ),
                ),
                tileColor: AppThemes.color1,
                shape: RoundedRectangleBorder(
                  borderRadius: AppThemes.borderRadius,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void saveGroupID({required int index}) {
    _expansibleVariables.groupName = db.groupsWithoutFuture[index].name;
    _controller.expenseGroupID!.text = db.groupsWithoutFuture[index].id
        .toString();
    setStateCallback();
    controller.collapse();
  }
}
