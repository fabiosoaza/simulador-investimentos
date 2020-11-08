import "package:flutter/material.dart";
import 'package:simulador_investimentos/core/context/application_context.dart';
import 'package:simulador_investimentos/core/model/ativo.dart';
import 'package:simulador_investimentos/core/model/ativo_carteira_cotacao.dart';
import 'package:simulador_investimentos/core/util/ativo_utils.dart';
import 'package:simulador_investimentos/themes/colors.dart';

class CardAtivosCarteira extends StatefulWidget {
  @override
  _CardAtivosCarteiraState createState() => _CardAtivosCarteiraState();
}

class _CardAtivosCarteiraState extends State<CardAtivosCarteira> {
  ApplicationContext _applicationContext = ApplicationContext.instance();
  List<AtivoCarteiraCotacao> _ativoCarteiraCotacao =
      List<AtivoCarteiraCotacao>();

  @override
  void initState() {
    super.initState();
    reload();
  }

  Future<void> reload() async {
    final carteira =
        await _applicationContext.ativoCotacaoService.listarAtivosCarteira();
    var updateView = () {
      this._ativoCarteiraCotacao = carteira.ativosCarteiraCotacao;
    };
    setState(updateView);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Card(
        margin: EdgeInsets.only(right: 20),
        child: Column(
          children: [
            tituloListagem(),
            Expanded(child: listView()),
          ],
        ),
      ),
    );
  }

  Widget tituloListagem(){

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.layers,
                size: 30,
                color: kPrimaryColor,
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                'Ativos em carteira',
                style: TextStyle(
                  fontSize: 18,


                ),
              ),
            ],
          )

        ]));
  }


  Widget listView() {
    return Container(
      child: new ListView.builder(
        itemCount: _ativoCarteiraCotacao.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return cardHeader();
          } else {
            var ativo = _ativoCarteiraCotacao[index - 1];
            return cardRow(ativo);
          }
        },
      ),
    );
  }

  Card cardHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            headerCodigoAtivo(),
            headerPrecoMedio(),
            headerValorTotal(),
          ],
        ),
      ),
    );
  }

  Card cardRow(AtivoCarteiraCotacao ativo) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            contentCodigoAtivo(ativo),
            contentPrecoMedio(ativo),
            contentValorTotal(ativo),
          ],
        ),
      ),
    );
  }

  Widget headerCodigoAtivo() {
    var title1 = 'Código';
    var title2 = 'Quantidade';
    return columnHeader(title1, title2);
  }

  Widget headerPrecoMedio() {
    var title1 = 'Preço médio';
    var title2 = 'Preço atual';
    return columnHeader(title1, title2);
  }

  Widget headerValorTotal() {
    var title1 = 'Valor compra';
    var title2 = 'Valor atual';
    return columnHeader(title1, title2);
  }

  int getNumeroCasasDecimais(Ativo ativo ){
      return AtivoUtils.getNumeroCasasDecimais(ativo);
  }

  Widget contentCodigoAtivo(AtivoCarteiraCotacao ativoCarteiraCotacao) {
    var title1 = ativoCarteiraCotacao.ativoCarteira.ativo.ticker;
    var title2 = ativoCarteiraCotacao.ativoCarteira.quantidade.toString();
    return columnContent(title1, title2);
  }

  Widget contentPrecoMedio(AtivoCarteiraCotacao ativoCarteiraCotacao) {
    var numeroCasasDecimais = getNumeroCasasDecimais(ativoCarteiraCotacao.ativoCarteira.ativo);
    var title1 = ativoCarteiraCotacao.ativoCarteira.precoMedio.valorFormatadoComCasasDecimais(numeroCasasDecimais);
    var title2 = ativoCarteiraCotacao.cotacao.valor.valorFormatadoComCasasDecimais(numeroCasasDecimais);
    return columnContent(title1, title2);
  }

  Widget contentValorTotal(AtivoCarteiraCotacao ativoCarteiraCotacao) {
    var numeroCasasDecimais = getNumeroCasasDecimais(ativoCarteiraCotacao.ativoCarteira.ativo);
    var title1 = ativoCarteiraCotacao.ativoCarteira.calcularValorTotal().valorFormatadoComCasasDecimais(numeroCasasDecimais);
    var title2 = ativoCarteiraCotacao.calcularValorAtual().valorFormatadoComCasasDecimais(numeroCasasDecimais);
    return columnContent(title1, title2);
  }

  Expanded columnHeader(String title1, String title2) {
    return Expanded(
      child: Column(
        // align the text to the left instead of centered
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title1,
            style: TextStyle(fontSize: 16),
          ),
          Text(title2),
        ],
      ),
    );
  }

  Expanded columnContent(String title1, String title2) {
    return Expanded(
      child: Column(
        // align the text to the left instead of centered
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title1,
            style: TextStyle(fontSize: 16),
          ),
          Text(title2),
        ],
      ),
    );
  }
}
