import 'package:floor/floor.dart';
import 'package:heady/data/local/entity/product.dart';

@dao
abstract class ProductDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertProduct(Product product);
}
