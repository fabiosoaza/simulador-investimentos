import 'package:simulador_investimentos/core/model/valor_monetario.dart';

import 'ativo.dart';

class Cotacao{

  Ativo _ativo;
  ValorMonetario _valor;

  Cotacao(Ativo ativo, ValorMonetario valor) {
    this._ativo = ativo;
    this._valor = valor;
  }

  Ativo get ativo => _ativo;
  ValorMonetario get valor => _valor;

  @override
  String toString()=> "{ativo:$_ativo, valor:${_valor.valorFormatado()}}";

}