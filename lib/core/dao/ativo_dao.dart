import 'package:simulador_investimentos/core/model/domain/ativo.dart';

import 'database_helper.dart';

class AtivoDao {

  static const NOME_TABELA = "ativo";
  static const COLUNA_ID = "id";
  static const COLUNA_TICKER = "ticker";
  static const COLUNA_TIPO = "tipo";
  static const COLUNA_NOME = "nome";
  static const COLUNA_MERCADO = "mercado";
  static const COLUNA_LOGO = "logo";


  DatabaseHelper _databaseHelper;

  AtivoDao(DatabaseHelper databaseHelper) {
    this._databaseHelper = databaseHelper;
  }

  Future<int> totalAtivos() async {
    return _databaseHelper.queryRowCount(NOME_TABELA);
  }

  Future<int> totalAtivosPorTipo(String tipo) async {
    return _databaseHelper.queryRowCountByFilter(NOME_TABELA, {COLUNA_TIPO: tipo});
  }

  Future<List<Ativo>> listarPorTipo(String tipo) async {
    var ativos = List<Ativo>();
    final rows =
        await _databaseHelper.queryAllByFilter(NOME_TABELA, {COLUNA_TIPO: tipo});
    rows.forEach((linha) {
      var ativo = Ativo(
          linha[COLUNA_ID], linha[COLUNA_TICKER], linha[COLUNA_TIPO], linha[COLUNA_NOME], linha[COLUNA_MERCADO], linha[COLUNA_LOGO]);
      ativos.add(ativo);
    });
    return ativos;
  }

  Future<List<Ativo>> listarTodos() async {
    var ativos = List<Ativo>();
    final rows =
    await _databaseHelper.queryAll(NOME_TABELA);
    rows.forEach((linha) {
      var ativo = Ativo(
          linha[COLUNA_ID], linha[COLUNA_TICKER], linha[COLUNA_TIPO], linha[COLUNA_NOME], linha[COLUNA_MERCADO], linha[COLUNA_LOGO]);
      ativos.add(ativo);
    });
    return ativos;
  }

}
