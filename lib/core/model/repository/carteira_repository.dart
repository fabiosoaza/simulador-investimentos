import '../domain/carteira.dart';

abstract class CarteiraRepository{

  Future<Carteira> carregar();

}