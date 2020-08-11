import 'package:heady/data/local/app_database.dart';
import 'package:heady/data/local/constants/db_constants.dart';
import 'package:heady/data/local/entity/product.dart';
import 'package:heady/data/local/entity/variant.dart';
import 'package:heady/data/local/entity/vat.dart';
import 'package:heady/models/category_with_children.dart';

import 'entity/Category.dart';

class DatabaseHelper {
  final Future<AppDatabase> _database;

  DatabaseHelper(this._database);

  Future<void> saveVatToDatabase(Vat vat) async {
    print("vat");
    return _database.then((database) async {
      return await database.vatDao.insertVat(vat);
    });
  }

  Future<void> saveVariantToDatabase(Variant variant) async {
    print("variant");
    return _database.then((database) async {
      return await database.variantDao.insertVariant(variant);
    });
  }

  Future<void> saveProductToDatabase(Product product) async {
    print(
        "insert product id => ${product.id}  ===> catId  ${product.categoryId}");
    return _database.then((database) async {
      return await database.productDao.insertProduct(product);
    });
  }

  Future<void> saveCategoryToDatabase(Category category) async {
    print("insert category id => ${category.parentId}");

    return _database.then((database) async {
      return await database.categoryDao.insertCategory(category);
    });
  }

  // all get related functions

  Future<List<CategoryWithChildren>> getTopCategories() async {
    List<CategoryWithChildren> categories = List();
    return _database.then((database) async {
      await database.categoryDao.getTopCategories().then((topCategories) async {
        if (topCategories != null && topCategories.isNotEmpty) {
          print("top Cat count ${topCategories.length}");
          for (Category eachCategory in topCategories) {
            CategoryWithChildren tempData = CategoryWithChildren();
            tempData.category = eachCategory;
            print("childCatCount ${eachCategory.subCategoryCount}");
            print("productCount ${eachCategory.productCount}");
            if (eachCategory.subCategoryCount > 0) {
              var childCategories = await database.categoryDao
                  .getChildCategories(eachCategory.id);
              print("add child");

              tempData.childCategories = childCategories;
            }

            if (eachCategory.productCount > 0) {
              var products = await database.productDao
                  .getProductsForCategory(eachCategory.id);
              print("add product child");
              tempData.products = products;
            }

            categories.add(tempData);
          }
        }
      });
      return categories;
    });
  }

  Future<List<CategoryWithChildren>> getChildCategories(int parentId) async {
    List<CategoryWithChildren> categories = List();
    return _database.then((database) async {
      await database.categoryDao
          .getChildCategories(parentId)
          .then((childCategories) async {
        if (childCategories != null && childCategories.isNotEmpty) {
          print("childCategories count ${childCategories.length}");
          for (Category eachCategory in childCategories) {
            CategoryWithChildren tempData = CategoryWithChildren();
            tempData.category = eachCategory;
            print("childCatCount ${eachCategory.subCategoryCount}");
            print("productCount ${eachCategory.productCount}");
            if (eachCategory.subCategoryCount > 0) {
              var childCategories = await database.categoryDao
                  .getChildCategories(eachCategory.id);
              print("add child");

              tempData.childCategories = childCategories;
            }

            categories.add(tempData);
          }
        }
      });
      return categories;
    });
  }

  Future<List<Product>> getProductsByCategoryId(int catId, int sortId) async {
    List<Product> productList = List();
    return _database.then((database) async {
      if (sortId == null) {
        productList = await database.productDao.getProductsForCategory(catId);
      } else if (sortId == 0) {
        productList = await database.productDao.getProductsSortedByViews(catId);
      } else if (sortId == 1) {
        productList =
            await database.productDao.getProductsSortedByOrders(catId);
      } else {
        productList =
            await database.productDao.getProductsSortedByShares(catId);
      }

      /* await database.productDao.getProductsForCategory(catId).then((products) {
        if (products != null && products.isNotEmpty) {
          print("prodListCount ${products.length}");

          productList = products;
        }
      });*/
      return productList;
    });
  }
}
