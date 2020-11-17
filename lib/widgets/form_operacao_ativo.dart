import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simulador_investimentos/core/context/application_context.dart';
import 'package:simulador_investimentos/core/model/domain/ativo.dart';
import 'package:simulador_investimentos/core/model/domain/ativo_carteira.dart';
import 'package:simulador_investimentos/core/model/domain/ativo_constants.dart';
import 'package:simulador_investimentos/core/model/domain/carteira.dart';
import 'package:simulador_investimentos/core/model/domain/tipo_operacao.dart';
import 'package:simulador_investimentos/core/model/domain/validador_valor.dart';
import 'package:simulador_investimentos/core/model/domain/validador_venda_ativo_carteira.dart';
import 'package:simulador_investimentos/core/model/domain/valor_monetario.dart';
import 'package:simulador_investimentos/core/util/ativo_utils.dart';
import 'package:simulador_investimentos/core/util/formatador_numeros.dart';
import 'package:simulador_investimentos/themes/colors.dart';
import 'package:simulador_investimentos/widgets/util/navigation_utils.dart';

class FormOperacaoAtivo extends StatefulWidget {
  TipoOperacao _tipoOperacao;
  Ativo _ativo;

  FormOperacaoAtivo(TipoOperacao tipoOperacao, Ativo ativo) {
    this._tipoOperacao = tipoOperacao;
    this._ativo = ativo;
  }

  @override
  _FormOperacaoAtivoState createState() =>
      _FormOperacaoAtivoState(_tipoOperacao, _ativo);
}

class _FormOperacaoAtivoState extends State<FormOperacaoAtivo> {

  TextEditingController _precoAtivo = TextEditingController();
  TextEditingController _quantidade = TextEditingController();
  TipoOperacao _tipoOperacao;
  GlobalKey<FormState> _formularioKey = GlobalKey<FormState>();
  Ativo _ativo;
  Carteira _carteira;

  ApplicationContext _applicationContext = ApplicationContext.instance();


  _FormOperacaoAtivoState(TipoOperacao tipoOperacao, Ativo ativo) {
    this._tipoOperacao = tipoOperacao;
    this._ativo = ativo;
  }

  @override
  void initState() {
    super.initState();
    resetFields();
    _applicationContext.carteiraRepository
        .carregar()
        .then((value) => _carteira = value);
  }

  void resetFields() {
    var valorDefault = 0;
    _precoAtivo.text = valorDefault.toStringAsFixed(numeroCasasDecimaisPreco());
    _quantidade.text = valorDefault.toStringAsFixed(numeroCasasDecimaisQuantidade());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: buildForm(),
    );
  }

  void salvar() {
    var quantidade = extrairQuantidade();
    var ativoCarteira = AtivoCarteira.novo(_ativo, extrairPrecoMedio(), quantidade);
    executarOperacao(ativoCarteira).whenComplete((){
      NavigationUtils.goBack(context);
      NavigationUtils.showMessage(context, "Operação efetuada com sucesso.");
    });


  }

  ValorMonetario extrairPrecoMedio() => ValorMonetario.brl(_precoAtivo.text);

  double extrairQuantidade() => FormatadorNumeros().stringToDouble(_quantidade.text.toString(), AtivoUtils.getNumeroCasasDecimais(_ativo));

  Future<void> executarOperacao(AtivoCarteira ativoCarteira) async{
    if (_tipoOperacao == TipoOperacao.COMPRA) {
      return _applicationContext.ativoCarteiraRepository.adicionar(ativoCarteira);
    } else {
      return _applicationContext.ativoCarteiraRepository.remover(ativoCarteira);
    }
  }

  Form buildForm() {
    return Form(
      key: _formularioKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildNumericTextField(
              label: "Preço médio(R\$)",
              validationFunction: _validadorValor("Informe um preço válido(R\$)"),
              controller: _precoAtivo,
              numeroCasasDecimais: numeroCasasDecimaisPreco()
          ),
          buildNumericTextField(
              label: "Quantidade",
            validationFunction: _validadorQuantidade(),
              controller: _quantidade,
              numeroCasasDecimais: numeroCasasDecimaisQuantidade()
          ),
          criarBotaoSalvar(),
        ],
      ),
    );
  }

  int numeroCasasDecimaisQuantidade() => _ativo.tipo == AtivoConstants.TIPO_ACAO ? 0 : 4;

  int numeroCasasDecimaisPreco() => _ativo.tipo == AtivoConstants.TIPO_ACAO ? 2 : 3;

  Widget criarBotaoSalvar() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 26.0),
      child: RaisedButton(
        onPressed: () {
          if (_formularioKey.currentState.validate()) {
            salvar();
          }
        },
        child: Text(textoBotaoOperacao(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
            )),
        color: _tipoOperacao == TipoOperacao.COMPRA
            ? kOperacaoCompraColor
            : kOperacaoVendaColor,
      ),
    );
  }

  String textoBotaoOperacao() =>
      _tipoOperacao == TipoOperacao.COMPRA ? "Comprar" : "Vender";


  TextFormField buildNumericTextField(
      {TextEditingController controller, Function validationFunction, String label, int numeroCasasDecimais}) {
        var regexp = numeroCasasDecimais == 0 ? r'^(\d+)': r'^(\d+)?\.?\d{0,'+numeroCasasDecimais.toString()+'}';
    return TextFormField(
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(regexp)),
      ],
      keyboardType: TextInputType.numberWithOptions(decimal: numeroCasasDecimais !=0 ),
      decoration: InputDecoration(
          labelText: label, errorStyle: TextStyle(fontSize: 19, color: kOperacaoVendaColor)),
      controller: controller,
      validator: validationFunction,
      style: TextStyle(
        fontSize: 32,
        color: Colors.black87,
      ),
    );
  }

  Function _validadorValor(String error){
    return (text) {
      return ValidadorValor(text).validar() ? null : error;
    };
  }

  Function _validadorQuantidade(){
    return (text) {
      if(!ValidadorValor(text).validar()){
        return "Informe a quantidade";
      }
      if(_tipoOperacao == TipoOperacao.VENDA){
        var validador = ValidadorVendaAtivoCarteira(text, _carteira.findAtivoCarteira(_ativo));
        if (!validador.validar()) {
          return "Quantidade não disponível";
        }
      }
      return null;
    };
  }
}
