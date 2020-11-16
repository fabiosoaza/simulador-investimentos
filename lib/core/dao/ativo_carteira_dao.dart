import 'package:simulador_investimentos/core/dao/ativo_dao.dart';
import 'package:simulador_investimentos/core/model/domain/ativo.dart';
import 'package:simulador_investimentos/core/model/domain/ativo_carteira.dart';
import 'package:simulador_investimentos/core/model/domain/valor_monetario.dart';

import 'database_helper.dart';

class AtivoCarteiraDao {

  static const NOME_TABELA = "carteira";
  static const COLUNA_ID = "id";
  static const COLUNA_ATIVO_ID = "ativo_id";
  static const COLUNA_QUANTIDADE = "quantidade";
  static const COLUNA_PRECO_MEDIO = "preco_medio";

  DatabaseHelper _databaseHelper;

  AtivoCarteiraDao(DatabaseHelper databaseHelper) {
    this._databaseHelper = databaseHelper;
  }

  Future<int> inserir(AtivoCarteira ativoCarteira){
    return _databaseHelper.insert(NOME_TABELA, {
      COLUNA_ATIVO_ID: ativoCarteira.ativo.id,
      COLUNA_QUANTIDADE: ativoCarteira.quantidade,
      COLUNA_PRECO_MEDIO: ativoCarteira.precoMedio.valorAsDouble()
    }
      );
  }

  Future<int> atualizar(AtivoCarteira ativoCarteira){
    var values = {
      COLUNA_QUANTIDADE: ativoCarteira.quantidade,
      COLUNA_PRECO_MEDIO: ativoCarteira.precoMedio.valorAsDouble()
    };
    return _databaseHelper.update(NOME_TABELA, COLUNA_ID, ativoCarteira.id, values );
  }

  Future<int> excluir(AtivoCarteira ativoCarteira){
      return _databaseHelper.delete(NOME_TABELA, COLUNA_ID, ativoCarteira.id );
  }

  Future<List<AtivoCarteira>> listarAtivosCarteira() async {
    var ativos = List<AtivoCarteira>();
    var sql = "SELECT c.$COLUNA_ID, c.$COLUNA_ATIVO_ID, c.$COLUNA_QUANTIDADE, c.$COLUNA_PRECO_MEDIO, a.${AtivoDao.COLUNA_NOME}, a.${AtivoDao.COLUNA_TICKER}, a.${AtivoDao.COLUNA_TIPO} , a.${AtivoDao.COLUNA_MERCADO}, a.${AtivoDao.COLUNA_LOGO} FROM $NOME_TABELA c INNER JOIN ${AtivoDao.NOME_TABELA} a"
        +" ON a.${AtivoDao.COLUNA_ID} = c.$COLUNA_ATIVO_ID ";
    final rows =    await _databaseHelper.query(sql);
    rows.forEach((linha) {
      var ativo = Ativo(
          linha[COLUNA_ATIVO_ID], linha[AtivoDao.COLUNA_TICKER], linha[AtivoDao.COLUNA_TIPO], linha[AtivoDao.COLUNA_NOME], linha[AtivoDao.COLUNA_MERCADO], linha[AtivoDao.COLUNA_LOGO]);
      var valor = ValorMonetario.brl(linha[COLUNA_PRECO_MEDIO].toString());
      var ativoCarteira = AtivoCarteira(linha[COLUNA_ID], ativo, valor, linha[COLUNA_QUANTIDADE]);
      ativos.add(ativoCarteira);
    });
    return ativos;
  }

  Future<AtivoCarteira> carregarAtivoCarteiraPorCodigo(String ticker) async {
    var sql = "SELECT  c.$COLUNA_ID, c.$COLUNA_ATIVO_ID, c.$COLUNA_QUANTIDADE, c.$COLUNA_PRECO_MEDIO, a.${AtivoDao.COLUNA_NOME}, a.${AtivoDao.COLUNA_TICKER}, a.${AtivoDao.COLUNA_TIPO} , a.${AtivoDao.COLUNA_MERCADO}, a.${AtivoDao.COLUNA_LOGO}  FROM $NOME_TABELA c INNER JOIN ${AtivoDao.NOME_TABELA} a"
        +" ON a.${AtivoDao.COLUNA_ID} = c.$COLUNA_ATIVO_ID "
            " WHERE a.${AtivoDao.COLUNA_TICKER} = ?";
    final rows =    await _databaseHelper.query(sql, [ticker]);
    if(rows.isNotEmpty){
      var linha = rows[0];
      var ativo = Ativo(
          linha[COLUNA_ATIVO_ID], linha[AtivoDao.COLUNA_TICKER], linha[AtivoDao.COLUNA_TIPO], linha[AtivoDao.COLUNA_NOME], linha[AtivoDao.COLUNA_MERCADO], linha[AtivoDao.COLUNA_LOGO]);
      var valor = ValorMonetario.brl(linha[COLUNA_PRECO_MEDIO].toString());
      var ativoCarteira = AtivoCarteira(linha[COLUNA_ID], ativo, valor, linha[COLUNA_QUANTIDADE]);
      return ativoCarteira;
    }
    return null;
  }

  Future<int> totalAtivos() async {
    return _databaseHelper.queryRowCount(NOME_TABELA);
  }

}
