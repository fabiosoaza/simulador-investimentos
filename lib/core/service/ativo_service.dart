import 'package:simulador_investimentos/core/dao/ativo_dao.dart';
import 'package:simulador_investimentos/core/model/ativo.dart';

class AtivoService{
  AtivoDao _ativoDao;

  AtivoService(AtivoDao ativoDao){
    this._ativoDao = ativoDao;
  }

  Future<List<Ativo>> listarPorTipo(String tipo) async {
    return _ativoDao.listarPorTipo(tipo);
  }

}