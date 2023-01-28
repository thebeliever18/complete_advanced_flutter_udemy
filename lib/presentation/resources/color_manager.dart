import 'package:flutter/material.dart';

class ColorManager {
  static Color primary = "#ED9728".fromHex;
  static Color darkGrey = "#525252".fromHex;
  static Color grey = "#737477".fromHex;
  static Color lightGrey = "#9E9E9E".fromHex;
  static Color primaryOpacity70 = "#B3ED9728".fromHex;


  //new colors 
  static Color darkPrimary = "#d17d11".fromHex;
  static Color grey1 = "#707070".fromHex;
  static Color grey2 = "#797979".fromHex;
  static Color white = "#FFFFFF".fromHex;
  static Color error = "#e61f34".fromHex; //red color

  static Color black = "#000000".fromHex; //black
}

extension HexColor on String {
  Color get fromHex{
    String hexColorString = this;
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString = "FF$hexColorString";
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}
