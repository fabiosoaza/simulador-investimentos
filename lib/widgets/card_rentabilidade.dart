import "package:flutter/material.dart";
import 'package:simulador_investimentos/core/context/application_context.dart';
import 'package:simulador_investimentos/core/model/domain/carteira.dart';
import 'package:simulador_investimentos/core/model/domain/valor_monetario.dart';
import 'package:simulador_investimentos/core/util/formatador_numeros.dart';
import 'package:simulador_investimentos/pages/ativos_carteira_bloc.dart';
import 'package:simulador_investimentos/pages/bloc_events.dart';
import 'package:simulador_investimentos/themes/colors.dart';
import 'package:simulador_investimentos/widgets/util/ui_utils.dart';

class CardRentabilidade extends StatefulWidget {
  @override
  _CardRentabilidadeState createState() => _CardRentabilidadeState();
}

class _CardRentabilidadeState extends State<CardRentabilidade> {

  ApplicationContext _applicationContext = ApplicationContext.instance();

  static const  int _CASAS_DECIMAIS = 2;
  AtivosCarteiraBloc _ativosCarteiraBloc;


  @override
  void initState() {
    super.initState();
    _ativosCarteiraBloc = AtivosCarteiraBloc(_applicationContext.carteiraRepository);
    _ativosCarteiraBloc.onEventChanged(LoadDataEvent());
  }

  String _formatarValorMonetario(ValorMonetario valor) => valor.valorFormatadoComCasasDecimais(_CASAS_DECIMAIS);

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
               })
            ),
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
      children = _widgetsSuccess(snapshot.data);
    }else if (snapshot.hasError) {
      children = _widgetsError(snapshot);
    }
    widgets.addAll(children);
    widgets.add( SizedBox(
      height: 15,
    ),
    );
    widgets.add( new Divider(color: kNighSky,));
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );
  }

   List<Widget> _widgetsLoading() {
    return UiUtils.getLoadingAnimation();
  }

  List<Widget> _widgetsError(AsyncSnapshot<Carteira> snapshot) {
    return UiUtils.getErrorLoadingInfo();
  }

  List<Widget> _widgetsSuccess(Carteira carteira) {
    var valorInvestidoCarteira = _formatarValorMonetario(carteira.calcularValorCompraCarteira());
    var valorAtualCarteira = _formatarValorMonetario(carteira.calcularValorAtualCarteira());
   var rentabilidadeFormatada = FormatadorNumeros().formatarPorcentagem(carteira.calcularRentabilidadePercentual(), _CASAS_DECIMAIS)+'%';
   var lucroFormatado = _formatarValorMonetario(carteira.calcularLucro());
    return  <Widget>[
          SizedBox(
            height: 15,
          ),
          Text(
            "VALOR DA CARTEIRA",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold, color:kNighSky),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            valorAtualCarteira,
            style: TextStyle(
                fontSize: 28,
                color: UiUtils.getColorByValor(carteira.calcularValorAtualCarteira().valorAsDouble()),
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "RENTABILIDADE",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold, color:kNighSky),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            rentabilidadeFormatada,
            style: TextStyle(
                fontSize: 28,
                color: UiUtils.getColorByValor(carteira.calcularRentabilidadePercentual()),
                fontWeight: FontWeight.bold),
          ),

      SizedBox(
        height: 8,
      ),
      Text(
        "VALOR INVESTIDO",
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold, color:kNighSky),
      ),
      SizedBox(
        height: 5,
      ),
      Text(
        valorInvestidoCarteira,
        style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold, color:kTitleAccentSecundaryColor),
      ),

          SizedBox(
            height: 15,
          ),
          Text.rich(
            TextSpan(
              text: 'Lucro/Prejuízo ',
              children: [
                TextSpan(
                    text: lucroFormatado,
                    style: TextStyle(
                      color: UiUtils.getColorByValor(carteira.calcularLucro().valorAsDouble()),
                    )),
              ],
              style: TextStyle(fontSize: 18, color:kNighSky),
            ),
          ),



        ];

  }

  Widget _titleCard() {
    return Row(
          children: <Widget>[
            Icon(
              Icons.account_balance_wallet,
              size: 30,
              color: kPrimaryColor,
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              'Carteira de Investimentos',
              style: TextStyle(
                fontSize: 18,
                color: kNighSky

              ),
            ),
          ],
        );
  }

@override
  void dispose() {
  super.dispose();
  _ativosCarteiraBloc.dispose();
  }
}
