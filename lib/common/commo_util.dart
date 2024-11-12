import 'package:flutter/material.dart';

extension HexColor on Color {
  static Color from(String hexString) {
    hexString = hexString.replaceAll("#", "");
    if (hexString.length == 6) {
      hexString = "FF$hexString";
    }
    return Color(int.parse(hexString, radix: 16));
  }
}
