import 'dart:math';

import 'package:simulador_investimentos/core/dao/ativo_carteira_dao.dart';
import 'package:simulador_investimentos/core/model/ativo_carteira.dart';
import 'package:simulador_investimentos/core/model/ativo_carteira_cotacao.dart';
import 'package:simulador_investimentos/core/model/carteira.dart';
import 'package:simulador_investimentos/core/model/cotacao.dart';
import 'package:simulador_investimentos/core/model/tipo_ativo.dart';
import 'package:simulador_investimentos/core/model/valor_monetario.dart';
import 'package:simulador_investimentos/core/webservice/cotacao_service.dart';

class AtivoCotacaoService {

  AtivoCarteiraDao _ativoCarteiraDao;
  CotacaoService _cotacaoService;

  AtivoCotacaoService(
      AtivoCarteiraDao ativoCarteiraDao, CotacaoService cotacaoService) {
    this._ativoCarteiraDao = ativoCarteiraDao;
    this._cotacaoService = cotacaoService;
  }

  Future<Carteira> listarAtivosCarteira() async {
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
