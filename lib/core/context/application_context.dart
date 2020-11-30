
import 'package:http/http.dart';
import 'package:simulador_investimentos/core/dao/ativo_carteira_dao.dart';
import 'package:simulador_investimentos/core/dao/ativo_dao.dart';
import 'package:simulador_investimentos/core/dao/database_helper.dart';
import 'package:simulador_investimentos/core/model/repository/ativo_carteira_repository.dart';
import 'package:simulador_investimentos/core/model/repository/ativo_repository.dart';
import 'package:simulador_investimentos/core/model/repository/carteira_repository.dart';
import 'package:simulador_investimentos/core/model/repository/cotacao_repository.dart';
import 'package:simulador_investimentos/core/service/ativo_carteira_service.dart';
import 'package:simulador_investimentos/core/service/ativo_service.dart';
import 'package:simulador_investimentos/core/service/carteira_service.dart';
import 'package:simulador_investimentos/core/util/connectivity_checker.dart';
import 'package:simulador_investimentos/core/webservice/cotacao_mercado_bitcoin_api_client.dart';
import 'package:simulador_investimentos/core/webservice/cotacao_web_service.dart';
import 'package:simulador_investimentos/core/webservice/cotacao_yahoo_finance_api_client.dart';

class ApplicationContext {
  DatabaseHelper _databaseHelper;
  AtivoDao _ativoDao;
  AtivoCarteiraDao _ativoCarteiraDao;
  CotacaoRepository _cotacaoRepository;
  AtivoRepository _ativoRepository;
  CarteiraRepository _carteiraRepository;
  AtivoCarteiraRepository _ativoCarteiraRepository;
  CotacaoMercadoBitcoinApiClient _cotacaoMercadoBitcoinApiClient;
  CotacaoYahooFinanceApiClient _cotacaoYahooFinanceApiClient;
  ConnectivityChecker _connectivityChecker;


  static final String URL_API_COTACOES_MERCADO_BITCOIN = "https://www.mercadobitcoin.net/api";
  static final String URL_API_COTACOES_YAHOO_FINANCE = "https://query2.finance.yahoo.com";

  static ApplicationContext _instance =  ApplicationContext._privateConstructor();

  ApplicationContext._privateConstructor() {
    var clientHttp = _httpClient();
    _databaseHelper = DatabaseHelper();
    _connectivityChecker = _getInitializedConnectivityChecker();
    _cotacaoMercadoBitcoinApiClient = CotacaoMercadoBitcoinApiClient(URL_API_COTACOES_MERCADO_BITCOIN, clientHttp, connectivityChecker);
    _cotacaoYahooFinanceApiClient = CotacaoYahooFinanceApiClient(URL_API_COTACOES_YAHOO_FINANCE, clientHttp, connectivityChecker);
    _ativoDao = AtivoDao(_databaseHelper);
    _ativoCarteiraDao = AtivoCarteiraDao(_databaseHelper);
    _cotacaoRepository = CotacaoWebService(_cotacaoYahooFinanceApiClient, _cotacaoMercadoBitcoinApiClient);
    _carteiraRepository = CarteiraService(_ativoCarteiraDao, _cotacaoRepository);
    _ativoRepository = AtivoService(_ativoDao);
    _ativoCarteiraRepository = AtivoCarteiraService(_ativoCarteiraDao);
  }

  DatabaseHelper get databaseHelper => _databaseHelper;
  CarteiraRepository get carteiraRepository => _carteiraRepository;
  CotacaoRepository get cotacaoRepository => _cotacaoRepository;
  AtivoRepository get ativoRepository => _ativoRepository;
  AtivoCarteiraRepository get ativoCarteiraRepository => _ativoCarteiraRepository;
  ConnectivityChecker get connectivityChecker => _connectivityChecker;

  static ApplicationContext instance() {
    return _instance;
  }

  static Client _httpClient(){
    var client = Client();
    return client;
  }

  ConnectivityChecker _getInitializedConnectivityChecker() {
    if(_connectivityChecker == null){
      var connection = ConnectivityChecker.getInstance();
      connection.initialize();
      return connection;
    }
    return _connectivityChecker;
  }


}
