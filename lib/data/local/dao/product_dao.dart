import 'package:floor/floor.dart';
import 'package:heady/data/local/entity/product.dart';

@dao
abstract class ProductDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertProduct(Product product);

  @Query('SELECT * FROM Product WHERE categoryId = :categoryId')
  Future<List<Product>> getProductsForCategory(int categoryId);

  @Query(
      'SELECT * FROM Product WHERE categoryId = :categoryId ORDER BY viewCount DESC')
  Future<List<Product>> getProductsSortedByViews(int categoryId);

  @Query(
      'SELECT * FROM Product WHERE categoryId = :categoryId ORDER BY orderCount DESC')
  Future<List<Product>> getProductsSortedByOrders(int categoryId);

  @Query(
      'SELECT * FROM Product WHERE categoryId = :categoryId ORDER BY shareCount DESC')
  Future<List<Product>> getProductsSortedByShares(int categoryId);
}
