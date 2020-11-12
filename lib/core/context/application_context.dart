import 'package:simulador_investimentos/core/dao/ativo_dao.dart';
import 'package:simulador_investimentos/core/dao/ativo_carteira_dao.dart';
import 'package:simulador_investimentos/core/dao/database_helper.dart';
import 'package:simulador_investimentos/core/model/repository/ativo_carteira_repository.dart';
import 'package:simulador_investimentos/core/model/repository/carteira_repository.dart';
import 'package:simulador_investimentos/core/model/repository/ativo_repository.dart';
import 'package:simulador_investimentos/core/model/repository/cotacao_repository.dart';
import 'package:simulador_investimentos/core/service/ativo_carteira_service.dart';
import 'package:simulador_investimentos/core/service/carteira_service.dart';
import 'package:simulador_investimentos/core/service/ativo_service.dart';
import 'package:simulador_investimentos/core/webservice/cotacao_web_service.dart';

class ApplicationContext {
  DatabaseHelper _databaseHelper;
  AtivoDao _ativoDao;
  AtivoCarteiraDao _ativoCarteiraDao;
  CotacaoRepository _cotacaoRepository;
  AtivoRepository _ativoRepository;
  CarteiraRepository _ativoCotacaoRepository;
  AtivoCarteiraRepository _ativoCarteiraRepository;

  static ApplicationContext _instance =  ApplicationContext._privateConstructor();

  ApplicationContext._privateConstructor() {
    _databaseHelper = DatabaseHelper();
    _ativoDao = AtivoDao(_databaseHelper);
    _ativoCarteiraDao = AtivoCarteiraDao(_databaseHelper);
    _cotacaoRepository = CotacaoWebService(_ativoCarteiraDao);
    _ativoCotacaoRepository = CarteiraService(_ativoCarteiraDao, _cotacaoRepository);
    _ativoRepository = AtivoService(_ativoDao);
    _ativoCarteiraRepository = AtivoCarteiraService(_ativoCarteiraDao);
  }

  DatabaseHelper get databaseHelper => _databaseHelper;
  CarteiraRepository get ativoCotacaoRepository => _ativoCotacaoRepository;
  CotacaoRepository get cotacaoRepository => _cotacaoRepository;
  AtivoRepository get ativoRepository => _ativoRepository;
  AtivoCarteiraRepository get ativoCarteiraRepository => _ativoCarteiraRepository;

  static ApplicationContext instance() {
    return _instance;
  }
}
