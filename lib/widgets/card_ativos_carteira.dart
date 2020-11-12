import "package:flutter/material.dart";
import 'package:simulador_investimentos/core/context/application_context.dart';
import 'package:simulador_investimentos/core/model/domain/ativo.dart';
import 'package:simulador_investimentos/core/model/domain/ativo_carteira_cotacao.dart';
import 'package:simulador_investimentos/core/util/ativo_utils.dart';
import 'package:simulador_investimentos/core/util/formatador_numeros.dart';
import 'package:simulador_investimentos/themes/colors.dart';

class CardAtivosCarteira extends StatefulWidget {
  @override
  _CardAtivosCarteiraState createState() => _CardAtivosCarteiraState();
}

class _CardAtivosCarteiraState extends State<CardAtivosCarteira> {

  static final int CASAS_DECIMAIS = 2;

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
        await _applicationContext.ativoCotacaoRepository.carregar();
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
    return columnHeader(['Código', 'Quantidade']);
  }

  Widget headerPrecoMedio() {
    return columnHeader(['Preço médio', 'Preço atual', 'Variação(%)']);
  }

  Widget headerValorTotal() {
    return columnHeader(['Valor compra', 'Valor atual']);
  }

  int getNumeroCasasDecimais(Ativo ativo ){
      return AtivoUtils.getNumeroCasasDecimais(ativo);
  }

  Widget contentCodigoAtivo(AtivoCarteiraCotacao ativoCarteiraCotacao) {
    var title1 = ativoCarteiraCotacao.ativoCarteira.ativo.ticker;
    var title2 = ativoCarteiraCotacao.ativoCarteira.quantidade.toString();
    return columnContent([title1, title2]);
  }

  Widget contentPrecoMedio(AtivoCarteiraCotacao ativoCarteiraCotacao) {
    var numeroCasasDecimais = getNumeroCasasDecimais(ativoCarteiraCotacao.ativoCarteira.ativo);
    var title1 = ativoCarteiraCotacao.ativoCarteira.precoMedio.valorFormatadoComCasasDecimais(numeroCasasDecimais);
    var title2 = ativoCarteiraCotacao.cotacao.valor.valorFormatadoComCasasDecimais(numeroCasasDecimais);
    var title3 = FormatadorNumeros().formatarPorcentagem(ativoCarteiraCotacao.rentabilidadePercentual(), CASAS_DECIMAIS)+'%';
    return columnContent([title1, title2, title3]);
  }

  Widget contentValorTotal(AtivoCarteiraCotacao ativoCarteiraCotacao) {
    var numeroCasasDecimais = getNumeroCasasDecimais(ativoCarteiraCotacao.ativoCarteira.ativo);
    var title1 = ativoCarteiraCotacao.ativoCarteira.calcularValorTotal().valorFormatadoComCasasDecimais(numeroCasasDecimais);
    var title2 = ativoCarteiraCotacao.calcularValorAtual().valorFormatadoComCasasDecimais(numeroCasasDecimais);
    return columnContent([title1, title2]);
  }

  Expanded columnHeader(List<String> titles) {
    var widgets = <Widget>[];

    for (var i = 0; i < titles.length; i++) {
      var widget = i == 0 ? Text(titles[i], style: TextStyle(fontSize: 16)) : Text(titles[i]);
      widgets.add(widget);
    }
    return Expanded(
      child: Column(
        // align the text to the left instead of centered
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );
  }

  Expanded columnContent(List<String> titles) {
    var widgets = <Widget>[];

    for (var i = 0; i < titles.length; i++) {
      var widget = i == 0 ? Text(titles[i], style: TextStyle(fontSize: 16)) : Text(titles[i]);
      widgets.add(widget);
    }

    return Expanded(
      child: Column(
        // align the text to the left instead of centered
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );
  }
}
