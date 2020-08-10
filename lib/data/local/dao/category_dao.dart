import 'package:floor/floor.dart';

import '../entity/Category.dart' as cat;

@dao
abstract class CategoryDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertCategory(cat.Category category);
}
