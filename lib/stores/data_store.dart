import 'package:heady/data/repository.dart';
import 'package:mobx/mobx.dart';

part 'data_store.g.dart';

class DataStore = _DataStore with _$DataStore;

abstract class _DataStore with Store {
  // repository instance
  Repository _repository;

  // constructor:---------------------------------------------------------------
  _DataStore(Repository repository) : this._repository = repository;

  // actions:-------------------------------------------------------------------
  @action
  Future getData() async {
    // just need to check the data from the server
    final future = _repository.getData();
  }
}
