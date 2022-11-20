import 'package:advanced_flutter_app/presentation/resources/font_manager.dart';
import 'package:flutter/material.dart';

TextStyle _getTextStyle(double fontSize, FontWeight fontWeight, Color color) {
  return TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    fontFamily: FontConstants.fontFamily,
  );
}

// regular style

TextStyle getRegularStyle(
    {double fontSize = FontSize.s10, required Color color}) {
  return _getTextStyle(fontSize, FontWeightManager.regular, color);
}

// medium style

TextStyle getMediumStyle(
    {double fontSize = FontSize.s10, required Color color}) {
  return _getTextStyle(fontSize, FontWeightManager.medium, color);
}

// light style

TextStyle getLightStyle(
    {double fontSize = FontSize.s10, required Color color}) {
  return _getTextStyle(fontSize, FontWeightManager.light, color);
}

// bold style

TextStyle getBoldStyle({double fontSize = FontSize.s10, required Color color}) {
  return _getTextStyle(fontSize, FontWeightManager.bold, color);
}

// semibold style

TextStyle getSemiBoldStyle(
    {double fontSize = FontSize.s10, required Color color}) {
  return _getTextStyle(fontSize, FontWeightManager.semiBold, color);
}
