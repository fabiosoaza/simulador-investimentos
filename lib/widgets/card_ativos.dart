import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simulador_investimentos/core/context/application_context.dart';
import 'package:simulador_investimentos/core/model/domain/ativo.dart';
import 'package:simulador_investimentos/pages/ativos_bloc.dart';
import 'package:simulador_investimentos/pages/load_ativos_por_tipo_event.dart';
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

  AtivosBloc _ativosBloc;

  _CardAtivosState(String tipoAtivo, String titulo) {
    this._tipoAtivo = tipoAtivo;
    this._titulo = titulo;
  }

  @override
  void initState() {
    super.initState();
    _ativosBloc = AtivosBloc(_applicationContext.ativoRepository);
    _ativosBloc.onEventChanged(new LoadAtivosPorTipoEvent(_tipoAtivo));
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
            _tituloListagem(),
            Expanded(child:
            StreamBuilder<bool>(
                stream: _ativosBloc.isLoading,
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

  StreamBuilder<List<Ativo>> _buildBody() {
    return StreamBuilder<List<Ativo>>(
        stream: _ativosBloc.outData,
        builder: (BuildContext context, AsyncSnapshot<List<Ativo>> snapshot)  {
          return _mainBlock(snapshot);
        }
    );
  }


  Widget _buildBlockLoading(){
    var widgets = <Widget>[];
    widgets.addAll(UiUtils.getLoadingAnimation());
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );
  }


  Widget _mainBlock(AsyncSnapshot<List<Ativo>> snapshot) {
    var widget = Container();
    if(snapshot.hasData) {
      widget = _gridView(snapshot.data);
    }
    else if(snapshot.hasError){
      widget = _widgetsError();
    }
    return widget;
  }

  Widget _widgetsError() {
        return Column(children: UiUtils.getErrorLoadingInfo());
  }


  Widget _tituloListagem() {
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
            NavigationUtils.showMenuOperacaoAtivo(context, ativo);
          },
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: <Widget>[
                _gridTile(ativo, index),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _gridTile(Ativo ativo, int index) {
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


}
