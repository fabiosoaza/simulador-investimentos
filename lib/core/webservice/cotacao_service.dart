import 'dart:math';

import 'package:simulador_investimentos/core/dao/ativo_carteira_dao.dart';
import 'package:simulador_investimentos/core/dao/ativo_dao.dart';
import 'package:simulador_investimentos/core/model/ativo.dart';
import 'package:simulador_investimentos/core/model/ativo_carteira.dart';
import 'package:simulador_investimentos/core/model/cotacao.dart';
import 'package:simulador_investimentos/core/model/tipo_ativo.dart';
import 'package:simulador_investimentos/core/model/valor_monetario.dart';

class CotacaoService{

  static final Map<String, Cotacao> _cacheCotacoes = Map<String, Cotacao>();
  AtivoCarteiraDao _ativoCarteiraDao;

  CotacaoService(AtivoCarteiraDao ativoCarteiraDao){
      this._ativoCarteiraDao = ativoCarteiraDao;
      carregarCotacoes();
  }

  Cotacao buscarCotacao(Ativo ativo){
    return _cacheCotacoes[ativo.ticker];
  }

  Future<void> carregarCotacoes() async {
    var listarTodos = await _ativoCarteiraDao.listarAtivosCarteira();
    listarTodos.forEach((ativoCarteira) {
      var cotacao = gerarCotacao(ativoCarteira);
      _cacheCotacoes[ativoCarteira.ativo.ticker] = cotacao;
    });
  }

  Cotacao gerarCotacao(AtivoCarteira ativoCarteira) {
    //calcula um valor randomico para cotacao
    //no futuro fazer chamada ao webservice
    ValorMonetario valorCotacao = gerarCotacaoRandomica(ativoCarteira);
    var cotacao = Cotacao(ativoCarteira.ativo, valorCotacao);
    return cotacao;
  }

  ValorMonetario gerarCotacaoRandomica(AtivoCarteira ativoCarteira) {
    Random random = new Random();
    int min = -6;
    int max = 6;
    int rand = random.nextInt(max - min) + min;
    var percentagem = ativoCarteira.precoMedio.calcularPorcentagem(rand.toDouble());
    var valorCotacao = ativoCarteira.precoMedio.somar(percentagem);
    return valorCotacao.arredondar(ativoCarteira.ativo.tipo == TipoAtivo.ACAO ? 2 : 4);
  }



}
