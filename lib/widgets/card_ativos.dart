import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simulador_investimentos/core/context/application_context.dart';
import 'package:simulador_investimentos/core/model/domain/ativo.dart';
import 'package:simulador_investimentos/core/model/domain/tipo_operacao.dart';
import 'package:simulador_investimentos/themes/colors.dart';
import 'package:simulador_investimentos/widgets/util/navigation_utils.dart';
import 'package:simulador_investimentos/widgets/util/ui_utils.dart';

class CardAtivos extends StatefulWidget {
  String _tipoAtivo;
  String _titulo;

  CardAtivos(String tipoAtivo, String titulo) {
    this._tipoAtivo = tipoAtivo;
    this._titulo = titulo;
  }

  @override
  _CardAtivosState createState() => _CardAtivosState(_tipoAtivo, _titulo);
}

class _CardAtivosState extends State<CardAtivos> {
  ApplicationContext _applicationContext = ApplicationContext.instance();

  String _titulo;
  String _tipoAtivo;

  Future<List<Ativo>> _futureAtivos;

  _CardAtivosState(String tipoAtivo, String titulo) {
    this._tipoAtivo = tipoAtivo;
    this._titulo = titulo;
  }

  @override
  void initState() {
    super.initState();
    _futureAtivos = _applicationContext.ativoRepository.listarPorTipo(_tipoAtivo);
  }


  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.40,
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white70, width: 6),
          borderRadius: BorderRadius.circular(36),
        ),
        color: kGrey200,
        margin: EdgeInsets.only(right: 20),
        child: Column(
          children: [
            tituloListagem(),
            Expanded(child:
            FutureBuilder<List<Ativo>>(
                future: _futureAtivos,
                builder: (BuildContext context, AsyncSnapshot<List<Ativo>> snapshot)  {
                  return  mainBlock(snapshot);
                }
            ))

          ],
        ),
      ),
    );
  }

  Widget mainBlock(AsyncSnapshot<List<Ativo>> snapshot) {
    var widget;
    if(snapshot.hasData) {
      widget = _gridView(snapshot.data);
    }
    else if(snapshot.hasError){
      widget = _widgetsError();
    }
    else{
      widget = _widgetsLoading();
    }
    return widget;
  }

  Widget _widgetsError() {
        return Column(children: UiUtils.getErrorLoadingInfo());
  }


  Widget _widgetsLoading() {
        return Column(children: UiUtils.getLoadingAnimation());
  }

  Widget tituloListagem() {
    return Padding(
        padding: const EdgeInsets.only(top:22, left:22, right: 22),
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
                    _titulo,
                    style: TextStyle(
                      fontSize: 18,
                      color:kNighSky
                    ),
                  ),
                ],
              )
            ]));
  }



  Widget _gridView(List<Ativo> ativos) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Flexible(
              child: GridView.builder(
                physics: BouncingScrollPhysics(), // if you want IOS bouncing effect, otherwise remove this line
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),//change the number as you want
                scrollDirection: Axis.horizontal,
                itemCount: ativos.length,
                itemBuilder: (BuildContext context, int index) {
                  return _gridItem(ativos[index], index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gridItem(Ativo ativo, int index) {
    return Container(
      child: Card(
        child: InkWell(
          onTap: () {
            showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                      child: Wrap(children: <Widget>[
                        _menuComprarAtivo(ativo),
                        _menuVenderAtivo(ativo)

                      ]
                      )
                  );
                });
          },
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: <Widget>[
                _gitem(ativo, index),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _gitem(Ativo ativo, int index) {
    return Expanded(
      child: Column(
        // align the text to the left instead of centered
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(child: UiUtils.getLogo(ativo.logo)),
          SizedBox(height: 10,),
          Center(
            child: Text(
              ativo.ticker,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),


        ],
      ),
    );
  }




  Card cardHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            _headerCodigoAtivo(),
            _headerNomeAtivo(),
          ],
        ),
      ),
    );
  }

  Widget cardRow(Ativo ativo) {
    return Card(
        child: InkWell(
      onTap: () {
        showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return Container(
                  child: Wrap(children: <Widget>[
                    _menuComprarAtivo(ativo),
                    _menuVenderAtivo(ativo)

                      ]
                  )
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            _contentCodigoAtivo(ativo),
            _contentNomeAtivo(ativo),
          ],
        ),
      ),
    ));
  }

  Widget _menuComprarAtivo(Ativo ativo) {
    var operacao = TipoOperacao.COMPRA;
    var icon = Icons.add_shopping_cart;
    var text = 'Comprar ${ativo.ticker}';
    return _menuItem(operacao, ativo, icon, text);
  }

  Widget _menuVenderAtivo(Ativo ativo) {
    var operacao = TipoOperacao.VENDA;
    var icon = Icons.remove_shopping_cart;
    var text = 'Vender ${ativo.ticker}';
    return _menuItem(operacao, ativo, icon, text);
  }


  ListTile _menuItem(TipoOperacao operacao, Ativo ativo, IconData icon, String text) {
    return ListTile(
      onTap: () {
        NavigationUtils.close(context);
        NavigationUtils.navigateToOperacao(
            context, operacao, ativo);
      },
      leading: Icon(
        icon,
        size: 30,
      ),
      title: Text(text,
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: kNighSky))
  );
  }



  Widget _headerCodigoAtivo() {
    return _columnHeader('Código');
  }

  Widget _headerNomeAtivo() {
    return _columnHeader('Nome');
  }

  Widget _contentCodigoAtivo(Ativo ativo) {
    return columnContent(ativo.ticker);
  }

  Widget _contentNomeAtivo(Ativo ativo) {
    return columnContent(ativo.nome);
  }

  Widget _columnHeader(String title1) {
    return Expanded(
      child: Column(
        // align the text to the left instead of centered
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title1,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget columnContent(String title1) {
    return Expanded(
      child: Column(
        // align the text to the left instead of centered
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title1,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
