import 'dart:async';

import 'package:heady/data/network/apis/data/data_api.dart';
import 'package:heady/models/Category.dart';
import 'package:heady/models/product.dart';

class Repository {
  // api objects
  final DataApi _dataApi;

  // constructor
  Repository(
    this._dataApi,
  );

  // Post: ---------------------------------------------------------------------
  Future<dynamic> getData() async {
    return await _dataApi.getData().then((data) {
      _parseResponse(data);
      return data;
    }).catchError((error) => throw error);
  }

  void _parseResponse(dynamic response) {
//    final mainResponse = jsonDecode(response.toString()) as Map;

    final categories = response['categories'] as List<dynamic>;
    var idForProductMap = Map<int, Product>();
    var idForCategoryMap = Map<int, Category>();
    var categoryIdForChildCategoriesIdMap = Map<int, dynamic>();
    for (int i = 0; i < categories.length; i++) {
      _parseCategory(categories[i], idForProductMap, idForCategoryMap,
          categoryIdForChildCategoriesIdMap);
    }
    print("main $categories");
  }

  void _parseCategory(
      dynamic category,
      Map<int, Product> idForProductMap,
      Map<int, Category> idForCategoryMap,
      Map<int, dynamic> categoryIdForChildCategoriesIdMap) {

  }
}
