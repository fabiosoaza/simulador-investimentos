import '../domain/ativo.dart';
import '../domain/cotacao.dart';

abstract class CotacaoRepository{
  Future<Cotacao> buscarCotacao(Ativo ativo);
  Future<List<Cotacao>> buscarCotacoes(List<Ativo> ativo);

}