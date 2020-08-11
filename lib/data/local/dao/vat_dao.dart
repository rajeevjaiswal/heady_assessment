import 'package:floor/floor.dart';
import 'package:heady/data/local/entity/vat.dart';

@dao
abstract class VatDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertVat(Vat vat);

  @Query('SELECT * FROM Vat WHERE productId = :productId')
  Future<Vat> getVat(int productId);
}
