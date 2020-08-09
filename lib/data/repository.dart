import 'dart:async';

import 'package:heady/data/network/apis/data/data_api.dart';

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
      /* Log(
          className: "Repository",
          text: data.toString(),
          logLevel: LogLevel.ALL);
      print("data $data");
*/
      return data;
    }).catchError((error) => throw error);
  }
}
