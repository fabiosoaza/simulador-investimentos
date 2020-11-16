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

  static Image getLogo(String logo){
    return Image.asset("assets/$logo",
      width: 60,

    );
  }

  static List<Widget> getLoadingAnimation() {
    return <Widget>[
      Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: SizedBox(
            child: CircularProgressIndicator(backgroundColor: kLimitAccentSecondaryColor, ),
            width: 60,
            height: 60,
          ),
        ),
      ),
      Center(
        child: const Padding(
          padding: EdgeInsets.only(top: 16),
          child: Text('Buscando informações...', style: TextStyle(color:kNighSky),),
        ),
      )
    ];
  }

  static List<Widget> getErrorLoadingInfo(){
    return <Widget>[
      Center(
        child: Padding(
          padding: const EdgeInsets.only(top:16.0),
          child: Icon(
            Icons.error_outline,
            color: kNubankPrimaryColor,
            size: 80,
          ),
        ),
      ),
      Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text('Falha ao buscar informações', style: TextStyle(color:kNighSky)),
        ),
      )
    ];
  }



}
