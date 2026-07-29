import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/models/group_read.dart';
import 'package:gerenciador_gastos_v2/pages/group_page.dart';
import 'package:gerenciador_gastos_v2/services/database_service.dart';
import 'package:gerenciador_gastos_v2/widgets/search_bar/field_view_widget.dart';
import 'package:gerenciador_gastos_v2/widgets/search_bar/options_view_widget.dart';

class SearchBarWidget extends StatelessWidget {
  final void Function({required Widget page, int? index}) navigation;

  SearchBarWidget({required this.navigation, super.key});

  final _db = DatabaseService.instance();

  @override
  Widget build(BuildContext context) {
    return Autocomplete<GroupRead>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return Iterable<GroupRead>.empty();
        }
        return _db.groupsWithoutFuture.where((group) {
          return group.name.toLowerCase().contains(
            textEditingValue.text.toLowerCase(),
          );
        });
      },

      displayStringForOption: (group) => group.name,

      onSelected: (GroupRead group) async {
        await _db.selectExpensesByGroup(groupID: group.id);

        navigation(page: GroupPage(groupID: group.id));
      },

      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return FieldViewWidget(
          controller: controller, 
          focusNode: focusNode, 
          onFieldSubmitted: onFieldSubmitted
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Padding(
          padding: const EdgeInsets.only(top: 5),
          child: OptionsViewWidget(onSelected: onSelected, options: options)
        );
      }
    );
  }
}
