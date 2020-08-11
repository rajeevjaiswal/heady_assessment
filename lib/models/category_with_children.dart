import 'package:heady/data/local/entity/Category.dart';
import 'package:heady/data/local/entity/product.dart';

class CategoryWithChildren {

  CategoryWithChildren({this.category, this.products, this.childCategories});

  Category category;
  List<Product> products;
  List<Category> childCategories;

  bool get hasChildCategories => category.subCategoryCount > 0;

}
