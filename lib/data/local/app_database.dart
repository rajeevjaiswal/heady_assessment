import 'package:floor/floor.dart';
import 'package:heady/data/local/dao/category_dao.dart';
import 'package:heady/data/local/dao/product_dao.dart';
import 'package:heady/data/local/dao/variant_dao.dart';
import 'package:heady/data/local/dao/vat_dao.dart';
import 'package:heady/data/local/entity/Category.dart';
import 'package:heady/data/local/entity/product.dart';
import 'package:heady/data/local/entity/variant.dart';
import 'package:heady/data/local/entity/vat.dart';
import 'package:sqflite/sqflite.dart' as sqflite; // needed for floor db
import 'dart:async'; // needed for floor db
part 'app_database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [Category, Product, Variant, Vat])
abstract class AppDatabase extends FloorDatabase {
  CategoryDao get categoryDao;
  ProductDao get productDao;
  VariantDao get variantDao;
  VatDao get vatDao;
}
