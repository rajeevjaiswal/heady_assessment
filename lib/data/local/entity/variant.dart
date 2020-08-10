import 'package:floor/floor.dart';

@entity
class Variant {
  Variant(this.id, this.color, this.size, this.price, this.productId);
  @primaryKey
  int id;
  String color;
  int size;
  double price;
  int productId;
}
