import 'package:http/http.dart';
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
import 'package:simulador_investimentos/core/webservice/cotacao_api_client.dart';
import 'package:simulador_investimentos/core/webservice/cotacao_web_service.dart';

class ApplicationContext {
  DatabaseHelper _databaseHelper;
  AtivoDao _ativoDao;
  AtivoCarteiraDao _ativoCarteiraDao;
  CotacaoRepository _cotacaoRepository;
  AtivoRepository _ativoRepository;
  CarteiraRepository _carteiraRepository;
  AtivoCarteiraRepository _ativoCarteiraRepository;
  CotacaoApiClient _cotacaoApiClient;


  static final String URL_API_COTACOES = "http://rmyk6.mocklab.io";

  static ApplicationContext _instance =  ApplicationContext._privateConstructor();

  ApplicationContext._privateConstructor() {
    _databaseHelper = DatabaseHelper();
    _cotacaoApiClient = CotacaoApiClient(URL_API_COTACOES, _httpClient());
    _ativoDao = AtivoDao(_databaseHelper);
    _ativoCarteiraDao = AtivoCarteiraDao(_databaseHelper);
    _cotacaoRepository = CotacaoWebService(_ativoCarteiraDao,_cotacaoApiClient);
    _carteiraRepository = CarteiraService(_ativoCarteiraDao, _cotacaoRepository);
    _ativoRepository = AtivoService(_ativoDao);
    _ativoCarteiraRepository = AtivoCarteiraService(_ativoCarteiraDao);
  }

  DatabaseHelper get databaseHelper => _databaseHelper;
  CarteiraRepository get carteiraRepository => _carteiraRepository;
  CotacaoRepository get cotacaoRepository => _cotacaoRepository;
  AtivoRepository get ativoRepository => _ativoRepository;
  AtivoCarteiraRepository get ativoCarteiraRepository => _ativoCarteiraRepository;

  static ApplicationContext instance() {
    return _instance;
  }

  static Client _httpClient(){
    return new Client();
  }

 }
