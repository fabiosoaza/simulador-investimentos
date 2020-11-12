import 'package:simulador_investimentos/core/model/domain/valor_monetario.dart';

import 'ativo.dart';

class AtivoCarteira{

  int _id;
  Ativo _ativo;
  ValorMonetario _precoMedio;
  double _quantidade;

  AtivoCarteira(int id, Ativo ativo, ValorMonetario precoMedio, double quantidade){
    this._id = id;
    this._ativo = ativo;
    this._precoMedio = precoMedio;
    this._quantidade = quantidade;
  }

  AtivoCarteira.novo(Ativo ativo, ValorMonetario precoMedio, double quantidade){
    this._ativo = ativo;
    this._precoMedio = precoMedio;
    this._quantidade = quantidade;
  }

  int get id => _id;
  Ativo get ativo => _ativo;
  ValorMonetario get precoMedio => _precoMedio;
  double get quantidade => _quantidade;

  ValorMonetario calcularValorTotal(){
      return _precoMedio.multiplicar(_quantidade);
  }

  @override
  String toString()=> "{ativo:$_ativo, precoMedio:${_precoMedio.valorFormatado()}, quantidade:$_quantidade}";

}