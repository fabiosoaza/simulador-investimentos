import "package:flutter/material.dart";
import 'package:simulador_investimentos/core/context/application_context.dart';
import 'package:simulador_investimentos/core/model/domain/ativo.dart';
import 'package:simulador_investimentos/core/model/domain/ativo_carteira_cotacao.dart';
import 'package:simulador_investimentos/core/model/domain/carteira.dart';
import 'package:simulador_investimentos/core/util/ativo_utils.dart';
import 'package:simulador_investimentos/core/util/formatador_numeros.dart';
import 'package:simulador_investimentos/themes/colors.dart';

class CardAtivosCarteira extends StatefulWidget {
  @override
  _CardAtivosCarteiraState createState() => _CardAtivosCarteiraState();
}

class _CardAtivosCarteiraState extends State<CardAtivosCarteira> {

   static const int CASAS_DECIMAIS = 2;

  ApplicationContext _applicationContext = ApplicationContext.instance();

  Future<Carteira> _futureCarteira;

  @override
  void initState() {
    super.initState();
    _futureCarteira = _applicationContext.carteiraRepository.carregar();
  }


  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Card(
        margin: EdgeInsets.only(right: 20),
        child: Column(
          children: [
            Expanded(child: FutureBuilder<Carteira>(
                future: _futureCarteira,
                builder: (BuildContext context, AsyncSnapshot<Carteira> snapshot)  {
                  return mainBlock(snapshot);
                }
            )),
          ],
        ),
      ),
    );
  }

  Widget mainBlock(AsyncSnapshot<Carteira> snapshot) {
    var widgets = <Widget>[
      titleCard()
    ];
    var children = _widgetsChildren(snapshot);
    widgets.addAll(children);
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );
  }

  Row titleCard() {
    return Row(
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
    );
  }



  List<Widget> _widgetsChildren(AsyncSnapshot<Carteira> snapshot) {
    List<Widget> children = [];
    if(snapshot.hasData) {
      children = [
        SizedBox(
          height: 15,
        ),
        Expanded(child: listView(snapshot.data))
      ];
    }else if(snapshot.hasError){
      children = _widgetsError(snapshot);
    }
    else{
      children = _widgetsLoading();
    }
    return children;
  }

  List<Widget> _widgetsError(AsyncSnapshot<Carteira> snapshot) {
    return <Widget>[
      Center(
        child: Padding(
          padding: const EdgeInsets.only(top:16.0),
          child: Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
        ),
      ),
      Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text('Falha ao buscar informações', style: TextStyle(color:kPrimaryColor)),
        ),
      )
    ];
  }

  List<Widget> _widgetsLoading() {
    return <Widget>[
      Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: SizedBox(
            child: CircularProgressIndicator(),
            width: 60,
            height: 60,
          ),
        ),
      ),
      Center(
        child: const Padding(
          padding: EdgeInsets.only(top: 16),
          child: Text('Buscando informações...', style: TextStyle(color:kPrimaryColor),),
        ),
      )
    ];
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


  Widget listView(Carteira carteira) {
    return Container(
      child: new ListView.builder(
        itemCount: carteira.ativosCarteiraCotacao.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return cardHeader();
          } else {
            var ativo = carteira.ativosCarteiraCotacao[index - 1];
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
      var widget = i == 0 ? Text(titles[i], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)) : Text(titles[i], style: TextStyle(fontWeight: FontWeight.bold));
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
