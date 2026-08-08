import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/models/group_read.dart';
import 'package:gerenciador_gastos_v2/presentation/themes/app_themes.dart';

class OptionsViewWidget extends StatelessWidget {
  final Iterable<GroupRead> options;
  final void Function(GroupRead group) onSelected;
  
  const OptionsViewWidget({
    required this.options,
    required this.onSelected,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppThemes.color1,
      shadowColor: AppThemes.color1,
      elevation: 5,
      borderRadius: AppThemes.borderRadius,
      child: SizedBox(
        child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: options.length,
          itemBuilder: (context, index) {
            final group = options.elementAt(index);
            return InkWell(
              onTap: () => onSelected(group),
              borderRadius: AppThemes.borderRadius,
              child: SizedBox(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    "\n${group.name}\n",
                    style: AppThemes.textStyle,
                    textAlign: TextAlign.left
                  )
                )
              )
            );
          }
        )
      )
    );
  }
}
