import "package:flutter/material.dart";
import 'package:simulador_investimentos/pages/base/default_statefull_page.dart';
import 'package:simulador_investimentos/pages/base/default_statefull_page_state.dart';
import 'package:simulador_investimentos/widgets/card_rentabilidade.dart';

class HomePage extends DefaultStatefullPage {


  @override
  _HomePageState createState() => _HomePageState(true);
}

class _HomePageState extends DefaultStatefullPageState {

  _HomePageState(bool showBottomMenu) : super(showBottomMenu);

  @override
  List<Widget> buildWidgets() {
    var widgets = <Widget>[
      Expanded(
          child: ListView(
            children: [
              CardRentabilidade(),
            ],
          )
      ),
      SizedBox(height: 20,)
    ];
    return widgets;
  }


}
