import 'package:app/core/data/api.dart';
import 'package:app/core/data/base_api_impl.dart';
import 'package:app/core/models/api/api_response.dart';
import 'package:app/injector.dart';
import 'package:dio/dio.dart';

class BaseAPI implements BaseAPIImpl {
  Dio? _dio;

  final endpoint = locator<Api>();

  BaseAPI({Dio? dio}) {
    _dio = dio ?? Dio();
  }

  Options getHeaders({bool? useToken}) {
    var header = <String, dynamic>{};
    header['Accept'] = 'application/json';
    header['Content-Type'] = 'application/json';
    if (useToken == true) {
      header['Authorization'] = 'Bearer <token>';
    }
    return Options(
        headers: header,
        sendTimeout: 60 * 1000, // 60 seconds
        receiveTimeout: 60 * 1000 // 60 seconds
        );
  }

  @override
  Future<APIResponse> delete(String url,
      {Map<String, dynamic>? param, bool? useToken}) {
    throw UnimplementedError();
  }

  @override
  Future<APIResponse> get(String url,
      {Map<String, dynamic>? param, bool? useToken}) async {
    try {
      final result = await _dio?.get(
        url,
        queryParameters: param,
        options: getHeaders(useToken: useToken),
      );
      return _parseResponse(result);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<APIResponse> post(String url,
      {Map<String, dynamic>? param, data, bool? useToken}) {
    throw UnimplementedError();
  }

  @override
  Future<APIResponse> put(String url,
      {Map<String, dynamic>? param, data, bool? useToken}) {
    throw UnimplementedError();
  }

  Future<APIResponse> _parseResponse(Response? response) async {
    return APIResponse.fromJson({
      'statusCode': response?.statusCode,
      'data': response?.data,
    });
  }
}
