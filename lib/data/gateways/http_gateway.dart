import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:clean_cubit/core/exceptions/http_request_exception.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:logger/logger.dart' as log;

class _Response {
  _Response.fromHttpResponse(dio.Response response)
      : statusCode = response.statusCode!,
        data = _parseData(response.data);

  final int statusCode;
  final JSON data;

  static JSON _parseData(data) {
    if (data == null || data.isEmpty || data == 'success') {
      return <String, dynamic>{};
    }

    try {
      final decodedData = jsonDecode(data);
      if (decodedData is Map<String, dynamic>) {
        return decodedData;
      } else if (decodedData is List<dynamic>) {
        return {'data': decodedData};
      } else {
        return <String, dynamic>{};
      }
    } catch (e) {
      return <String, dynamic>{};
    }
  }
}

typedef JSON = Map<String, dynamic>;
typedef Headers = Map<String, String>;

abstract class HttpGateway {
  Future<JSON> get({required String path, JSON? queryParams, Headers headers});

  Future<JSON> post(
      {required String path, JSON? queryParams, Headers headers, JSON? body});

  Future<JSON> patch(
      {required String path, JSON? queryParams, Headers headers, JSON? body});

  Future<JSON> delete(
      {required String path, JSON? queryParams, Headers headers, JSON? body});
}

class HttpGatewayImpl extends HttpGateway {
  HttpGatewayImpl({
    required String baseUrl,
    required bool isDebug,
    dio.Dio? dioInstance,
    log.Logger? logger,
  })  : _baseUrl = baseUrl,
        _dio = dioInstance ??
            (dio.Dio(
              dio.BaseOptions(
                baseUrl: baseUrl,
                connectTimeout: const Duration(seconds: 5),
                receiveTimeout: const Duration(seconds: 10),
              ),
            )..interceptors.add(
                DioCacheInterceptor(
                  options: CacheOptions(
                    store: MemCacheStore(),
                  ),
                ),
              )),
        _logger =
            logger ?? log.Logger(printer: log.PrettyPrinter(methodCount: 0)),
        _isDebug = isDebug;

  final String _baseUrl;
  final dio.Dio _dio;
  final log.Logger _logger;
  final bool _isDebug;

  @override
  Future<JSON> get(
      {required String path,
      JSON? queryParams,
      Headers headers = const {}}) async {
    try {
      _logRequest(method: 'GET', path: path, headers: headers);
      final response = await _dio.get<String>(path,
          options: dio.Options(headers: headers), queryParameters: queryParams);
      final responseData = _Response.fromHttpResponse(response);
      _logResponse(method: 'GET', path: path, response: response);

      return responseData.data;
    } catch (exception) {
      throw _handleException(exception);
    }
  }

  @override
  Future<JSON> post(
      {required String path,
      JSON? queryParams,
      Headers headers = const {},
      JSON? body}) async {
    try {
      final formattedHeaders = headers;
      if (body != null) {
        formattedHeaders.addAll({'Content-Type': 'application/json'});
      }

      _logRequest(
          method: 'POST', path: path, headers: formattedHeaders, body: body);
      final response = await _dio.post<String>(
        path,
        options: dio.Options(headers: formattedHeaders),
        queryParameters: queryParams,
        data: body != null ? jsonEncode(body) : null,
      );
      final responseData = _Response.fromHttpResponse(response);
      _logResponse(method: 'POST', path: path, response: response);

      return responseData.data.isEmpty
          ? <String, dynamic>{}
          : responseData.data;
    } catch (exception) {
      throw _handleException(exception);
    }
  }

  @override
  Future<JSON> patch(
      {required String path,
      JSON? queryParams,
      Headers headers = const {},
      JSON? body}) async {
    try {
      final formattedHeaders = headers;
      if (body != null) {
        formattedHeaders.addAll({'Content-Type': 'application/json'});
      }

      _logRequest(
          method: 'PATCH', path: path, headers: formattedHeaders, body: body);
      final response = await _dio.patch<String>(
        path,
        options: dio.Options(headers: formattedHeaders),
        queryParameters: queryParams,
        data: body != null ? jsonEncode(body) : null,
      );
      final responseData = _Response.fromHttpResponse(response);
      _logResponse(method: 'PATCH', path: path, response: response);

      return responseData.data.isEmpty
          ? <String, dynamic>{}
          : responseData.data;
    } catch (exception) {
      throw _handleException(exception);
    }
  }

  @override
  Future<JSON> delete(
      {required String path,
      JSON? queryParams,
      Headers headers = const {},
      JSON? body}) async {
    try {
      final formattedHeaders = headers;
      if (body != null) {
        formattedHeaders.addAll({'Content-Type': 'application/json'});
      }

      _logRequest(
          method: 'DELETE', path: path, headers: formattedHeaders, body: body);
      final response = await _dio.delete<String>(
        path,
        options: dio.Options(headers: formattedHeaders),
        queryParameters: queryParams,
        data: body != null ? jsonEncode(body) : null,
      );
      final responseData = _Response.fromHttpResponse(response);
      _logResponse(method: 'DELETE', path: path, response: response);

      return responseData.data.isEmpty
          ? <String, dynamic>{}
          : responseData.data;
    } catch (exception) {
      throw _handleException(exception);
    }
  }

  void _logRequest(
      {required String method,
      required String path,
      Headers headers = const {},
      JSON? body}) {
    if (!_isDebug) {
      return;
    }

    _logger.i(
        '[HTTP - $method] Request $_baseUrl$path\nHeaders: $headers\nBody:$body');
  }

  void _logResponse(
      {required String method,
      required String path,
      required dio.Response response}) {
    if (!_isDebug) {
      return;
    }

    _logger.i(
      '[HTTP - $method] Response - $_baseUrl$path\nHeaders: ${response.headers}\nCode:${response.statusCode}\nBody:${response.data}',
    );
  }

  Object _handleException(Object exception) {
    if (exception is dio.DioError &&
        exception.type == dio.DioErrorType.connectionTimeout) {
      return HttpRequestException.timeout();
    }
    if (exception is TimeoutException) {
      return HttpRequestException.timeout();
    }
    if (exception is HandshakeException) {
      return HttpRequestException.handshake();
    }
    if (exception is SocketException) {
      return HttpRequestException.socket();
    }
    if (exception is dio.DioError &&
        exception.type == dio.DioErrorType.badResponse) {
      final path = exception.requestOptions.path;
      final response = exception.response;
      final statusCode = response?.statusCode;
      final data = response != null
          ? jsonDecode(response.data as String) as Map<String, dynamic>?
          : null;
      final debugInfo =
          'GET $path - Failed with status code $statusCode - $data';
      final message = data?['message'] as String?;
      return HttpRequestException.serverResponse(
          debugInfo: debugInfo, statusCode: statusCode, message: message);
    }

    return HttpRequestException.unknown(message: exception.toString());
  }
}
