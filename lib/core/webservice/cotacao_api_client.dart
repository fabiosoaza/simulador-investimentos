import 'dart:convert';

import 'package:http/http.dart';
import 'package:simulador_investimentos/core/falha_api_cotacao_exception.dart';
import 'package:simulador_investimentos/core/util/connectivity_checker.dart';

class CotacaoApiClient {
  String _baseUrl;
  Client _httpClient;
  ConnectivityChecker _connectivityChecker;

  CotacaoApiClient(String baseUrl, Client httpClient, ConnectivityChecker connectivityChecker) {
    this._baseUrl = baseUrl;
    this._httpClient = httpClient;
    this._connectivityChecker = connectivityChecker;
  }

  Future<List<dynamic>> buscarCotacoes(String mercado, List<String> tickers) async {
    checkInternetConnection();
    var path = '$_baseUrl/api/v1/quotes/exchange/$mercado/tickers/${tickers.join(",")}';
    var response = await _httpClient.get(path);
    if (response.statusCode != 200) {
      throw FalhaApiCotacaoException("Falha ao consultar API. Response[Headers: ${response.headers}, Status: ${response.statusCode}, Body: ${response.body}]");
    }
    List<dynamic> results = jsonDecode(response.body);
    return results;
  }

  void checkInternetConnection(){
    if(!_connectivityChecker.hasConnection){
      throw FalhaApiCotacaoException("Falha ao consultar API. Sem conexão com internet.");
    }
  }

}
