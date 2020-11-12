

class Ativo{

  int _id;
  String _ticker;
  String _tipo;
  String _nome;

  Ativo(int id, String ticker, String tipo, String nome){
    this._id = id;
    this._ticker = ticker;
    this._tipo = tipo;
    this._nome = nome;
  }

  int get id => _id;
  String get ticker => _ticker;
  String get tipo => _tipo;
  String get nome => _nome;

  @override
  String toString()=> "{ticker:$_ticker, tipo:$_tipo, nome:$_nome}";


}