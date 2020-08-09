import 'dart:async';

import 'package:heady/data/network/apis/data/data_api.dart';
import 'package:heady/models/Category.dart';
import 'package:heady/models/product.dart';
import 'package:heady/models/variant.dart';
import 'package:heady/models/vat.dart';

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
    var rankingJson = response['rankings'] as List<dynamic>;
    _updateProductsRankingType(rankingJson, idForProductMap);
    _assignChildCategories(idForCategoryMap, categoryIdForChildCategoriesIdMap)
    //todo : save all the above parsed data in db
    print("main $categories");
  }

  void _parseCategory(
      dynamic categoryJson,
      Map<int, Product> idForProductMap,
      Map<int, Category> idForCategoryMap,
      Map<int, dynamic> categoryIdForChildCategoriesIdMap) {
    var products = _parseProductForCategory(categoryJson, idForProductMap);
    var category = Category(categoryJson['id'], categoryJson['name'], products);
    idForCategoryMap[category.id] = category;
    var childCatList = categoryJson['child_categories'] as List<dynamic>;
    if (childCatList != null && childCatList.isNotEmpty) {
      categoryIdForChildCategoriesIdMap[category.id] = childCatList;
    }
  }

  List<Product> _parseProductForCategory(
      dynamic categoryJson, Map<int, Product> idForProductMap) {
    var products = List<Product>();
    var productList = categoryJson['products'] as List<dynamic>;

    for (int i = 0; i < productList.length; i++) {
      var productJson = productList[i];
      var taxJson = productJson['tax'];
      var variantList = _parseVariantForEachProduct(productJson);
      var vat = Vat(taxJson['name'], double.parse(taxJson['value'].toString()));
      var product = Product(
          id: productJson['id'],
          name: productJson['name'],
          dateAdded: productJson['date_added'],
          variants: variantList,
          vat: vat);
      idForProductMap[product.id] = product;
      products.add(product);
    }

    return products;
  }

  List<Variant> _parseVariantForEachProduct(dynamic productJson) {
    var variants = List<Variant>();
    var variantList = productJson['variants'] as List<dynamic>;
    for (int i = 0; i < variantList.length; i++) {
      var variantJson = variantList[i];

      variants.add(Variant(variantJson['id'], variantJson['color'],
          variantJson['size'], double.parse(variantJson['price'].toString())));
      print("variantList ${[variantList[i]]}");
    }

    return variants;
  }

  void _updateProductsRankingType(
      List rankingList, Map<int, Product> idForProductMap) {

    /// for updating view count
    if (rankingList != null && rankingList.length > 0) {
      var rankingJson = rankingList[0];
      var productRankingList = rankingJson["products"] as List<dynamic>;
      for (int i = 0; i < productRankingList.length; i++) {
        var viewJson = productRankingList[i];
        var product = idForProductMap[viewJson['id']];
        product.viewCount = viewJson['view_count'];
      }
      print(rankingJson);
    }

    /// for updating order count
    if (rankingList != null && rankingList.length > 1) {
      var rankingJson = rankingList[1];
      var productRankingList = rankingJson["products"] as List<dynamic>;
      for (int i = 0; i < productRankingList.length; i++) {
        var viewJson = productRankingList[i];
        var product = idForProductMap[viewJson['id']];
        product.orderCount = viewJson['order_count'];
      }
      print(rankingJson);
    }

    /// for updating share count
    if (rankingList != null && rankingList.length > 2) {
      var rankingJson = rankingList[2];
      var productRankingList = rankingJson["products"] as List<dynamic>;
      for (int i = 0; i < productRankingList.length; i++) {
        var viewJson = productRankingList[i];
        var product = idForProductMap[viewJson['id']];
        product.shareCount = viewJson['shares'];
      }
      print(rankingJson);
    }
  }

  void _assignChildCategories(Map<int, Category> idForCategoryMap, Map<int, dynamic> categoryIdForChildCategoriesIdMap) {

    for(int id in categoryIdForChildCategoriesIdMap.keys) {
      var category = idForCategoryMap[id];
      var childIdsList = categoryIdForChildCategoriesIdMap[id] as List<Category>;
      var childList = List();
      for(int i = 0; i < childIdsList.length ; i++) {
        var childCategory = idForCategoryMap[i];
        childIdsList.add(childCategory);
      }
      category?.subCategories = childList;
    }

  }
}
