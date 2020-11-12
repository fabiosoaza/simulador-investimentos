import '../domain/ativo_carteira.dart';

abstract class AtivoCarteiraRepository{

  Future<AtivoCarteira> carregarPorCodigo(String ticker);
  Future<void> adicionar(AtivoCarteira ativoCarteira) ;
  Future<void> remover(AtivoCarteira ativoCarteira);

}