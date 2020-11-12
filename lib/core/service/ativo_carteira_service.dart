import 'package:simulador_investimentos/core/dao/ativo_carteira_dao.dart';
import 'package:simulador_investimentos/core/model/domain/ativo_carteira.dart';
import 'package:simulador_investimentos/core/model/repository/ativo_carteira_repository.dart';

class AtivoCarteiraService extends AtivoCarteiraRepository{
  AtivoCarteiraDao _ativoCarteiraDao;

  AtivoCarteiraService(AtivoCarteiraDao ativoCarteiraDao) {
    this._ativoCarteiraDao = ativoCarteiraDao;
  }

  @override
  Future<AtivoCarteira> carregarPorCodigo(String ticker) async {
    return _ativoCarteiraDao.carregarAtivoCarteiraPorCodigo(ticker);
  }

  @override
  Future<void> adicionar(AtivoCarteira ativoCarteira) async {
    var ativoCarteiraBase = await _ativoCarteiraDao.carregarAtivoCarteiraPorCodigo(ativoCarteira.ativo.ticker);
    if (ativoCarteiraBase != null) {
      AtivoCarteira ativoCarteiraAtualizar = _somarValores(ativoCarteira, ativoCarteiraBase);
      return await _ativoCarteiraDao.atualizar(ativoCarteiraAtualizar);
    } else {
      return await _ativoCarteiraDao.inserir(ativoCarteira);
    }
  }

  @override
  Future<void> remover(AtivoCarteira ativoCarteira) async {
    var ativoCarteiraBase = await _ativoCarteiraDao.carregarAtivoCarteiraPorCodigo(ativoCarteira.ativo.ticker);
    if (ativoCarteiraBase != null) {
      if((ativoCarteiraBase.quantidade - ativoCarteira.quantidade) == 0){
        return await _ativoCarteiraDao.excluir(ativoCarteiraBase);
      }
      else{
        AtivoCarteira ativoCarteiraAtualizar = _subtrairValores(ativoCarteira, ativoCarteiraBase);
        return await _ativoCarteiraDao.atualizar(ativoCarteiraAtualizar);
      }

    }
  }

  AtivoCarteira _somarValores(AtivoCarteira ativoCarteira, AtivoCarteira ativoCarteiraPorCodigo) {
    var novoValorTotal = ativoCarteira.calcularValorTotal().somar(ativoCarteiraPorCodigo.calcularValorTotal());
    var novaQuantidade = ativoCarteira.quantidade + ativoCarteiraPorCodigo.quantidade;
    var novoPrecoMedio = novoValorTotal.dividir(novaQuantidade);
    var ativoCarteiraAtualizar = AtivoCarteira(ativoCarteiraPorCodigo.id, ativoCarteiraPorCodigo.ativo, novoPrecoMedio, novaQuantidade);
    return ativoCarteiraAtualizar;
  }

  AtivoCarteira _subtrairValores(AtivoCarteira ativoCarteira, AtivoCarteira ativoCarteiraBase) {
    var novoValorTotal = ativoCarteiraBase.calcularValorTotal().somar(ativoCarteira.calcularValorTotal());
    var novaQuantidade = ativoCarteiraBase.quantidade - ativoCarteira.quantidade;
    var novoPrecoMedio = novoValorTotal.dividir(novaQuantidade);
    var ativoCarteiraAtualizar = AtivoCarteira(ativoCarteiraBase.id, ativoCarteiraBase.ativo, novoPrecoMedio, novaQuantidade);
    return ativoCarteiraAtualizar;
  }
}
