import "package:flutter/material.dart";
import 'package:simulador_investimentos/pages/base/default_statefull_page.dart';
import 'package:simulador_investimentos/pages/base/default_statefull_page_state.dart';
import 'package:simulador_investimentos/widgets/card_ativos_carteira.dart';

class AtivosCarteiraPage extends DefaultStatefullPage {
  @override
  _AtivosCarteiraPageState createState() => _AtivosCarteiraPageState(true);
}

class _AtivosCarteiraPageState extends DefaultStatefullPageState {
  _AtivosCarteiraPageState(bool showBottomMenu) : super(showBottomMenu);

  @override
  List<Widget> buildWidgets() {
    var widgets = <Widget>[
      Expanded(
          child: ListView(
        children: [
          CardAtivosCarteira(),
        ],
      )),
      SizedBox(
        height: 20,
      )
    ];
    return widgets;
  }
}
