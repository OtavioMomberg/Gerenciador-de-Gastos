import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerenciador_gastos_v2/core/di/app_dependencies.dart';
import 'package:gerenciador_gastos_v2/presentation/pages/home_page.dart';
import 'package:gerenciador_gastos_v2/presentation/themes/app_themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciador de Gastos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          selectionHandleColor: AppThemes.color4,
        ),
        colorScheme: .fromSeed(seedColor: AppThemes.color1),
      ),
      home: HomePage(db: AppDependencies.db)
    );
  }
}