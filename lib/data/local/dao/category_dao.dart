import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart';

import '../entity/Category.dart' as cat;

@dao
abstract class CategoryDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertCategory(cat.Category category);

  /// not supported
  /*@transaction
  @Query('SELECT COUNT(*) FROM Category')
  Future<int> findCategoriesCount();*/

  @Query('SELECT * FROM Category WHERE parentId IS null')
  Future<List<cat.Category>> getTopCategories();

  @Query('SELECT * FROM Category WHERE parentId = :parentId')
  Future<List<cat.Category>> getChildCategories(int parentId);
}
