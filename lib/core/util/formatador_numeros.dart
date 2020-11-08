class FormatadorNumeros{

  FormatadorNumeros(){}

  double stringToDouble(String valor, int numeroCasasDecimais){
    var valorAsDouble = double.parse(valor);
    return arredondar(valorAsDouble, numeroCasasDecimais);
  }

  String formatarPorcentagem(double porcentagem, int numeroCasasDecimais) {
     RegExp regex = RegExp(r"([.]*0)(?!.*\d)");
    var valorFormatado = arredondar(porcentagem, numeroCasasDecimais).toDouble().toString().replaceAll(regex, "");
    return valorFormatado;
  }

  double arredondar(double valorAsDouble, int numeroCasasDecimais) => num.parse(doubleToString(valorAsDouble, numeroCasasDecimais)).toDouble();

  String doubleToString(double valorAsDouble, int numeroCasasDecimais) {
    RegExp regex = RegExp(r"([.]*0)(?!.*\d)");
    var valorFormatado = num.parse(valorAsDouble.toStringAsFixed(numeroCasasDecimais)).toDouble().toString().replaceAll(regex, "");
    return valorFormatado;
  }

}