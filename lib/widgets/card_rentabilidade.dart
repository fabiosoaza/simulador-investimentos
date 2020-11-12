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
  String _patrimonioFormatado;
  String _rentabilidadeFormatada;
  String _lucroFormatado;

  static final int CASAS_DECIMAIS = 2;
  Carteira _carteira = Carteira.nova();

  @override
  void initState() {
    super.initState();
    reload();
  }


  Future<void> reload() async {
    atualizarDadosView();
    _carteira = await _applicationContext.ativoCotacaoRepository.carregar();
    var updateView = () {
      atualizarDadosView();
    };
    setState(updateView);

  }

  void atualizarDadosView() {
    _patrimonioFormatado = formatarValorMonetario(_carteira.calcularValorAtualCarteira());
    _rentabilidadeFormatada = formatarPorcentagem(_carteira.calcularRentabilidadePercentual());
    _lucroFormatado = formatarValorMonetario(_carteira.calcularLucro());
  }


  Color _corValorRentabilidade(){
    return UiUtils.getColorByValor(_carteira.calcularRentabilidadePercentual());
  }

  Color _corValorLucro(){
    return UiUtils.getColorByValor(_carteira.calcularLucro().valorAsDouble());
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
            Expanded(child: mainBlock()),
          ],
        ),
      ),
    );
  }

  Padding mainBlock() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
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
          ),
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
            _patrimonioFormatado,
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
            _rentabilidadeFormatada,
            style: TextStyle(
                fontSize: 28,
                color: _corValorRentabilidade(),
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
                    text: _lucroFormatado,
                    style: TextStyle(
                      color: _corValorLucro(),
                    )),
              ],
              style: TextStyle(fontSize: 18),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
