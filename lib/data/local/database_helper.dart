import 'package:heady/data/local/app_database.dart';
import 'package:heady/data/local/entity/product.dart';
import 'package:heady/data/local/entity/variant.dart';
import 'package:heady/data/local/entity/vat.dart';

import 'entity/Category.dart';

class DatabaseHelper {
  final Future<AppDatabase> _database;

  DatabaseHelper(this._database);

  Future<void> saveVatToDatabase(Vat vat) async {
    print("vat");
    return _database.then((database) {
      return database.vatDao.insertVat(vat);
    });
  }

  Future<void> saveVariantToDatabase(Variant variant) async {
    print("variant");
    return _database.then((database) {
      return database.variantDao.insertVariant(variant);
    });
  }

  Future<void> saveProductToDatabase(Product product) async {
    print("insert product id => ${product.id}");
    return _database.then((database) {
      return database.productDao.insertProduct(product);
    });
  }

  Future<void> saveCategoryToDatabase(Category category) async {
    print("insert category id => ${category.id}");

    return _database.then((database) {
      return database.categoryDao.insertCategory(category);
    });
  }
}
