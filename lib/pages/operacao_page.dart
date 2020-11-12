import 'package:flutter/material.dart';
import 'package:simulador_investimentos/core/model/domain/ativo.dart';
import 'package:simulador_investimentos/core/model/domain/tipo_operacao.dart';
import 'package:simulador_investimentos/pages/template/default_statefull_page.dart';
import 'package:simulador_investimentos/pages/template/default_statefull_page_state.dart';
import 'package:simulador_investimentos/widgets/card_operacao.dart';

class OperacaoPage extends DefaultStatefullPage {
  TipoOperacao _tipoOperacao;
  Ativo _ativo;

  OperacaoPage(TipoOperacao tipoOperacao, Ativo ativo) {
    this._tipoOperacao = tipoOperacao;
    this._ativo = ativo;
  }

  @override
  _OperacaoPageState createState() =>
      _OperacaoPageState(false, _tipoOperacao, _ativo);
}

class _OperacaoPageState extends DefaultStatefullPageState {
  TipoOperacao _tipoOperacao;
  Ativo _ativo;

  _OperacaoPageState(
      bool showBottonMenu, TipoOperacao tipoOperacao, Ativo ativo)
      : super(showBottonMenu) {
    this._tipoOperacao = tipoOperacao;
    this._ativo = ativo;
  }

  @override
  List<Widget> buildWidgets() {
    var widgets = <Widget>[CardOperacao(_tipoOperacao, _ativo)];
    return widgets;
  }
}
