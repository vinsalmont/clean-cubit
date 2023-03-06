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

/// Represents an HTTP gateway interface.
abstract class HttpGateway {
  /// Sends a GET request to the specified [path] with the optional [queryParams]
  /// and [headers], and returns the JSON response as a Future.
  Future<JSON> get({required String path, JSON? queryParams, Headers headers});

  /// Sends a POST request to the specified [path] with the optional [queryParams],
  /// [headers], and [body], and returns the JSON response as a Future.
  Future<JSON> post(
      {required String path, JSON? queryParams, Headers headers, JSON? body});

  /// Sends a PATCH request to the specified [path] with the optional [queryParams],
  /// [headers], and [body], and returns the JSON response as a Future.
  Future<JSON> patch(
      {required String path, JSON? queryParams, Headers headers, JSON? body});

  /// Sends a DELETE request to the specified [path] with the optional [queryParams],
  /// [headers], and [body], and returns the JSON response as a Future.
  Future<JSON> delete(
      {required String path, JSON? queryParams, Headers headers, JSON? body});
}

/// An implementation of the [HttpGateway] interface using the Dio package.
class HttpGatewayImpl extends HttpGateway {
  /// Creates a new [HttpGatewayImpl] instance with the specified [baseUrl],
  /// [isDebug], [dioInstance], and [logger].
  ///
  /// The [baseUrl] should be the base URL of the HTTP API.
  ///
  /// The [isDebug] flag determines whether the gateway should log requests and
  /// responses.
  ///
  /// The [dioInstance] parameter allows using a custom instance of the Dio client.
  ///
  /// The [logger] parameter allows using a custom instance of the logger.
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

  /// Logs an HTTP request.
  ///
  /// If [_isDebug] is `false`, this function does nothing.
  ///
  /// [method] is the HTTP method used for the request.
  /// [path] is the path of the request.
  /// [headers] is an optional map of headers to include in the request.
  /// [body] is an optional JSON object to include in the request body.
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

  /// Logs an HTTP response.
  ///
  /// If [_isDebug] is `false`, this function does nothing.
  ///
  /// [method] is the HTTP method used for the request.
  /// [path] is the path of the request.
  /// [response] is the HTTP response to log.
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

  /// Handles HTTP request exceptions.
  ///
  /// This function returns a corresponding [HttpRequestException] object based
  /// on the given exception object. If the exception does not match any known
  /// exception types, an unknown [HttpRequestException] is returned.
  ///
  /// [exception] is the exception to handle.
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
