import 'package:dio/dio.dart';
import 'package:heady/data/network/apis/data/data_api.dart';
import 'package:heady/data/network/constants/endpoints.dart';
import 'package:heady/data/network/dio_client.dart';
import 'package:heady/data/repository.dart';
import 'package:inject/inject.dart';

@module
class NetworkModule {
  // ignore: non_constant_identifier_names
  final String TAG = "NetworkModule";

  // DI Providers:--------------------------------------------------------------
  /// A singleton dio provider.
  ///
  /// Calling it multiple times will return the same instance.
  @provide
  @singleton
  Dio provideDio() {
    final dio = Dio();

    dio
      ..options.baseUrl = Endpoints.baseUrl
      ..options.connectTimeout = Endpoints.connectionTimeout
      ..options.receiveTimeout = Endpoints.receiveTimeout
      ..options.headers = {'Content-Type': 'application/json; charset=utf-8'}
      ..interceptors.add(LogInterceptor(
        request: true,
        responseBody: true,
        requestBody: true,
        requestHeader: true,
      ));
    return dio;
  }

  /// A singleton dio_client provider.
  ///
  /// Calling it multiple times will return the same instance.
  @provide
  @singleton
  DioClient provideDioClient(Dio dio) => DioClient(dio);

  // Api Providers:-------------------------------------------------------------
  // Define all your api providers here
  /// A singleton data_api provider.
  ///
  /// Calling it multiple times will return the same instance.
  @provide
  @singleton
  DataApi provideDataApi(DioClient dioClient) => DataApi(dioClient);

// Api Providers End:---------------------------------------------------------

  /// A singleton repository provider.
  ///
  /// Calling it multiple times will return the same instance.
  @provide
  @singleton
  Repository provideRepository(
    DataApi postApi,
  ) =>
      Repository(postApi);
}
