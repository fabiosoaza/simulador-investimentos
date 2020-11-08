import "package:flutter/material.dart";
import 'package:simulador_investimentos/core/context/application_context.dart';
import 'package:simulador_investimentos/core/model/ativo.dart';
import 'package:simulador_investimentos/core/model/tipo_operacao.dart';
import 'package:simulador_investimentos/themes/colors.dart';
import 'package:simulador_investimentos/widgets/form_operacao_ativo.dart';

class CardOperacao extends StatefulWidget {

  TipoOperacao _tipoOperacao;
  Ativo _ativo;

  CardOperacao (TipoOperacao tipoOperacao, Ativo ativo) {
  this._tipoOperacao = tipoOperacao;
  this._ativo = ativo;
  }

  @override
  _CardOperacaoState createState() => _CardOperacaoState(_tipoOperacao, _ativo);
}

class _CardOperacaoState extends State<CardOperacao> {

  TipoOperacao _tipoOperacao;
  Ativo _ativo;

  _CardOperacaoState (TipoOperacao tipoOperacao, Ativo ativo) {
    this._tipoOperacao = tipoOperacao;
    this._ativo = ativo;
  }


  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.82,
      child: Card(
        margin: EdgeInsets.only(right: 20),
        child: Column(
          children: [
            Expanded(child: mainBlock()),
          ],
        ),
      ),
    );
  }

  Padding mainBlock() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                iconeTitulo(),
                size: 30,
                color: kPrimaryColor,
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                titulo(),
                style: TextStyle(
                  fontSize: 18,

                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          FormOperacaoAtivo(_tipoOperacao, _ativo)

        ],
      ),
    );
  }

  String titulo() => '${_tipoOperacao == TipoOperacao.COMPRA ? "Comprar": "Vender"} ${_ativo.nome}';

  IconData iconeTitulo() => _tipoOperacao == TipoOperacao.COMPRA ? Icons.shopping_cart : Icons.shopping_cart;
}
