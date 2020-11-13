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
        await _applicationContext.ativoRepository.listarPorTipo(_tipoAtivo);
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
