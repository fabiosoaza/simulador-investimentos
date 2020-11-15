import 'dart:convert';

import 'package:http/http.dart';

class CotacaoApiClient {
  String _baseUrl;
  Client _httpClient;

  CotacaoApiClient(String baseUrl, Client httpClient) {
    this._baseUrl = baseUrl;
    this._httpClient = httpClient;
  }

  Future<List<dynamic>> buscarCotacoes(String mercado, List<String> tickers) async {
    var path = '$_baseUrl/api/v1/quotes/exchange/$mercado/tickers/${tickers.join(",")}';
    var response = await _httpClient.get(path);
    if (response.statusCode != 200) {
      throw Exception("Falha ao consultar API");
    }
    List<dynamic> results = jsonDecode(response.body);
    return results;
  }
}
