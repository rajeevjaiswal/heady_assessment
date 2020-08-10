import 'dart:async';

import 'package:heady/data/local/database_helper.dart';
import 'package:heady/data/local/entity/Category.dart';
import 'package:heady/data/local/entity/product.dart';
import 'package:heady/data/local/entity/variant.dart';
import 'package:heady/data/local/entity/vat.dart';
import 'package:heady/data/network/apis/data/data_api.dart';

class Repository {
  // api objects
  final DataApi _dataApi;
  final DatabaseHelper _databaseHelper;

  // constructor
  Repository(this._dataApi, this._databaseHelper);

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
    _assignChildCategories(idForCategoryMap, categoryIdForChildCategoriesIdMap);

    /// save  parsed data in db
    _saveProductsToDatabase(idForProductMap);
    _saveCategoriesToDatabase(idForCategoryMap);
  }

  void _parseCategory(
      dynamic categoryJson,
      Map<int, Product> idForProductMap,
      Map<int, Category> idForCategoryMap,
      Map<int, dynamic> categoryIdForChildCategoriesIdMap) {
    var childCatList = categoryJson['child_categories'] as List<dynamic>;
    var tempProductList = categoryJson['products'] as List<dynamic>;

    var category = Category(
      id: categoryJson['id'],
      name: categoryJson['name'],
      productCount: tempProductList.length ?? 0,
      subCategoryCount: childCatList.length ?? 0,
      parentId: null,
    );

    _parseProductForCategory(categoryJson, idForProductMap);

    idForCategoryMap[category.id] = category;
    if (childCatList != null && childCatList.isNotEmpty) {
      categoryIdForChildCategoriesIdMap[category.id] = childCatList;
    }
  }

  void _parseProductForCategory(
      dynamic categoryJson, Map<int, Product> idForProductMap) {
    var productList = categoryJson['products'] as List<dynamic>;
    var categoryId = categoryJson['id'];

    for (int i = 0; i < productList.length; i++) {
      var productJson = productList[i];
      var taxJson = productJson['tax'];
      var product = Product(
        id: productJson['id'],
        name: productJson['name'],
        dateAdded: productJson['date_added'],
        categoryId: categoryId,
      );
      var vat = Vat(taxJson['name'], double.parse(taxJson['value'].toString()),
          productJson['id']);
      _saveVatToDatabase(vat);
      idForProductMap[product.id] = product;
      _parseVariantForEachProduct(productJson);
    }
  }

  void _parseVariantForEachProduct(dynamic productJson) {
    var productId = productJson['id'];
    var variantList = productJson['variants'] as List<dynamic>;
    for (int i = 0; i < variantList.length; i++) {
      var variantJson = variantList[i];

      var variant = Variant(
          variantJson['id'],
          variantJson['color'],
          variantJson['size'],
          double.parse(variantJson['price'].toString()),
          productId);

      /// save this data in db
      _saveVariantToDatabase(variant);
    }
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

  void _assignChildCategories(Map<int, Category> idForCategoryMap,
      Map<int, dynamic> categoryIdForChildCategoriesIdMap) {
    for (int id in categoryIdForChildCategoriesIdMap.keys) {
      var category = idForCategoryMap[id];
      var childIdsList = categoryIdForChildCategoriesIdMap[id] as List<dynamic>;
      for (int i = 0; i < childIdsList.length; i++) {
        var childCategory = idForCategoryMap[i];
        childCategory?.parentId = category?.id;
      }
    }
  }

  /// limitations in floor plugin. So need to maintain separate table for vat
  void _saveVatToDatabase(Vat vat) async {
    await _databaseHelper.saveVatToDatabase(vat);
  }

  void _saveVariantToDatabase(Variant variant) async {
    await _databaseHelper.saveVariantToDatabase(variant);
  }

  void _saveProductsToDatabase(Map<int, Product> idForProductMap) async {
    for (int id in idForProductMap.keys) {
      await _databaseHelper.saveProductToDatabase(idForProductMap[id]);
    }
  }

  void _saveCategoriesToDatabase(Map<int, Category> idForCategoryMap) async {
    for (int id in idForCategoryMap.keys) {
      await _databaseHelper.saveCategoryToDatabase(idForCategoryMap[id]);
    }
  }
}
