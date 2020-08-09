class Endpoints {
  Endpoints._();

  // base url
  static const String baseUrl = "https://stark-spire-93433.herokuapp.com";

  // receiveTimeout
  static const int receiveTimeout = 5000;

  // connectTimeout
  static const int connectionTimeout = 3000;

  //  endpoints
  static const String getData = baseUrl + "/json";
}
