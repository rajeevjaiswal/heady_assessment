import 'dart:async';

import 'package:f_logs/model/flog/log.dart';
import 'package:heady/data/network/apis/data/data_api.dart';

class Repository {
  // api objects
  final DataApi _dataApi;

  // constructor
  Repository(
    this._dataApi,
  );

  // Post: ---------------------------------------------------------------------
  Future<dynamic> getPosts() async {
    return await _dataApi.getData().then((data) {
      Log(className: "Repository", text: data.toString());

      return data;
    }).catchError((error) => throw error);
  }
}
