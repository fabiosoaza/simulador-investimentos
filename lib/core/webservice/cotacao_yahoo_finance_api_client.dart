import 'dart:collection';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:simulador_investimentos/core/falha_api_cotacao_exception.dart';
import 'package:simulador_investimentos/core/util/connectivity_checker.dart';

class CotacaoYahooFinanceApiClient {
  String _baseUrl;
  Client _httpClient;
  ConnectivityChecker _connectivityChecker;

  CotacaoYahooFinanceApiClient(String baseUrl, Client httpClient, ConnectivityChecker connectivityChecker) {
    this._baseUrl = baseUrl;
    this._httpClient = httpClient;
    this._connectivityChecker = connectivityChecker;
  }

  Future<List<Map<String,dynamic>>> buscarCotacoes(String mercado, List<String> tickers) async {
    checkInternetConnection();
    var tickersFormatados= _getTickersFormatados(tickers);
    var path = '$_baseUrl/v7/finance/quote?symbols=$tickersFormatados';
    var response = await _httpClient.get(path).timeout(Duration(seconds:5));
    if (response.statusCode != 200) {
      throw FalhaApiCotacaoException("Falha ao consultar API. Response[Headers: ${response.headers}, Status: ${response.statusCode}, Body: ${response.body}]");
    }
    List<dynamic> results = jsonDecode(response.body)['quoteResponse']['result'];
    var list = results.map((result) {
      var map =_convertMap(result);
      return map;
    }).toList() ;
    return list;
  }

  Map<String, dynamic> _convertMap(dynamic result) {
    var mapPrice = LinkedHashMap<String, dynamic>();
    mapPrice['amount'] = '${result["regularMarketPrice"]}';
    mapPrice['currency'] = 'BRL';
    
    var map = LinkedHashMap<String, dynamic>();
    map['ticker'] = result['symbol'].toString().replaceAll('.SA', '');
    map['exchange'] = 'B3';
    map['lastPrice'] = mapPrice;
    return map;
  }

  String _getTickersFormatados(List<String> tickers) {
    return tickers.map((ticker) => '$ticker.SA').toList().join(",");
  }

  void checkInternetConnection(){
    if(!_connectivityChecker.hasConnection){
      throw FalhaApiCotacaoException("Falha ao consultar API. Sem conexão com internet.");
    }
  }

}
