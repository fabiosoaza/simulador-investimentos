import 'package:flutter/material.dart';
import 'package:simulador_investimentos/core/model/domain/tipo_ativo.dart';
import 'package:simulador_investimentos/pages/template/default_statefull_page.dart';
import 'package:simulador_investimentos/pages/template/default_statefull_page_state.dart';
import 'package:simulador_investimentos/widgets/card_ativos.dart';

class MercadoPage extends DefaultStatefullPage {
  @override
  _MercadoPageState createState() => _MercadoPageState(true);
}

class _MercadoPageState extends DefaultStatefullPageState {
  _MercadoPageState(bool showBottomMenu) : super(showBottomMenu);

  @override
  List<Widget> buildWidgets() {
    var widgets = <Widget>[
      Expanded(
          child: ListView(
        children: [
          CardAtivos(AtivoConstants.TIPO_ACAO, "Ações"),
          SizedBox(
            height: 15,
          ),
          CardAtivos(AtivoConstants.TIPO_CRYPTOMOEDA, "Criptomoedas"),
        ],
      )),
      SizedBox(
        height: 20,
      )
    ];
    return widgets;
  }
}
