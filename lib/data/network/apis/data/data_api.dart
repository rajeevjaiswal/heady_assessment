import 'dart:async';

import 'package:heady/data/network/constants/endpoints.dart';
import 'package:heady/data/network/dio_client.dart';

class DataApi {
  // dio instance
  final DioClient _dioClient;

  // injecting dio instance
  DataApi(this._dioClient);

  /// Returns list of e-commerce data in response
  Future<dynamic> getData() async {
    try {
      return await _dioClient.get(Endpoints.getData);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
