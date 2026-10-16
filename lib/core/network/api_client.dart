import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  Future<Response> get(String path) {
    return _dio.get(path);
  }

  Future<Response> post(String path, Object? data) {
    return _dio.post(path, data: data);
  }
}
