import 'package:simulador_investimentos/core/util/formatador_numeros.dart';

class ValorMonetario{

  String _codigoMoeda;
  String _simbolo;
  String _valor;
  int _casasDecimais = 8;

  ValorMonetario.brl(String valor){
    this._codigoMoeda = "BRL";
    this._simbolo = "R\$";
    this._valor = valor;
  }

  ValorMonetario somar(ValorMonetario valor){
    var valorAtual = valorAsDouble();
    var valorSomar = valor.valorAsDouble();
    var novoValorAsString = FormatadorNumeros().doubleToString(valorAtual + valorSomar, _casasDecimais);
    return ValorMonetario.brl(novoValorAsString);
  }

  ValorMonetario subtrair(ValorMonetario valor){
    var valorAtual = valorAsDouble();
    var valorSubtrair = valor.valorAsDouble();
    var novoValorAsString = FormatadorNumeros().doubleToString(valorAtual - valorSubtrair, _casasDecimais);
    return ValorMonetario.brl(novoValorAsString);
  }

  ValorMonetario multiplicar(double valor){
    var valorAtual = valorAsDouble();
    var novoValorAsString = FormatadorNumeros().doubleToString(valorAtual * valor, _casasDecimais);
    return ValorMonetario.brl(novoValorAsString);
  }

  ValorMonetario dividir(double valor){
    var valorAtual = valorAsDouble();
    var novoValorAsString = FormatadorNumeros().doubleToString(valorAtual / valor, _casasDecimais);
    return ValorMonetario.brl(novoValorAsString);
  }

  ValorMonetario calcularPorcentagem(double porcentagem){
    var valorAtual = valorAsDouble();
    var valorCalculo = valorAtual * (porcentagem/100);
    var novoValorAsString = FormatadorNumeros().doubleToString(valorCalculo, _casasDecimais);
    return ValorMonetario.brl(novoValorAsString);
  }

  ValorMonetario arredondar(int numeroCasasDecimais){
    var doubleToString = FormatadorNumeros().doubleToString(valorAsDouble(), numeroCasasDecimais);
    return ValorMonetario.brl(doubleToString);
  }

  String valorFormatado(){
    return valorFormatadoComCasasDecimais(_casasDecimais);
  }

  String valorFormatadoComCasasDecimais(int numeroCasasDecimais){
    var doubleToString = FormatadorNumeros().doubleToString(valorAsDouble(), numeroCasasDecimais);
    return '$_simbolo $doubleToString';
  }

  double valorAsDouble(){
    var valorFixado = FormatadorNumeros().stringToDouble(_valor, _casasDecimais);
    return valorFixado;
  }


  @override
  String toString()=> "{codigoMoeda:$_codigoMoeda, simbolo:$_simbolo, valor:$_valor}";


}