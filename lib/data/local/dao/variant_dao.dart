import 'package:floor/floor.dart';
import 'package:heady/data/local/entity/variant.dart';

@dao
abstract class VariantDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertVariant(Variant variant);

  @Query('SELECT * FROM Variant WHERE productId = :productId')
  Future<List<Variant>> getVariants(int productId);
}
