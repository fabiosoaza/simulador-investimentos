import 'package:flutter/material.dart';
import 'package:simulador_investimentos/core/context/application_context.dart';
import 'package:simulador_investimentos/core/model/domain/ativo.dart';
import 'package:simulador_investimentos/core/model/domain/tipo_operacao.dart';
import 'package:simulador_investimentos/themes/colors.dart';
import 'package:simulador_investimentos/widgets/util/navigation_utils.dart';

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
      aspectRatio: 1.35,
      child: Card(
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
      widget = listView(snapshot.data);
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
    var widgets = <Widget>[
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
    return Column(children: widgets);
  }


  Widget _widgetsLoading() {
    var widgets = <Widget>[
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
    return Column(children: widgets);
  }

  Widget tituloListagem() {
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
                    _titulo,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              )
            ]));
  }

  Widget listView(List<Ativo> ativos) {
    return Container(
      child: new ListView.builder(
        itemCount: ativos.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return cardHeader();
          } else {
            var ativo = ativos[index - 1];
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
    var text = 'Comprar ${ativo.nome}';
    return _menuItem(operacao, ativo, icon, text);
  }

  Widget _menuVenderAtivo(Ativo ativo) {
    var operacao = TipoOperacao.VENDA;
    var icon = Icons.remove_shopping_cart;
    var text = 'Vender ${ativo.nome}';
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
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold))
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
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
