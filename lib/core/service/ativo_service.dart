import 'package:simulador_investimentos/core/dao/ativo_dao.dart';
import 'package:simulador_investimentos/core/model/domain/ativo.dart';
import 'package:simulador_investimentos/core/model/repository/ativo_repository.dart';

class AtivoService extends AtivoRepository{
  AtivoDao _ativoDao;

  AtivoService(AtivoDao ativoDao){
    this._ativoDao = ativoDao;
  }

  @override
  Future<List<Ativo>> listarPorTipo(String tipo) async {
    return _ativoDao.listarPorTipo(tipo);
  }

  @override
  Future<Ativo> findByTicker(String ticker) {
    return _ativoDao.findByTicker(ticker);
  }

}