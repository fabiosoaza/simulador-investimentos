import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:simulador_investimentos/core/model/domain/ativo_carteira.dart';
import 'package:simulador_investimentos/core/model/domain/tipo_operacao.dart';
import 'package:simulador_investimentos/core/model/domain/validador_valor.dart';
import 'package:simulador_investimentos/core/model/domain/validador_venda_ativo_carteira.dart';
import 'package:simulador_investimentos/core/model/domain/valor_monetario.dart';
import 'package:simulador_investimentos/core/model/repository/ativo_carteira_repository.dart';
import 'package:simulador_investimentos/core/model/repository/ativo_repository.dart';
import 'package:simulador_investimentos/core/model/repository/carteira_repository.dart';
import 'package:simulador_investimentos/core/util/ativo_utils.dart';
import 'package:simulador_investimentos/core/util/formatador_numeros.dart';

class OperacaoAtivoBloc{

  final _valor = BehaviorSubject<String>();
  final _quantdidade = BehaviorSubject<String>();

  TipoOperacao _tipoOperacao;
  String _ticker;

  CarteiraRepository _carteiraRepository;
  AtivoRepository _ativoRepository;
  AtivoCarteiraRepository _ativoCarteiraRepository;

  OperacaoAtivoBloc(TipoOperacao tipoOperacao, String ticker, CarteiraRepository carteiraRepository, AtivoRepository ativoRepository,  AtivoCarteiraRepository ativoCarteiraRepository){
    this._tipoOperacao = tipoOperacao;
    this._ticker = ticker;
    this._carteiraRepository = carteiraRepository;
    this._ativoRepository = ativoRepository;
   this._ativoCarteiraRepository = ativoCarteiraRepository;
  }

  //Get
  Stream<String> get valor => _valor.stream.transform(_validateValor);
  Stream<String> get quantidade => _quantdidade.stream.transform(_validateQuantidade(_carteiraRepository, _tipoOperacao,_ticker));
  Stream<bool> get productValid => Rx.combineLatest2(valor, quantidade, (valor,quantdidade) => true);

  //Set
  Function(String) get changeValor => _valor.sink.add;
  Function(String) get changeQuantidade => _quantdidade.sink.add;

  final _validateValor = StreamTransformer<String,String>.fromHandlers(
      handleData: (valor,sink){
        if (!ValidadorValor(valor).validar()){
          sink.addError("Informe um preço válido(R\$)");
        } else {
          sink.add(valor);
        }
      }
  );

  static StreamTransformer<String,String> _validateQuantidade(CarteiraRepository carteiraRepository, TipoOperacao tipoOperacao, String ticker){
      return StreamTransformer<String, String>.fromHandlers(
          handleData: (quantidade, sink) async {
            if (!ValidadorValor(quantidade).validar()) {
              sink.addError("Informe a quantidade");
            } else if (tipoOperacao == TipoOperacao.VENDA) {
              var carteira = await carteiraRepository.carregar();
              var validador = ValidadorVendaAtivoCarteira(
                  quantidade, carteira.findAtivoCarteiraByTicker(ticker));
              if (!validador.validar()) {
                sink.addError("Quantidade não disponível");
              } else {
                sink.add(quantidade);
              }
            } else {
              sink.add(quantidade);
            }
          });
  }

  dispose(){
    _valor.close();
    _quantdidade.close();
  }

  Future<void> executarOperacao() async {
    var ativo = await _ativoRepository.findByTicker(_ticker);
    var preco = ValorMonetario.brl(_valor.value);
    var qtd = FormatadorNumeros().stringToDouble(_quantdidade.value, AtivoUtils.getNumeroCasasDecimais(ativo));
    var ativoCarteira = AtivoCarteira.novo(ativo, preco, qtd);
    if (_tipoOperacao == TipoOperacao.COMPRA) {
      return _ativoCarteiraRepository.adicionar(ativoCarteira);
    } else {
      return _ativoCarteiraRepository.remover(ativoCarteira);
    }
  }
}