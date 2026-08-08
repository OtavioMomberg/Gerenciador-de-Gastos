import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/presentation/themes/app_themes.dart';

class GroupCard extends StatelessWidget {
  final String groupName;
  final double width;
  final Color color;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const GroupCard({
    required this.groupName,
    required this.width,
    required this.color,
    required this.onTap,
    required this.onLongPress,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: AppThemes.borderRadius,
      elevation: 5,
      shadowColor: color,
      child: InkWell(
        borderRadius: AppThemes.borderRadius,
        onTap: onTap,
        onLongPress: onLongPress,
        child: SizedBox(
          width: width,
          child: Center(
            child: Text(
              groupName,
              style: AppThemes.textStyle
            )
          )
        )
      )
    );
  }
}
