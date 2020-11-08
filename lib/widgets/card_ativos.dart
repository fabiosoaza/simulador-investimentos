import 'package:flutter/material.dart';
import 'package:simulador_investimentos/core/context/application_context.dart';
import 'package:simulador_investimentos/core/model/ativo.dart';
import 'package:simulador_investimentos/core/model/tipo_operacao.dart';
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

  List<Ativo> _ativos = List<Ativo>();

  String _titulo;
  String _tipoAtivo;

  _CardAtivosState(String tipoAtivo, String titulo) {
    this._tipoAtivo = tipoAtivo;
    this._titulo = titulo;
  }

  @override
  void initState() {
    super.initState();
    reload();
  }

  Future<void> reload() async {
    final ativos =
        await _applicationContext.ativoService.listarPorTipo(_tipoAtivo);
    var updateView = () {
      this._ativos = ativos;
    };
    setState(updateView);
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
            Expanded(child: listView()),
          ],
        ),
      ),
    );
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

  Widget listView() {
    return Container(
      child: new ListView.builder(
        itemCount: _ativos.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return cardHeader();
          } else {
            var ativo = _ativos[index - 1];
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
            headerNomeAtivo(),
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
                    menuComprarAtivo(ativo),
                    menuVenderAtivo(ativo)

                      ]
                  )
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            contentCodigoAtivo(ativo),
            contentNomeAtivo(ativo),
          ],
        ),
      ),
    ));
  }

  Widget menuComprarAtivo(Ativo ativo) {
    return ListTile(
        onTap: () {
          NavigationUtils.navigateToOperacao(
              context, TipoOperacao.COMPRA, ativo);
        },
        leading: Icon(
          Icons.add_shopping_cart,
          size: 30,
        ),
        title: Text('Comprar ${ativo.nome}',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)));
  }

  Widget menuVenderAtivo(Ativo ativo) {
    return ListTile(
        onTap: () {
          NavigationUtils.navigateToOperacao(
              context, TipoOperacao.VENDA, ativo);
        },
        leading: Icon(
          Icons.remove_shopping_cart,
          size: 30,
        ),
        title: Text('Vender ${ativo.nome}',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)));
  }

  Widget headerCodigoAtivo() {
    return columnHeader('Código');
  }

  Widget headerNomeAtivo() {
    return columnHeader('Nome');
  }

  Widget contentCodigoAtivo(Ativo ativo) {
    return columnContent(ativo.ticker);
  }

  Widget contentNomeAtivo(Ativo ativo) {
    return columnContent(ativo.nome);
  }

  Expanded columnHeader(String title1) {
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

  Expanded columnContent(String title1) {
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
