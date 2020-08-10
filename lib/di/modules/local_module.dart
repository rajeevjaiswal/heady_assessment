import 'package:heady/data/local/app_database.dart';
import 'package:heady/data/local/constants/db_constants.dart';
import 'package:heady/data/local/database_helper.dart';
import 'package:inject/inject.dart';

@module
class LocalModule {
  // DI variables:--------------------------------------------------------------
  Future<AppDatabase> _databaseRef;

  LocalModule() {
    _databaseRef = provideDatabase();
  }

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

  /// A singleton db helper provider.
  ///
  /// Calling it multiple times will return the same instance.
  @provide
  @singleton
  DatabaseHelper provideDatabaseHelper() {
    return DatabaseHelper(_databaseRef);
  }
}
