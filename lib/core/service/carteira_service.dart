
import 'package:simulador_investimentos/core/dao/ativo_carteira_dao.dart';
import 'package:simulador_investimentos/core/model/domain/ativo_carteira_cotacao.dart';
import 'package:simulador_investimentos/core/model/domain/carteira.dart';
import 'package:simulador_investimentos/core/model/repository/carteira_repository.dart';
import 'package:simulador_investimentos/core/webservice/cotacao_web_service.dart';

class CarteiraService extends CarteiraRepository{

  AtivoCarteiraDao _ativoCarteiraDao;
  CotacaoWebService _cotacaoService;

  CarteiraService(
      AtivoCarteiraDao ativoCarteiraDao, CotacaoWebService cotacaoService) {
    this._ativoCarteiraDao = ativoCarteiraDao;
    this._cotacaoService = cotacaoService;
  }

  @override
  Future<Carteira> carregar() async {
    return _ativoCarteiraDao.listarAtivosCarteira().then((ativos) {
      var ativosCarteiraCotacoes = List<AtivoCarteiraCotacao>();
      ativos.forEach((ativoCarteira) {
        var cotacao = _cotacaoService.buscarCotacao(ativoCarteira.ativo);
        ativosCarteiraCotacoes.add(AtivoCarteiraCotacao(ativoCarteira, cotacao));
      });
      var carteira = Carteira(ativosCarteiraCotacoes);
      return carteira;
    });

  }




}
