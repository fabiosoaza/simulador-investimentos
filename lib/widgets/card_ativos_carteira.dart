import "package:flutter/material.dart";
import 'package:simulador_investimentos/core/context/application_context.dart';
import 'package:simulador_investimentos/core/model/domain/ativo.dart';
import 'package:simulador_investimentos/core/model/domain/ativo_carteira_cotacao.dart';
import 'package:simulador_investimentos/core/model/domain/carteira.dart';
import 'package:simulador_investimentos/core/util/ativo_utils.dart';
import 'package:simulador_investimentos/core/util/formatador_numeros.dart';
import 'package:simulador_investimentos/pages/ativos_carteira_bloc.dart';
import 'package:simulador_investimentos/pages/base/bloc_events.dart';
import 'package:simulador_investimentos/themes/colors.dart';
import 'package:simulador_investimentos/widgets/util/ui_utils.dart';

class CardAtivosCarteira extends StatefulWidget {
  @override
  _CardAtivosCarteiraState createState() => _CardAtivosCarteiraState();
}

class _CardAtivosCarteiraState extends State<CardAtivosCarteira> {

   static const int CASAS_DECIMAIS = 2;

  ApplicationContext _applicationContext = ApplicationContext.instance();

  AtivosCarteiraBloc _ativosCarteiraBloc;

  @override
  void initState() {
    super.initState();
    _ativosCarteiraBloc = AtivosCarteiraBloc(_applicationContext.carteiraRepository);
    _ativosCarteiraBloc.onEventChanged(LoadDataEvent());
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
            Expanded(child: StreamBuilder<bool>(
            stream: _ativosCarteiraBloc.isLoading,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot)  {
              final isLoading = snapshot.data ?? false;
              if (isLoading) {
                return _buildBlockLoading();
              } else {
                return _buildBody();
              }
            }
            )
            )
          ],
        ),
      ),
    );
  }

   StreamBuilder<Carteira> _buildBody() {
     return StreamBuilder<Carteira>(
         stream: _ativosCarteiraBloc.outData,
         builder: (BuildContext context, AsyncSnapshot<Carteira> snapshot)  {
           return _mainBlock(snapshot);
         }
     );
   }


   Widget _buildBlockLoading(){
     var widgets = <Widget>[
       _titleCard()
     ];
     widgets.addAll(_widgetsLoading());
     return Padding(
       padding: const EdgeInsets.all(30),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: widgets,
       ),
     );
   }


   Widget _mainBlock(AsyncSnapshot<Carteira> snapshot) {
     var widgets = <Widget>[
       _titleCard()
     ];

     var children = <Widget>[];
     if(snapshot.hasData){
       children = children = [
         SizedBox(
           height: 15,
         ),
         Expanded(child: _listView(snapshot.data))
       ];
     }else if (snapshot.hasError) {
       children = _widgetsError(snapshot);
     }
     widgets.addAll(children);
     widgets.add( SizedBox(
       height: 15,
     ),
     );
     return Padding(
       padding: const EdgeInsets.only(top:5, left:15, right: 15, bottom: 5),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: widgets,
       ),
     );
   }

  Widget _titleCard() {
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



  List<Widget> _widgetsError(AsyncSnapshot<Carteira> snapshot) {
    return UiUtils.getErrorLoadingInfo();
  }

  List<Widget> _widgetsLoading() {
    return UiUtils.getLoadingAnimation();
  }


  Widget _listView(Carteira carteira) {
    return Container(
      child: new ListView.builder(
        itemCount: carteira.ativosCarteiraCotacao.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return _cardHeader();
          } else if (carteira.ativosCarteiraCotacao.isNotEmpty) {
            var ativo = carteira.ativosCarteiraCotacao[index - 1];
            return _cardRow(ativo);
          } else {
            return _cardNenhumAtivoCarteira();
          }
        },
      ),
    );
  }

  Card _cardHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            _headerCodigoAtivo(),
            _headerPrecoMedio(),
            _headerValorTotal(),
          ],
        ),
      ),
    );
  }

   Card _cardNenhumAtivoCarteira() {
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

  Card _cardRow(AtivoCarteiraCotacao ativo) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            _contentCodigoAtivo(ativo),
            _contentPrecoMedio(ativo),
            _contentValorTotal(ativo),
          ],
        ),
      ),
    );
  }

  Widget _headerCodigoAtivo() {
    return _columnHeader(['Código', 'Quantidade']);
  }

  Widget _headerPrecoMedio() {
    return _columnHeader(['Preço médio', 'Preço atual', 'Variação(%)']);
  }

  Widget _headerValorTotal() {
    return _columnHeader(['Valor compra', 'Valor atual']);
  }

  int _getNumeroCasasDecimais(Ativo ativo ){
      return AtivoUtils.getNumeroCasasDecimais(ativo);
  }

  Widget _contentCodigoAtivo(AtivoCarteiraCotacao ativoCarteiraCotacao) {
    var title1 = ativoCarteiraCotacao.ativoCarteira.ativo.ticker;
    var title2 = ativoCarteiraCotacao.ativoCarteira.quantidade.toString();
    return _columnContent([title1, title2]);
  }

  Widget _contentPrecoMedio(AtivoCarteiraCotacao ativoCarteiraCotacao) {
    var numeroCasasDecimais = _getNumeroCasasDecimais(ativoCarteiraCotacao.ativoCarteira.ativo);
    var title1 = ativoCarteiraCotacao.ativoCarteira.precoMedio.valorFormatadoComCasasDecimais(numeroCasasDecimais);
    var title2 = ativoCarteiraCotacao.cotacao.valor.valorFormatadoComCasasDecimais(numeroCasasDecimais);
    var title3 = FormatadorNumeros().formatarPorcentagem(ativoCarteiraCotacao.rentabilidadePercentual(), CASAS_DECIMAIS)+'%';
    return _columnContent([title1, title2, title3]);
  }

  Widget _contentValorTotal(AtivoCarteiraCotacao ativoCarteiraCotacao) {
    var numeroCasasDecimais = _getNumeroCasasDecimais(ativoCarteiraCotacao.ativoCarteira.ativo);
    var title1 = ativoCarteiraCotacao.ativoCarteira.calcularValorTotal().valorFormatadoComCasasDecimais(numeroCasasDecimais);
    var title2 = ativoCarteiraCotacao.calcularValorAtual().valorFormatadoComCasasDecimais(numeroCasasDecimais);
    return _columnContent([title1, title2]);
  }

  Expanded _columnHeader(List<String> titles) {
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

  Expanded _columnContent(List<String> titles) {
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

   @override
   void dispose() {
     super.dispose();
     _ativosCarteiraBloc.dispose();
   }


}
