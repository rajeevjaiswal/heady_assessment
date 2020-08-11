import 'package:heady/data/local/entity/product.dart';
import 'package:heady/data/repository.dart';
import 'package:heady/models/category_with_children.dart';
import 'package:heady/stores/error_store.dart';
import 'package:mobx/mobx.dart';

part 'data_store.g.dart';

class DataStore = _DataStore with _$DataStore;

abstract class _DataStore with Store {
  // repository instance
  Repository _repository;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  _DataStore(Repository repository) : this._repository = repository;

  // store variables:-----------------------------------------------------------
  static ObservableFuture<List<CategoryWithChildren>> emptyPostResponse =
      ObservableFuture.value(null);

  static ObservableFuture<List<Product>> emptyProductResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<List<CategoryWithChildren>> parentCategoryFuture =
      ObservableFuture<List<CategoryWithChildren>>(emptyPostResponse);

  @observable
  ObservableFuture<List<CategoryWithChildren>> childCategoryFuture =
      ObservableFuture<List<CategoryWithChildren>>(emptyPostResponse);

  @observable
  ObservableFuture<List<Product>> productFuture =
      ObservableFuture<List<Product>>(emptyProductResponse);

  /// variables which when changes will trigger reactions
  @observable
  List<CategoryWithChildren> parentCategoryList;

  @observable
  List<CategoryWithChildren> childCategoryList;

  @observable
  List<Product> productList;

  @observable
  bool success = false;

  /// using futures to track status
  @computed
  bool get loading => parentCategoryFuture.status == FutureStatus.pending;

  @computed
  bool get childLoading => childCategoryFuture.status == FutureStatus.pending;

  @computed
  bool get productLoading => productFuture.status == FutureStatus.pending;

  // actions:-------------------------------------------------------------------
  @action
  Future getData() async {
    // just need to check the data from the server
    final future = _repository.getData();

    /// track status of future.
    parentCategoryFuture = ObservableFuture(future);

    future.then((parentList) {
      this.parentCategoryList = parentList;
    }).catchError((error) {
      errorStore.errorMessage = "Something went wrong";
    });
  }

  @action
  Future getChildCategories(int parentId) async {
    // just need to check the data from the server
    final future = _repository.getChildCategories(parentId);

    /// track status of future.
    childCategoryFuture = ObservableFuture(future);

    future.then((childList) {
      this.childCategoryList = childList;
    }).catchError((error) {
      errorStore.errorMessage = "Error while fetching data";
    });
  }

  @action
  Future getProductsByCategoryId(int catId) async {
    // just need to check the data from the server
    final future = _repository.getProductsByCategoryId(catId);

    /// track status of future.
    productFuture = ObservableFuture(future);

    future.then((list) {
      this.productList = list;
    }).catchError((error) {
      errorStore.errorMessage = "Error while fetching data";
    });
  }
}
