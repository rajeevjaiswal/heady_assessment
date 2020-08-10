import 'package:floor/floor.dart';

@entity
class Product {
  @primaryKey
  int id;
  String name;
  int categoryId;
  int viewCount;
  int orderCount;
  int shareCount;
  String dateAdded;

  Product(
      {this.id,
      this.name,
      this.categoryId,
      this.viewCount = 0,
      this.orderCount = 0,
      this.shareCount = 0,
      this.dateAdded});
}
