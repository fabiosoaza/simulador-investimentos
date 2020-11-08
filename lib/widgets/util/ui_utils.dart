import 'package:flutter/material.dart';
import 'package:simulador_investimentos/themes/colors.dart';

class UiUtils {

  static Color getColorByValor(double valor) {
    Color color = kTitleAccentSecundaryColor;
    if (valor > 0) {
      color = kLimitAccentSecondaryColor;
    } else if (valor < 0) {
      color = kNegativeValueColor;
    }
    return color;
  }
}
