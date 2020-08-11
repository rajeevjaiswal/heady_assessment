import 'package:heady/data/local/entity/variant.dart';
import 'package:heady/data/local/entity/vat.dart';

class ProductDetail {
  List<Variant> variants;
  Vat vat;

  ProductDetail({this.variants, this.vat});
}
