import 'package:heady/models/variant.dart';
import 'package:heady/models/vat.dart';

class Product {
  int id;
  String name;
  List<Variant> variants;
  int viewCount;
  int orderCount;
  int shareCount;
  Vat vat;
  String dateAdded;

  Product(
      {this.id,
      this.name,
      this.variants,
      this.viewCount = 0,
      this.orderCount = 0,
      this.shareCount = 0,
      this.vat,
      this.dateAdded});
}
