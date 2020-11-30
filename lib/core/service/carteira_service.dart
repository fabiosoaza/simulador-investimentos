import 'package:simulador_investimentos/core/dao/ativo_carteira_dao.dart';
import 'package:simulador_investimentos/core/model/domain/ativo_carteira.dart';
import 'package:simulador_investimentos/core/model/domain/ativo_carteira_cotacao.dart';
import 'package:simulador_investimentos/core/model/domain/carteira.dart';
import 'package:simulador_investimentos/core/model/domain/cotacao.dart';
import 'package:simulador_investimentos/core/model/repository/carteira_repository.dart';
import 'package:simulador_investimentos/core/model/repository/cotacao_repository.dart';

class CarteiraService extends CarteiraRepository {
  AtivoCarteiraDao _ativoCarteiraDao;
  CotacaoRepository _cotacaoService;

  CarteiraService(
      AtivoCarteiraDao ativoCarteiraDao, CotacaoRepository cotacaoService) {
    this._ativoCarteiraDao = ativoCarteiraDao;
    this._cotacaoService = cotacaoService;
  }

  @override
  Future<Carteira> carregar() async {
    var ativosCarteiraCotacao = List<AtivoCarteiraCotacao>();
    var ativosCarteira = await _ativoCarteiraDao.listarAtivosCarteira();
    List<Cotacao> cotacoes = await _cotacoes(ativosCarteira);
    cotacoes.forEach((cotacao) {
      var ativoCarteira = ativosCarteira.firstWhere((element) => element.ativo.ticker == cotacao.ativo.ticker && element.ativo.mercado == cotacao.ativo.mercado);
      if(ativoCarteira!=null){
        ativosCarteiraCotacao.add(AtivoCarteiraCotacao(ativoCarteira, cotacao));
      }
    });
    var carteira = Carteira(ativosCarteiraCotacao);
    return carteira;
  }

  Future<List<Cotacao>> _cotacoes(List<AtivoCarteira> ativosCarteira) async {
    var ativos = ativosCarteira.map((ativoCarteira) => ativoCarteira.ativo).toList();
    try {
      var cotacoes = await _cotacaoService.buscarCotacoes(ativos);
      return cotacoes;
    }catch(ex){
      print(ex);
      return ativosCarteira.map((ativoCarteira) => Cotacao(ativoCarteira.ativo, ativoCarteira.precoMedio)).toList();
    }
  }
}
