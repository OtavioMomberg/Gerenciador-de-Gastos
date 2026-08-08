import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/core/di/app_dependencies.dart';
import 'package:gerenciador_gastos_v2/models/group_read.dart';
import 'package:gerenciador_gastos_v2/presentation/pages/group_page.dart';
import 'package:gerenciador_gastos_v2/controllers/database_controller.dart';
import 'package:gerenciador_gastos_v2/presentation/widgets/search_bar/field_view_widget.dart';
import 'package:gerenciador_gastos_v2/presentation/widgets/search_bar/options_view_widget.dart';

class SearchBarWidget extends StatelessWidget {
  final DatabaseController db;
  final void Function({required Widget page, int? index}) navigation;

  const SearchBarWidget({
    required this.db,
    required this.navigation, 
    super.key
  });


  @override
  Widget build(BuildContext context) {
    return Autocomplete<GroupRead>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return Iterable<GroupRead>.empty();
        }
        return db.groupsWithoutFuture.where((group) {
          return group.name.toLowerCase().contains(
            textEditingValue.text.toLowerCase(),
          );
        });
      },

      displayStringForOption: (group) => group.name,

      onSelected: (GroupRead group) async {
        await db.selectExpensesByGroup(groupID: group.id);

        navigation(
          page: GroupPage(
            groupID: group.id,
            db: AppDependencies.db,
            groupService: AppDependencies.groupService,
          )
        );
      },

      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return FieldViewWidget(
          controller: controller,
          focusNode: focusNode,
          onFieldSubmitted: onFieldSubmitted,
        );
      },

      optionsViewBuilder: (context, onSelected, options) {
        return Padding(
          padding: const EdgeInsets.only(top: 5),
          child: OptionsViewWidget(onSelected: onSelected, options: options),
        );
      },
    );
  }
}
