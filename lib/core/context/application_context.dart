import 'package:simulador_investimentos/core/dao/ativo_dao.dart';
import 'package:simulador_investimentos/core/dao/ativo_carteira_dao.dart';
import 'package:simulador_investimentos/core/dao/database_helper.dart';
import 'package:simulador_investimentos/core/service/ativo_carteira_service.dart';
import 'package:simulador_investimentos/core/service/ativo_cotacao_service.dart';
import 'package:simulador_investimentos/core/service/ativo_service.dart';
import 'package:simulador_investimentos/core/webservice/cotacao_service.dart';

class ApplicationContext {
  AtivoDao _ativoDao;
  AtivoCarteiraDao _ativoCarteiraDao;
  CotacaoService _cotacaoService;
  AtivoCotacaoService _ativoCotacaoService;
  DatabaseHelper _databaseHelper;
  AtivoService _ativoService;
  AtivoCarteiraService _ativoCarteiraService;

  static ApplicationContext _instance =  ApplicationContext._privateConstructor();

  ApplicationContext._privateConstructor() {
    _databaseHelper = DatabaseHelper();
    _ativoDao = AtivoDao(_databaseHelper);
    _ativoCarteiraDao = AtivoCarteiraDao(_databaseHelper);
    _cotacaoService = CotacaoService(_ativoCarteiraDao);
    _ativoCotacaoService = AtivoCotacaoService(_ativoCarteiraDao, _cotacaoService);
    _ativoService = AtivoService(_ativoDao);
    _ativoCarteiraService = AtivoCarteiraService(_ativoCarteiraDao);
  }

  DatabaseHelper get databaseHelper => _databaseHelper;
  AtivoDao get ativoDao => _ativoDao;
  AtivoCarteiraDao get ativoCarteiraDao => _ativoCarteiraDao;
  AtivoCotacaoService get ativoCotacaoService => _ativoCotacaoService;
  CotacaoService get cotacaoService => _cotacaoService;
  AtivoService get ativoService => _ativoService;
  AtivoCarteiraService get ativoCarteiraService => _ativoCarteiraService;

  static ApplicationContext instance() {
    return _instance;
  }
}
