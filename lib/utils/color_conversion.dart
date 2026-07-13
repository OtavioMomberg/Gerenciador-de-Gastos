import 'package:flutter/material.dart';

class ColorConversion {
  static final Map<String, Color> colorsMap = {
    listColors[0] : Colors.yellow,
    listColors[1] : Colors.lightBlueAccent,
    listColors[2] : Colors.redAccent,
  };

  static final List<String> listColors = [
    "Colors.yellow", 
    "Colors.lightBlueAccent", 
    "Colors.redAccent"
  ];
}