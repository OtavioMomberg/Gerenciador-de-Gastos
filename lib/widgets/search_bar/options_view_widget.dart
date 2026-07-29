import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/models/group_read.dart';

class OptionsViewWidget extends StatelessWidget {
  final void Function(GroupRead group) onSelected;
  final Iterable<GroupRead> options;

  const OptionsViewWidget({
    required this.onSelected,
    required this.options,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromARGB(255, 210, 232, 236),
      shadowColor: const Color.fromARGB(255, 210, 232, 236),
      elevation: 5,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: options.length,
          itemBuilder: (context, index) {
            final group = options.elementAt(index);
            return InkWell(
              onTap: () => onSelected(group),
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    "\n${group.name}\n",
                    style: TextStyle(
                      color: Color.fromARGB(255, 136, 136, 136),
                      fontWeight: FontWeight.bold,
                    ),
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
