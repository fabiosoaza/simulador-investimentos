import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simulador_investimentos/core/context/application_context.dart';
import 'package:simulador_investimentos/core/model/ativo.dart';
import 'package:simulador_investimentos/core/model/ativo_carteira.dart';
import 'package:simulador_investimentos/core/model/tipo_operacao.dart';
import 'package:simulador_investimentos/core/model/validador_valor.dart';
import 'package:simulador_investimentos/core/model/valor_monetario.dart';
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

  ApplicationContext _applicationContext = ApplicationContext.instance();


  _FormOperacaoAtivoState(TipoOperacao tipoOperacao, Ativo ativo) {
    this._tipoOperacao = tipoOperacao;
    this._ativo = ativo;
  }

  @override
  void initState() {
    super.initState();
    resetFields();
  }

  void resetFields() {
    var valorDefault = '0.0';
    _precoAtivo.text = valorDefault;
    _quantidade.text = valorDefault;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: buildForm(),
    );
  }

  void salvar() {
    setState(() async {
      var quantidade = FormatadorNumeros().stringToDouble(_quantidade.text.toString(), AtivoUtils.getNumeroCasasDecimais(_ativo));
      var ativoCarteira = AtivoCarteira.novo(_ativo, ValorMonetario.brl(_precoAtivo.text), quantidade);
      if(_tipoOperacao == TipoOperacao.COMPRA) {
        _applicationContext.ativoCarteiraService.adicionarAtivoCarteira(
            ativoCarteira)
        .then((value) {
          _applicationContext.cotacaoService.carregarCotacoes();
        })
        ;
      }
      else{
        _applicationContext.ativoCarteiraService.removerAtivoCarteira(
            ativoCarteira).then((value)  {
          _applicationContext.cotacaoService.carregarCotacoes();
            })
        ;
      }
      //recarrega cache de cotações
      NavigationUtils.replaceWithMercado(context).then((value) {
        NavigationUtils.showToast(context, "Operação efetuada com sucesso.");
      });
    });
  }

  Form buildForm() {
    return Form(
      key: _formularioKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildTextFormField(
              label: "Preço médio(R\$)",
              error: "Informe um preço válido(R\$)",
              controller: _precoAtivo),
          buildTextFormField(
              label: "Quantidade",
              error: "Informe uma quantidade",
              controller: _quantidade),
          criarBotaoSalvar(),
        ],
      ),
    );
  }

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


  TextFormField buildTextFormField(
      {TextEditingController controller, String error, String label}) {
    return TextFormField(
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,3}')),
      ],
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
          labelText: label, errorStyle: TextStyle(fontSize: 19)),
      controller: controller,
      validator: (text) {
        return ValidadorValor(text).validar() ? null : error;
      },
      style: TextStyle(
        fontSize: 32,
        color: Colors.black87,
      ),
    );
  }
}
