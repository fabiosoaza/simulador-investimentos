class FalhaApiCotacaoException implements Exception{

 String _message;

 FalhaApiCotacaoException([String message]){
   this._message = message;
 }

 String get message => _message;

 @override
  String toString() {
    // TODO: implement toString
    return "${_message}. ${super.toString()}";
  }

}