import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'package:simulador_investimentos/core/dao/ativo_dao.dart';
import 'package:simulador_investimentos/core/dao/ativo_carteira_dao.dart';
import 'package:simulador_investimentos/core/model/tipo_ativo.dart';





class DatabaseHelper {

  static DatabaseHelper _databaseHelper; //SINGLETON
  static Database _database; // singleton database


  DatabaseHelper._criarInstancia();


  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._criarInstancia();
    }
    return _databaseHelper;
  }

  Future<Database> initializeDatabase() async {
    Directory diretorio = await getApplicationDocumentsDirectory();
    String path = join(diretorio.path, 'simulador_investimentos.db') ;
    var database = await openDatabase(path, version: 1, onCreate: _criarBanco);
    return database;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<int> insert(String tableName, Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(tableName, row);
  }

  Future<int> update(String tableName, String columnId, int id, Map<String, dynamic> values) async {
    Database db = await database;
    return await db.update(tableName, values, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete(tableName, String columnId, int id) async {
    var db = await this.database;
    int result =
    await db.rawDelete('DELETE FROM $tableName WHERE $columnId = $id');
    return result;
  }

  Future<int> queryRowCount(String tableName) async {
    Database db = await database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $tableName'));
  }

  Future<int> queryRowCountByFilter(String tableName, Map<String, dynamic> filter) async {
    Database db = await database;
    var whereFilterList = List<String>();
    whereFilterList.add("1 = 1");
    filter.forEach((key, value) {
      whereFilterList.add(key+' = ?');
    });
    var where = whereFilterList.join(" AND ");
    var whereValues = filter.values.toList();
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $tableName WHERE $where ', whereValues));
  }

  Future<List<Map<String, dynamic>>> queryAllByFilter(String tableName, Map<String, dynamic> filter) async {
    Database db = await database;
    var whereFilterList = List<String>();
    filter.forEach((key, value) {
      whereFilterList.add(key+' = ?');
    });
    var where = whereFilterList.join(" AND ");
    var whereValues = filter.values.toList();
    return await db.query(tableName, where:where, whereArgs: whereValues);
  }

  Future<List<Map<String, dynamic>>> queryAll(String tableName) async {
    Database db = await database;
    return await db.query(tableName);
  }

  Future<List<Map<String, dynamic>>> query(String sql, [List<dynamic> arguments]) async {
    Database db = await database;
    return await db.rawQuery(sql, arguments);
  }

  void _criarBanco(Database db, int newVersion) async {
    await db.execute(_sqlCriacaoTabelaAtivo());
    await db.execute(_sqlCriacaoTabelaCarteira());
    _executarCargaAtivos(db, newVersion);
  }


  String _sqlCriacaoTabelaAtivo(){
    var nomeTabela = AtivoDao.NOME_TABELA;
    var id = AtivoDao.COLUNA_ID;
    var nomeAtivo = AtivoDao.COLUNA_NOME;
    var ticker = AtivoDao.COLUNA_TICKER;
    var tipo = AtivoDao.COLUNA_TIPO;

    var sql = "CREATE TABLE $nomeTabela ($id  INTEGER PRIMARY KEY " +
        "AUTOINCREMENT, $nomeAtivo TEXT, $ticker TEXT, $tipo TEXT);";
    return sql;
  }

  String _sqlCriacaoTabelaCarteira(){
    var nomeTabela = AtivoCarteiraDao.NOME_TABELA;
    var id = AtivoCarteiraDao.COLUNA_ID;
    var ativoId = AtivoCarteiraDao.COLUNA_ATIVO_ID;
    var quantidade = AtivoCarteiraDao.COLUNA_QUANTIDADE;
    var precoMedio = AtivoCarteiraDao.COLUNA_PRECO_MEDIO;

    var sql = "CREATE TABLE $nomeTabela ($id  INTEGER PRIMARY KEY AUTOINCREMENT," +
        " $ativoId INTEGER NOT NULL, " +
        "$quantidade REAL, $precoMedio REAL);";
    return sql;
  }

  void _executarCargaAtivos(Database db, int newVersion) async{
    List<Map<String, dynamic>> ativos = _listaAtivos();
    var batch = db.batch();
    ativos.forEach((item) {
      batch.insert(AtivoDao.NOME_TABELA,  item);
    });
    await batch.commit(noResult: true);
  }

  List<Map<String, dynamic>> _listaAtivos() {
    var ativos = <Map<String, dynamic>>[];
    ativos.add({
      AtivoDao.COLUNA_TICKER: "BTC",
      AtivoDao.COLUNA_NOME: "Bitcoin",
      AtivoDao.COLUNA_TIPO: TipoAtivo.CRYPTOMOEDA
    });
    ativos.add({
      AtivoDao.COLUNA_TICKER: "ITSA4",
      AtivoDao.COLUNA_NOME: "ITAUSA S.A",
      AtivoDao.COLUNA_TIPO: TipoAtivo.ACAO
    
    });
    return ativos;
  }




}