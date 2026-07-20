import 'package:flutter/material.dart';

class AppRoutes {
  static Route<dynamic> dynamicRoute({required Widget page}) {
    return PageRouteBuilder(
      pageBuilder: (_, _, _) => page,
      transitionsBuilder: (_, animation, _, child) {
        final begin = Offset(0.0, 1.0);
        final end = Offset.zero;
        final curve = Curves.easeInOut;

        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child
        );
      }
    );
  }
}