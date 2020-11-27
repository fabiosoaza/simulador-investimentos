import 'dart:collection';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:simulador_investimentos/core/falha_api_cotacao_exception.dart';
import 'package:simulador_investimentos/core/util/connectivity_checker.dart';

class CotacaoMercadoBitcoinApiClient {
  String _baseUrl;
  Client _httpClient;
  ConnectivityChecker _connectivityChecker;

  CotacaoMercadoBitcoinApiClient(String baseUrl, Client httpClient, ConnectivityChecker connectivityChecker) {
    this._baseUrl = baseUrl;
    this._httpClient = httpClient;
    this._connectivityChecker = connectivityChecker;
  }

  Future<List<Map<String,dynamic>>> buscarCotacoes(String mercado, List<String> tickers) async {
    checkInternetConnection();
    var futures = <Future<Map<String, dynamic>>>[];
    tickers.forEach((ticker) async {
      futures.add(consultarApi(mercado, ticker));
    });
    var cotacoes = await Future.wait(futures);
    return cotacoes;
  }

  Future<Map<String, dynamic>> consultarApi(String mercado, String ticker) async {
    var path = '$_baseUrl/$ticker/ticker';
    var response = await _httpClient.get(path).timeout(Duration(seconds:3));
    if (response.statusCode != 200) {
      throw FalhaApiCotacaoException("Falha ao consultar API. Response[Headers: ${response.headers}, Status: ${response.statusCode}, Body: ${response.body}]");
    }
    dynamic result = jsonDecode(response.body);
    LinkedHashMap<String, dynamic> map = convertMap(result, ticker, mercado);
    return map;
  }

  LinkedHashMap<String, dynamic> convertMap(result, String ticker, String mercado) {
    var mapPrice = LinkedHashMap<String, dynamic>();
    mapPrice['amount'] = '${result["ticker"]["last"]}';
    mapPrice['currency'] = 'BRL';
    
    var map = LinkedHashMap<String, dynamic>();
    map['ticker'] = ticker;
    map['exchange'] = mercado;
    map['lastPrice'] = mapPrice;
    return map;
  }


  void checkInternetConnection(){
    if(!_connectivityChecker.hasConnection){
      throw FalhaApiCotacaoException("Falha ao consultar API. Sem conexão com internet.");
    }
  }

}
