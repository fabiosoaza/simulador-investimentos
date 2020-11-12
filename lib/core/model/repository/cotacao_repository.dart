import '../domain/ativo.dart';
import '../domain/cotacao.dart';

abstract class CotacaoRepository{
  Cotacao buscarCotacao(Ativo ativo);
  Future<void> carregarCotacoes();

}