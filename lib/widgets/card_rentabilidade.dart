import "package:flutter/material.dart";
import 'package:simulador_investimentos/core/context/application_context.dart';
import 'package:simulador_investimentos/core/model/domain/carteira.dart';
import 'package:simulador_investimentos/core/model/domain/valor_monetario.dart';
import 'package:simulador_investimentos/core/util/formatador_numeros.dart';
import 'package:simulador_investimentos/themes/colors.dart';
import 'package:simulador_investimentos/widgets/util/ui_utils.dart';

class CardRentabilidade extends StatefulWidget {
  @override
  _CardRentabilidadeState createState() => _CardRentabilidadeState();
}

class _CardRentabilidadeState extends State<CardRentabilidade> {

  ApplicationContext _applicationContext = ApplicationContext.instance();

  static const  int CASAS_DECIMAIS = 2;
  Future<Carteira> _futureCarteira;


  @override
  void initState() {
    super.initState();
    _futureCarteira = _applicationContext.carteiraRepository.carregar();
  }


  Color _corValorRentabilidade(Carteira carteira){
    return UiUtils.getColorByValor(carteira.calcularRentabilidadePercentual());
  }

  Color _corValorLucro(Carteira carteira){
    return UiUtils.getColorByValor(carteira.calcularLucro().valorAsDouble());
  }

  String formatarPorcentagem(double valor){
    return FormatadorNumeros().formatarPorcentagem(valor, CASAS_DECIMAIS)+'%';
  }

  String formatarValorMonetario(ValorMonetario valor) => valor.valorFormatadoComCasasDecimais(CASAS_DECIMAIS);


  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.35,
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

  List<Widget> _widgetsChildren(AsyncSnapshot<Carteira> snapshot) {
    var children;
    if(snapshot.hasData){
      children = _widgetsSuccess(snapshot.data);
    }else if (snapshot.hasError) {
      children = _widgetsError(snapshot);
    } else {
      children = _widgetsLoading();
    }
    return children;
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

  List<Widget> _widgetsSuccess(Carteira carteira) {
    var patrimonioFormatado = formatarValorMonetario(carteira.calcularValorAtualCarteira());
   var rentabilidadeFormatada = formatarPorcentagem(carteira.calcularRentabilidadePercentual());
   var lucroFormatado = formatarValorMonetario(carteira.calcularLucro());
    return  <Widget>[
          SizedBox(
            height: 15,
          ),
          Text(
            "PATRIMÔNIO",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            patrimonioFormatado,
            style: TextStyle(
                fontSize: 28,
                color: kTitleAccentSecundaryColor,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "RENTABILIDADE",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            rentabilidadeFormatada,
            style: TextStyle(
                fontSize: 28,
                color: _corValorRentabilidade(carteira),
                fontWeight: FontWeight.bold),
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
                      color: _corValorLucro(carteira),
                    )),
              ],
              style: TextStyle(fontSize: 18),
            ),
          ),
          Spacer(),
        ];

  }

  Row titleCard() {
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


              ),
            ),
          ],
        );
  }
}
