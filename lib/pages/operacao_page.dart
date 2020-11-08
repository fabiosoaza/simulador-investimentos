import 'package:flutter/material.dart';
import 'package:simulador_investimentos/core/model/ativo.dart';
import 'package:simulador_investimentos/core/model/tipo_operacao.dart';
import 'package:simulador_investimentos/themes/colors.dart';
import 'package:simulador_investimentos/widgets/card_operacao.dart';
import 'package:simulador_investimentos/widgets/person_identification.dart';

class OperacaoPage extends StatefulWidget {

  TipoOperacao _tipoOperacao;
  Ativo _ativo;

  OperacaoPage(TipoOperacao tipoOperacao, Ativo ativo) {
  this._tipoOperacao = tipoOperacao;
  this._ativo = ativo;
  }


  @override
  _OperacaoPageState createState() => _OperacaoPageState(_tipoOperacao, _ativo);
}

class _OperacaoPageState extends State<OperacaoPage> {

  TipoOperacao _tipoOperacao;
  Ativo _ativo;

  _OperacaoPageState(TipoOperacao tipoOperacao, Ativo ativo) {
  this._tipoOperacao = tipoOperacao;
  this._ativo = ativo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        title: PersonIdentification(),
        elevation: 0,
      ),
       body: Padding(
        padding: const EdgeInsets.only(left: 20, bottom: 20, top: 20),
        child: Column(
          children: <Widget>[
            CardOperacao(_tipoOperacao, _ativo)
          ],
        ),
      ),
    );
  }
}
