
import 'package:simulador_investimentos/core/dao/ativo_carteira_dao.dart';
import 'package:simulador_investimentos/core/model/domain/ativo.dart';
import 'package:simulador_investimentos/core/model/domain/cotacao.dart';
import 'package:simulador_investimentos/core/model/domain/valor_monetario.dart';
import 'package:simulador_investimentos/core/model/repository/cotacao_repository.dart';
import 'package:simulador_investimentos/core/webservice/cotacao_mercado_bitcoin_api_client.dart';
import 'package:simulador_investimentos/core/webservice/cotacao_yahoo_finance_api_client.dart';

class CotacaoWebService extends CotacaoRepository{

  static final Map<String, Cotacao> _cacheCotacoes = Map<String, Cotacao>();
  AtivoCarteiraDao _ativoCarteiraDao;
  CotacaoYahooFinanceApiClient _cotacaoYahooFinanceApiClient;
  CotacaoMercadoBitcoinApiClient _cotacaoMercadoBitcoinApiClient;

  CotacaoWebService(AtivoCarteiraDao ativoCarteiraDao, CotacaoYahooFinanceApiClient cotacaoApiClient, CotacaoMercadoBitcoinApiClient cotacaoMercadoBitcoinApiClient){
      this._ativoCarteiraDao = ativoCarteiraDao;
      this._cotacaoYahooFinanceApiClient = cotacaoApiClient;
      this._cotacaoMercadoBitcoinApiClient = cotacaoMercadoBitcoinApiClient;
  }

  @override
  Future<Cotacao> buscarCotacao(Ativo ativo) async{
    var cotacoes = await buscarCotacoes([ativo]);
    return cotacoes.isNotEmpty ? cotacoes[0] : null;
  }

  Future<List<Cotacao>> buscarCotacoes(List<Ativo> ativos) async{
    Map<String, List<String>> tickersPorMercado = _separarTickersPorMercado(ativos);
    return  _pesquisarCotacoes(tickersPorMercado, ativos);
  }

  Future<List<Cotacao>> _pesquisarCotacoes(Map<String, List<String>> tickersPorMercado, List<Ativo> ativos) async {
    List<Future<List<Cotacao>>> futures = [];

    tickersPorMercado.entries.forEach((element) async {
      var mercado = element.key;
      var tickers = element.value;
      var future = _buscarCotacoesApi(mercado, tickers, ativos);
      futures.add(future);
    });
    
    var futureResults = await Future.wait(futures);
    var cotacoes = futureResults.expand((i) => i).toList();
    return cotacoes;
  }

  Future<List<Cotacao>> _buscarCotacoesApi(String mercado, List<String> tickers, List<Ativo> ativos) async {
    var buscarCotacoes = mercado == 'B3' ?  _cotacaoYahooFinanceApiClient.buscarCotacoes(mercado, tickers) :  _cotacaoMercadoBitcoinApiClient.buscarCotacoes(mercado, tickers);
    var cotacoesMercado = await buscarCotacoes;
    var cotacoes = List<Cotacao>();
    cotacoesMercado.forEach((result) {
      var ativo = ativos.firstWhere((element) => element.ticker == result["ticker"] && element.mercado ==result["exchange"]);
      if(ativo!=null){
        var cotacao = Cotacao(ativo, ValorMonetario.brl(result['lastPrice']['amount']));
        cotacoes.add(cotacao);
      }
    });
    return cotacoes;
  }

  Map<String, List<String>> _separarTickersPorMercado(List<Ativo> ativos) {
    
    Map<String, List<String>> tickersPorMercado =  Map<String, List<String>>();
    
    ativos.forEach((ativo) {
      var list = tickersPorMercado[ativo.mercado] == null ? <String>[] : tickersPorMercado[ativo.mercado];
      list.add(ativo.ticker);
      tickersPorMercado[ativo.mercado] = list;
    });
    
    return tickersPorMercado;
  }



}
