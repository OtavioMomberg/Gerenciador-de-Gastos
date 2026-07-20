import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/routes/app_routes.dart';

mixin ChangePage {
  void goNextPage({
    required BuildContext context,
    required int index,
    required Widget page,
    void Function({bool? response})? thenFunction,
  }) {
    Navigator.push(
      context, 
      AppRoutes.dynamicRoute(page: page)
    ).then((response) async {
      if (thenFunction != null) { 
        thenFunction(response: response); 
      }
    });
  }
}
