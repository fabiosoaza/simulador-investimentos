import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'package:simulador_investimentos/core/dao/ativo_dao.dart';
import 'package:simulador_investimentos/core/dao/ativo_carteira_dao.dart';
import 'package:simulador_investimentos/core/model/domain/tipo_ativo.dart';

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
    String path = join(diretorio.path, 'simulador_investimentos.db');
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

  Future<int> update(String tableName, String columnId, int id,
      Map<String, dynamic> values) async {
    Database db = await database;
    return await db
        .update(tableName, values, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete(tableName, String columnId, int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $tableName WHERE $columnId = $id');
    return result;
  }

  Future<int> queryRowCount(String tableName) async {
    Database db = await database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $tableName'));
  }

  Future<int> queryRowCountByFilter(
      String tableName, Map<String, dynamic> filter) async {
    Database db = await database;
    var whereFilterList = List<String>();
    whereFilterList.add("1 = 1");
    filter.forEach((key, value) {
      whereFilterList.add(key + ' = ?');
    });
    var where = whereFilterList.join(" AND ");
    var whereValues = filter.values.toList();
    return Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM $tableName WHERE $where ', whereValues));
  }

  Future<List<Map<String, dynamic>>> queryAllByFilter(
      String tableName, Map<String, dynamic> filter) async {
    Database db = await database;
    var whereFilterList = List<String>();
    filter.forEach((key, value) {
      whereFilterList.add(key + ' = ?');
    });
    var where = whereFilterList.join(" AND ");
    var whereValues = filter.values.toList();
    return await db.query(tableName, where: where, whereArgs: whereValues);
  }

  Future<List<Map<String, dynamic>>> queryAll(String tableName) async {
    Database db = await database;
    return await db.query(tableName);
  }

  Future<List<Map<String, dynamic>>> query(String sql,
      [List<dynamic> arguments]) async {
    Database db = await database;
    return await db.rawQuery(sql, arguments);
  }

  void _criarBanco(Database db, int newVersion) async {
    await db.execute(_sqlCriacaoTabelaAtivo());
    await db.execute(_sqlCriacaoTabelaCarteira());
    _executarCargaAtivos(db, newVersion);
  }

  String _sqlCriacaoTabelaAtivo() {
    var nomeTabela = AtivoDao.NOME_TABELA;
    var id = AtivoDao.COLUNA_ID;
    var nomeAtivo = AtivoDao.COLUNA_NOME;
    var ticker = AtivoDao.COLUNA_TICKER;
    var tipo = AtivoDao.COLUNA_TIPO;
    var mercado = AtivoDao.COLUNA_MERCADO;

    var sql = "CREATE TABLE $nomeTabela ($id  INTEGER PRIMARY KEY " +
        "AUTOINCREMENT, $nomeAtivo TEXT, $ticker TEXT, $tipo TEXT, $mercado TEXT);";
    return sql;
  }

  String _sqlCriacaoTabelaCarteira() {
    var nomeTabela = AtivoCarteiraDao.NOME_TABELA;
    var id = AtivoCarteiraDao.COLUNA_ID;
    var ativoId = AtivoCarteiraDao.COLUNA_ATIVO_ID;
    var quantidade = AtivoCarteiraDao.COLUNA_QUANTIDADE;
    var precoMedio = AtivoCarteiraDao.COLUNA_PRECO_MEDIO;

    var sql =
        "CREATE TABLE $nomeTabela ($id  INTEGER PRIMARY KEY AUTOINCREMENT," +
            " $ativoId INTEGER NOT NULL, " +
            "$quantidade REAL, $precoMedio REAL);";
    return sql;
  }

  void _executarCargaAtivos(Database db, int newVersion) async {
    List<Map<String, dynamic>> ativos = _listarAtivos();
    var batch = db.batch();
    ativos.forEach((item) {
      batch.insert(AtivoDao.NOME_TABELA, item);
    });
    await batch.commit(noResult: true);
  }

  List<Map<String, dynamic>> _listarAtivos() {
    var ativos = <Map<String, dynamic>>[];
    ativos.addAll(_acoes());
    ativos.addAll(_criptomoedas());
    return ativos;
  }

  List<Map<String, dynamic>> _acoes(){
    var ativos = <Map<String, dynamic>>[];
    var tipoAtivo = AtivoConstants.TIPO_ACAO;
    var mercado = AtivoConstants.MERCADO_B3;

    ativos.add(ativo("ABEV3", "AMBEV S/A", tipoAtivo, mercado));
    ativos.add(ativo("AZUL4", "AZUL", tipoAtivo, mercado));
    ativos.add(ativo("B3SA3", "B3", tipoAtivo, mercado));
    ativos.add(ativo("BBAS3", "BRASIL", tipoAtivo, mercado));
    ativos.add(ativo("BBDC3", "BRADESCO", tipoAtivo, mercado));
    ativos.add(ativo("BBDC4", "BRADESCO", tipoAtivo, mercado));
    ativos.add(ativo("BBSE3", "BBSEGURIDADE", tipoAtivo, mercado));
    ativos.add(ativo("BEEF3", "MINERVA", tipoAtivo, mercado));
    ativos.add(ativo("BPAC11", "BTGP BANCO", tipoAtivo, mercado));
    ativos.add(ativo("BRAP4", "BRADESPAR", tipoAtivo, mercado));
    ativos.add(ativo("BRDT3", "PETROBRAS BR", tipoAtivo, mercado));
    ativos.add(ativo("BRFS3", "BRF SA", tipoAtivo, mercado));
    ativos.add(ativo("BRKM5", "BRASKEM", tipoAtivo, mercado));
    ativos.add(ativo("BRML3", "BR MALLS PAR", tipoAtivo, mercado));
    ativos.add(ativo("BTOW3", "B2W DIGITAL", tipoAtivo, mercado));
    ativos.add(ativo("CCRO3", "CCR SA", tipoAtivo, mercado));
    ativos.add(ativo("CIEL3", "CIELO", tipoAtivo, mercado));
    ativos.add(ativo("CMIG4", "CEMIG", tipoAtivo, mercado));
    ativos.add(ativo("COGN3", "COGNA ON", tipoAtivo, mercado));
    ativos.add(ativo("CPFE3", "CPFL ENERGIA", tipoAtivo, mercado));
    ativos.add(ativo("CRFB3", "CARREFOUR BR", tipoAtivo, mercado));
    ativos.add(ativo("CSAN3", "COSAN", tipoAtivo, mercado));
    ativos.add(ativo("CSNA3", "SID NACIONAL", tipoAtivo, mercado));
    ativos.add(ativo("CVCB3", "CVC BRASIL", tipoAtivo, mercado));
    ativos.add(ativo("CYRE3", "CYRELA REALT", tipoAtivo, mercado));
    ativos.add(ativo("ECOR3", "ECORODOVIAS", tipoAtivo, mercado));
    ativos.add(ativo("EGIE3", "ENGIE BRASIL", tipoAtivo, mercado));
    ativos.add(ativo("ELET3", "ELETROBRAS", tipoAtivo, mercado));
    ativos.add(ativo("ELET6", "ELETROBRAS", tipoAtivo, mercado));
    ativos.add(ativo("EMBR3", "EMBRAER", tipoAtivo, mercado));
    ativos.add(ativo("ENBR3", "ENERGIAS BR", tipoAtivo, mercado));
    ativos.add(ativo("ENGI11", "ENERGISA", tipoAtivo, mercado));
    ativos.add(ativo("EQTL3", "EQUATORIAL", tipoAtivo, mercado));
    ativos.add(ativo("EZTC3", "EZTEC", tipoAtivo, mercado));
    ativos.add(ativo("FLRY3", "FLEURY", tipoAtivo, mercado));
    ativos.add(ativo("GGBR4", "GERDAU", tipoAtivo, mercado));
    ativos.add(ativo("GNDI3", "INTERMEDICA", tipoAtivo, mercado));
    ativos.add(ativo("GOAU4", "GERDAU MET", tipoAtivo, mercado));
    ativos.add(ativo("GOLL4", "GOL", tipoAtivo, mercado));
    ativos.add(ativo("HAPV3", "HAPVIDA", tipoAtivo, mercado));
    ativos.add(ativo("HGTX3", "CIA HERING", tipoAtivo, mercado));
    ativos.add(ativo("HYPE3", "HYPERA", tipoAtivo, mercado));
    ativos.add(ativo("IGTA3", "IGUATEMI", tipoAtivo, mercado));
    ativos.add(ativo("IRBR3", "IRBBRASIL RE", tipoAtivo, mercado));
    ativos.add(ativo("ITSA4", "ITAUSA", tipoAtivo, mercado));
    ativos.add(ativo("ITUB4", "ITAUUNIBANCO", tipoAtivo, mercado));
    ativos.add(ativo("JBSS3", "JBS", tipoAtivo, mercado));
    ativos.add(ativo("KLBN11", "KLABIN S/A", tipoAtivo, mercado));
    ativos.add(ativo("LAME4", "LOJAS AMERIC", tipoAtivo, mercado));
    ativos.add(ativo("LREN3", "LOJAS RENNER", tipoAtivo, mercado));
    ativos.add(ativo("MGLU3", "MAGAZ LUIZA", tipoAtivo, mercado));
    ativos.add(ativo("MRFG3", "MARFRIG", tipoAtivo, mercado));
    ativos.add(ativo("MRVE3", "MRV", tipoAtivo, mercado));
    ativos.add(ativo("MULT3", "MULTIPLAN", tipoAtivo, mercado));
    ativos.add(ativo("NTCO3", "GRUPO NATURA", tipoAtivo, mercado));
    ativos.add(ativo("PCAR3", "P.ACUCAR-CBD", tipoAtivo, mercado));
    ativos.add(ativo("PETR3", "PETROBRAS", tipoAtivo, mercado));
    ativos.add(ativo("PETR4", "PETROBRAS", tipoAtivo, mercado));
    ativos.add(ativo("PRIO3", "PETRORIO", tipoAtivo, mercado));
    ativos.add(ativo("QUAL3", "QUALICORP", tipoAtivo, mercado));
    ativos.add(ativo("RADL3", "RAIADROGASIL", tipoAtivo, mercado));
    ativos.add(ativo("RAIL3", "RUMO S.A.", tipoAtivo, mercado));
    ativos.add(ativo("RENT3", "LOCALIZA", tipoAtivo, mercado));
    ativos.add(ativo("SANB11", "SANTANDER BR", tipoAtivo, mercado));
    ativos.add(ativo("SBSP3", "SABESP", tipoAtivo, mercado));
    ativos.add(ativo("SULA11", "SUL AMERICA", tipoAtivo, mercado));
    ativos.add(ativo("SUZB3", "SUZANO S.A.", tipoAtivo, mercado));
    ativos.add(ativo("TAEE11", "TAESA", tipoAtivo, mercado));
    ativos.add(ativo("TIMS3", "TIM", tipoAtivo, mercado));
    ativos.add(ativo("TOTS3", "TOTVS", tipoAtivo, mercado));
    ativos.add(ativo("UGPA3", "ULTRAPAR", tipoAtivo, mercado));
    ativos.add(ativo("USIM5", "USIMINAS", tipoAtivo, mercado));
    ativos.add(ativo("VALE3", "VALE", tipoAtivo, mercado));
    ativos.add(ativo("VIVT4", "TELEF BRASIL", tipoAtivo, mercado));
    ativos.add(ativo("VVAR3", "VIAVAREJO", tipoAtivo, mercado));
    ativos.add(ativo("WEGE3", "WEG", tipoAtivo, mercado));
    ativos.add(ativo("YDUQ3", "YDUQS PART", tipoAtivo, mercado));

    return ativos;
  }

  List<Map<String, dynamic>> _criptomoedas(){
    var ativos = <Map<String, dynamic>>[];
    var tipoAtivo = AtivoConstants.TIPO_CRYPTOMOEDA;
    var mercado = AtivoConstants.MERCADO_BITCOIN;
    ativos.add(ativo("BCH",  " Bitcoin Cash", tipoAtivo, mercado) );
    ativos.add(ativo("BTC",  " Bitcoin", tipoAtivo, mercado) );
    ativos.add(ativo("CHZ",  " Chiliz", tipoAtivo, mercado) );
    ativos.add(ativo("ETH",  " Ethereum", tipoAtivo, mercado) );
    ativos.add(ativo("LTC",  " Litecoin", tipoAtivo, mercado) );
    ativos.add(ativo("PAXG",  " PAX Gold", tipoAtivo, mercado) );
    ativos.add(ativo("USDC",  " USD Coin", tipoAtivo, mercado) );
    ativos.add(ativo("WBX",  " WiBX", tipoAtivo, mercado) );
    ativos.add(ativo("XRP",  " XRP", tipoAtivo, mercado) );

    return ativos;
  }

  Map<String, dynamic> ativo(String ticker, String nome, String tipo, String mercado) {
    return {
    AtivoDao.COLUNA_TICKER: ticker,
    AtivoDao.COLUNA_NOME: nome,
    AtivoDao.COLUNA_TIPO: tipo,
    AtivoDao.COLUNA_MERCADO: mercado
  };
  }
}
