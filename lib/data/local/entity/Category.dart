import 'package:floor/floor.dart';

@entity
class Category {
  @primaryKey
  int id;
  String name;
  int productCount;
  int subCategoryCount;
  @ColumnInfo(nullable: true)
  int parentId;

  Category(
      {this.id,
      this.name,
      this.productCount = 0,
      this.subCategoryCount = 0,
      this.parentId});
}
