import 'package:simulador_investimentos/core/dao/ativo_carteira_dao.dart';
import 'package:simulador_investimentos/core/model/domain/ativo_carteira_cotacao.dart';
import 'package:simulador_investimentos/core/model/domain/carteira.dart';
import 'package:simulador_investimentos/core/model/repository/carteira_repository.dart';
import 'package:simulador_investimentos/core/webservice/cotacao_web_service.dart';

class CarteiraService extends CarteiraRepository {
  AtivoCarteiraDao _ativoCarteiraDao;
  CotacaoWebService _cotacaoService;

  CarteiraService(
      AtivoCarteiraDao ativoCarteiraDao, CotacaoWebService cotacaoService) {
    this._ativoCarteiraDao = ativoCarteiraDao;
    this._cotacaoService = cotacaoService;
  }

  @override
  Future<Carteira> carregar() async {
    var ativosCarteiraCotacao = List<AtivoCarteiraCotacao>();
    var ativosCarteira = await _ativoCarteiraDao.listarAtivosCarteira();
    var ativos = ativosCarteira.map((ativoCarteira) => ativoCarteira.ativo).toList();
    var cotacoes =  await _cotacaoService.buscarCotacoes(ativos);
    cotacoes.forEach((cotacao) {
      var ativoCarteira = ativosCarteira.firstWhere((element) => element.ativo.ticker == cotacao.ativo.ticker && element.ativo.mercado == cotacao.ativo.mercado);
      if(ativoCarteira!=null){
        ativosCarteiraCotacao.add(AtivoCarteiraCotacao(ativoCarteira, cotacao));
      }
    });
    var carteira = Carteira(ativosCarteiraCotacao);
    return carteira;
  }
}
