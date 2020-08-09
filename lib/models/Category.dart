import 'package:heady/models/product.dart';

class Category {
  int id;
  String name;
  List<Product> products;
  List<Category> subCategories;

  Category(this.id, this.name, this.products, this.subCategories);
}
