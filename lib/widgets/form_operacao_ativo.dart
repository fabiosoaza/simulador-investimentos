import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simulador_investimentos/core/context/application_context.dart';
import 'package:simulador_investimentos/core/model/domain/ativo.dart';
import 'package:simulador_investimentos/core/model/domain/ativo_constants.dart';
import 'package:simulador_investimentos/core/model/domain/tipo_operacao.dart';
import 'package:simulador_investimentos/pages/operacao_ativo_bloc.dart';
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

  TipoOperacao _tipoOperacao;
  Ativo _ativo;

  ApplicationContext _applicationContext = ApplicationContext.instance();

  OperacaoAtivoBloc _operacaoAtivoBloc;


  _FormOperacaoAtivoState(TipoOperacao tipoOperacao, Ativo ativo) {
    this._tipoOperacao = tipoOperacao;
    this._ativo = ativo;
  }

  @override
  void initState() {
    super.initState();
    _operacaoAtivoBloc = OperacaoAtivoBloc(_tipoOperacao, _ativo.ticker, _applicationContext.carteiraRepository, _applicationContext.ativoRepository, _applicationContext.ativoCarteiraRepository);

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildForm(),
    );
  }

  Widget _buildForm() {
    return  Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildNumericTextField(
              label: "Preço médio(R\$)",
              onChangeFunction: _operacaoAtivoBloc.changeValor,
              streamField: _operacaoAtivoBloc.valor,
              numeroCasasDecimais: _numeroCasasDecimaisPreco()
          ),
          _buildNumericTextField(
              label: "Quantidade",
              onChangeFunction: _operacaoAtivoBloc.changeQuantidade,
              streamField: _operacaoAtivoBloc.quantidade,
              numeroCasasDecimais: _numeroCasasDecimaisQuantidade()
          ),
          _criarBotaoSalvar(_operacaoAtivoBloc),
        ],
    );
  }

  int _numeroCasasDecimaisQuantidade() => _ativo.tipo == AtivoConstants.TIPO_ACAO ? 0 : 4;

  int _numeroCasasDecimaisPreco() => _ativo.tipo == AtivoConstants.TIPO_ACAO ? 2 : 3;

  Widget _criarBotaoSalvar(OperacaoAtivoBloc bloc) {
    return StreamBuilder<bool>(
        stream: bloc.productValid,
        builder: (context, snapshot) {
          return RaisedButton(
            child: Text( _tipoOperacao == TipoOperacao.COMPRA ? "Comprar" : "Vender",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                )),
            color: _tipoOperacao == TipoOperacao.COMPRA
                ? kOperacaoCompraColor
                : kOperacaoVendaColor,
            onPressed: !snapshot.hasData ? null : _save(bloc),
          );
        }
    );
  }

  Function _save(OperacaoAtivoBloc bloc) {
    return () {
      bloc.executarOperacao().whenComplete(() {
        NavigationUtils.replaceWithAtivosCarteira(context);
        NavigationUtils.showMessage(context, "Operação efetuada com sucesso.");
      });
    };
  }


  StreamBuilder<String> _buildNumericTextField(
      {Stream<String> streamField, Function onChangeFunction, String label, int numeroCasasDecimais}) {
        var regexp = numeroCasasDecimais == 0 ? r'^(\d+)': r'^(\d+)?\.?\d{0,'+numeroCasasDecimais.toString()+'}';

        return StreamBuilder<String>(
            stream: streamField,
            builder: (context, snapshot) {
              return TextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(regexp)),
                  ],
                  keyboardType: TextInputType.numberWithOptions(decimal: numeroCasasDecimais !=0 ),
                decoration: InputDecoration(
                    labelText: label, errorText: snapshot.error, errorStyle: TextStyle(fontSize: 19, color: kOperacaoVendaColor)),
                onChanged: onChangeFunction,
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.black87,
                ),
              );
            });

  }

  @override
  void dispose(){
    super.dispose();
    _operacaoAtivoBloc.dispose();
  }

}
