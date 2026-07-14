import 'package:flutter/material.dart';

class ColorConversion {
  static final Map<String, Color> colorsMap = {
    listColors[0] : const Color.fromARGB(255, 210, 232, 236),
    listColors[1] : const Color.fromARGB(255, 236, 236, 237),
    listColors[2] : const Color.fromARGB(255, 255, 183, 183),
  };

  static final List<String> listColors = [
    "Colors.lightBlue", 
    "Colors.whiteGray", 
    "Colors.lightRed"
  ];
}