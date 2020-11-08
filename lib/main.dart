import 'package:flutter/material.dart';
import 'package:simulador_investimentos/core/context/application_context.dart';
import 'package:simulador_investimentos/core/model/tipo_ativo.dart';
import 'package:simulador_investimentos/pages/home_page.dart';
import 'package:simulador_investimentos/themes/colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simulador Carteira de Investimentos',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        accentColor: kAccentColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

