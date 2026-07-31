import 'package:flutter/material.dart';
import 'package:gerenciador_gastos_v2/themes/app_themes.dart';

class ColorConversion {
  static final Map<String, Color> colorsMap = {
    listColors[0] : AppThemes.color1,
    listColors[1] : AppThemes.color5,
    listColors[2] : AppThemes.color2,
  };

  static final List<String> listColors = [
    "Colors.lightBlue", 
    "Colors.whiteGray", 
    "Colors.lightRed"
  ];
  
  late Color cor;

  static final _instance = ColorConversion._();
  ColorConversion._();
  factory ColorConversion.instance() => _instance;
}