

class Ativo{

  int _id;
  String _ticker;
  String _tipo;
  String _nome;
  String _mercado;

  Ativo(int id, String ticker, String tipo, String nome, String mercado){
    this._id = id;
    this._ticker = ticker;
    this._tipo = tipo;
    this._nome = nome;
    this._mercado = mercado;
  }

  int get id => _id;
  String get ticker => _ticker;
  String get tipo => _tipo;
  String get nome => _nome;
  String get mercado => _mercado;

  @override
  String toString()=> "{ticker:$_ticker, tipo:$_tipo, nome:$_nome}";


}