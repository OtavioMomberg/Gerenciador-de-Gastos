import 'package:flutter/material.dart';

class GroupCard extends StatelessWidget {
  final Color color;
  final String groupName;
  final double width;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const GroupCard({
    required this.color,
    required this.groupName,
    required this.width,
    required this.onTap,
    required this.onLongPress,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        onLongPress: onLongPress,
        child: SizedBox(
          width: width,
          child: Center(
            child: Text(
              groupName,
              style: const TextStyle(
                color: Color.fromARGB(255, 136, 136, 136),
                fontWeight: FontWeight.bold
              )
            )
          )
        )
      )
    );
  }
}
