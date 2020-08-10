import 'package:floor/floor.dart';

@entity
class Vat {
  Vat(this.name, this.value, this.productId, [this.id]);
  @PrimaryKey(autoGenerate: true)
  int id;
  String name;
  double value;
  int productId;
}
