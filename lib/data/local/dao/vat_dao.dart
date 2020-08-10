import 'package:floor/floor.dart';
import 'package:heady/data/local/entity/vat.dart';

@dao
abstract class VatDao {
  @insert
  Future<void> insertVat(Vat vat);
}
