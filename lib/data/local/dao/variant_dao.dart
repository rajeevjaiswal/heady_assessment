import 'package:floor/floor.dart';
import 'package:heady/data/local/entity/variant.dart';

@dao
abstract class VariantDao {
  @insert
  Future<void> insertVariant(Variant variant);
}
