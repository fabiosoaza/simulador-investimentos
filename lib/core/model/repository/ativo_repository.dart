import '../domain/ativo.dart';

abstract class AtivoRepository{
  Future<List<Ativo>> listarPorTipo(String tipo) ;
  Future<Ativo> findByTicker(String ticker);
}