import 'dart:math';

import 'package:simulador_investimentos/core/dao/ativo_carteira_dao.dart';
import 'package:simulador_investimentos/core/model/domain/ativo.dart';
import 'package:simulador_investimentos/core/model/domain/ativo_carteira.dart';
import 'package:simulador_investimentos/core/model/domain/cotacao.dart';
import 'package:simulador_investimentos/core/model/repository/cotacao_repository.dart';
import 'package:simulador_investimentos/core/model/domain/ativo_constants.dart';
import 'package:simulador_investimentos/core/model/domain/valor_monetario.dart';

class CotacaoWebService extends CotacaoRepository{

  static final Map<String, Cotacao> _cacheCotacoes = Map<String, Cotacao>();
  AtivoCarteiraDao _ativoCarteiraDao;

  CotacaoWebService(AtivoCarteiraDao ativoCarteiraDao){
      this._ativoCarteiraDao = ativoCarteiraDao;
      carregarCotacoes();
  }

  @override
  Cotacao buscarCotacao(Ativo ativo){
    return _cacheCotacoes[ativo.ticker];
  }

  @override
  Future<void> carregarCotacoes() async {
    var listarTodos = await _ativoCarteiraDao.listarAtivosCarteira();
    listarTodos.forEach((ativoCarteira) {
      var cotacao = _gerarCotacao(ativoCarteira);
      _cacheCotacoes[ativoCarteira.ativo.ticker] = cotacao;
    });
  }

  Cotacao _gerarCotacao(AtivoCarteira ativoCarteira) {
    //calcula um valor randomico para cotacao
    //no futuro fazer chamada ao webservice
    ValorMonetario valorCotacao = _gerarCotacaoRandomica(ativoCarteira);
    var cotacao = Cotacao(ativoCarteira.ativo, valorCotacao);
    return cotacao;
  }

  ValorMonetario _gerarCotacaoRandomica(AtivoCarteira ativoCarteira) {
    Random random = new Random();
    int min = -6;
    int max = 6;
    int rand = random.nextInt(max - min) + min;
    var percentagem = ativoCarteira.precoMedio.calcularPorcentagem(rand.toDouble());
    var valorCotacao = ativoCarteira.precoMedio.somar(percentagem);
    return valorCotacao.arredondar(ativoCarteira.ativo.tipo == AtivoConstants.TIPO_ACAO ? 2 : 4);
  }



}
