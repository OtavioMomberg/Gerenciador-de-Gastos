import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/presentation/themes/app_themes.dart';
import 'package:gerenciador_gastos_v2/presentation/widgets/text_with_divider.dart';

class GeneralInfoCard extends StatelessWidget {
  final List<String> infoList;
  
  const GeneralInfoCard({
    required this.infoList,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppThemes.color1,
      borderRadius: AppThemes.borderRadius,
      shadowColor: AppThemes.color1,
      elevation: 10,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(borderRadius: AppThemes.borderRadius),
        child: Column(
          children: <Widget>[
            ...List.generate(infoList.length, (index) {
              return TextWithDivider(content: infoList[index]);
            })
          ]
        )
      )
    );
  }
}
