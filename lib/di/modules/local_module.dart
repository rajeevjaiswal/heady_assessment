import 'package:heady/data/local/app_database.dart';
import 'package:heady/data/local/constants/db_constants.dart';
import 'package:inject/inject.dart';

@module
class LocalModule {
  /// A singleton database provider.
  ///
  /// Calling it multiple times will return the same instance.
  ///
  @provide
  @singleton
  @asynchronous
  Future<AppDatabase> provideDatabase() {
    return $FloorAppDatabase.databaseBuilder(DBConstants.DB_NAME).build();
  }
}
