import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/widgets/text_with_divider.dart';

class GeneralInfoCard extends StatelessWidget {
  final List<String> infoList;
  
  const GeneralInfoCard({
    required this.infoList,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromARGB(255, 210, 232, 236),
      borderRadius: BorderRadius.circular(10),
      shadowColor: const Color.fromARGB(255, 210, 232, 236),
      elevation: 10,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            ...List.generate(infoList.length, (index) {
              return TextWithDivider(content: infoList[index]);
            })
          ]
        )
      )
    );
  }
}
