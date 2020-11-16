import "package:flutter/material.dart";
import 'package:simulador_investimentos/core/context/application_context.dart';
import 'package:simulador_investimentos/core/model/domain/ativo.dart';
import 'package:simulador_investimentos/core/model/domain/ativo_carteira_cotacao.dart';
import 'package:simulador_investimentos/core/model/domain/carteira.dart';
import 'package:simulador_investimentos/core/util/ativo_utils.dart';
import 'package:simulador_investimentos/core/util/formatador_numeros.dart';
import 'package:simulador_investimentos/themes/colors.dart';
import 'package:simulador_investimentos/widgets/util/ui_utils.dart';

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
      aspectRatio: 0.68,
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white70, width: 6),
          borderRadius: BorderRadius.circular(36),
        ),
        color: kGrey200,
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
      padding: const EdgeInsets.only(top:5, left:15, right: 15, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );
  }

  Widget titleCard() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
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
              color:kNighSky

            ),
          ),
        ],
      ),
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
    return UiUtils.getErrorLoadingInfo();
  }

  List<Widget> _widgetsLoading() {
    return UiUtils.getLoadingAnimation();
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
color:kNighSky,

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
          } else if (carteira.ativosCarteiraCotacao.isNotEmpty) {
            var ativo = carteira.ativosCarteiraCotacao[index - 1];
            return cardRow(ativo);
          } else {
            return cardNenhumAtivoCarteira();
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

   Card cardNenhumAtivoCarteira() {
     return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Column(
              // align the text to the left instead of centered
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nenhum ativo em carteira.',
                    style: TextStyle(fontSize: 16, color: kNighSky))
              ],
            ),
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
      var widget = i == 0 ? Text(titles[i], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kNighSky)) : Text(titles[i], style: TextStyle(fontWeight: FontWeight.bold, color: kNighSky));
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
