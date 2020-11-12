class ValidadorValor {
  String _valor;

  ValidadorValor(String valor) {
    this._valor = valor;
  }

  bool validar() {
    return _valor != null &&
        _valor.isNotEmpty &&
        double.tryParse(_valor) != null &&
        double.tryParse(_valor) > 0;
  }
}
