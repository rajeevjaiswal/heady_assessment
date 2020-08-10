import 'package:floor/floor.dart';
import 'package:flutter/foundation.dart';

@dao
abstract class CategoryDao {
  @insert
  Future<void> insertCategory(Category category);
}
