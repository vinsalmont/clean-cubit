import 'dart:convert';

import 'package:clean_cubit/core/exceptions/http_request_exception.dart';
import 'package:clean_cubit/data/gateways/http_gateway.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements dio.Dio {}

class MockResponse<T> extends Mock implements dio.Response<T> {}

class MockLogger extends Mock implements Logger {}

void main() {
  late dio.Dio mockDio;
  late dio.Response mockResponse;
  late Logger mockLogger;
  late HttpGateway httpGateway;

  setUp(() {
    registerFallbackValue(Uri());

    mockDio = MockDio();
    mockResponse = MockResponse();
    mockLogger = MockLogger();
    httpGateway = HttpGatewayImpl(
      baseUrl: 'https://example.com',
      dioInstance: mockDio,
      logger: mockLogger,
      isDebug: true,
    );
  });

  tearDown(() {
    reset(mockDio);
    reset(mockResponse);
    reset(mockLogger);
  });

  group('GET - ', () {
    test('should decode empty response body', () async {
      const fakeJsonResponse = '';

      _mockDioGetResponse(
        dio: mockDio,
        response: _mockedResponse(fakeJsonResponse, 200),
      );

      final result = await httpGateway.get(path: 'path');

      expect(result, <String, dynamic>{});
    });

    test(
        'should throw an exception when the http client response is not successfully',
        () async {
      _mockDioGetErrorResponse(dio: mockDio);

      expect(
        httpGateway.get(path: 'path'),
        throwsA(isA<HttpRequestException>()),
      );
    });

    test('should return a response data when the request is successfully',
        () async {
      const fakeJsonResponse = '{"data":123}';

      _mockDioGetResponse(
        dio: mockDio,
        response: _mockedResponse(fakeJsonResponse, 200),
      );

      final response = await httpGateway.get(path: 'path');

      final expectedResponse =
          jsonDecode(fakeJsonResponse) as Map<String, dynamic>;

      expect(response, expectedResponse);
    });
  });

  group('POST - ', () {
    test(
        'should throw an exception when http client response is not successfully',
        () async {
      _mockDioPostErrorResponse(dio: mockDio);

      expect(
        () => httpGateway.post(path: 'path'),
        throwsA(isA<HttpRequestException>()),
      );
    });

    test('should return response data when the request is successfully',
        () async {
      final fakeHeaders = {'header': '1'};
      const fakeResponseBody = '{"data":123}';

      _mockDioPostResponse(
        dio: mockDio,
        response: _mockedResponse(fakeResponseBody, 200),
      );

      final result = await httpGateway.post(path: 'path', headers: fakeHeaders);

      final expectedResponse =
          jsonDecode(fakeResponseBody) as Map<String, dynamic>;

      expect(result, expectedResponse);
    });

    test('should pass body to dio when the body is not empty', () async {
      final fakeBody = {'data': 1234};
      final fakeHeaders = {'header': '1'};
      const fakeResponseBody = '{"data":123}';

      _mockDioPostResponse(
        dio: mockDio,
        response: _mockedResponse(fakeResponseBody, 200),
      );

      await httpGateway.post(
        path: 'path',
        headers: fakeHeaders,
        body: fakeBody,
      );

      final expectedBody = jsonEncode(fakeBody);

      verify(
        () => mockDio.post<String>(
          any(),
          options: any(named: 'options'),
          data: expectedBody,
        ),
      ).called(1);
    });
  });

  group('PATCH - ', () {
    test(
        'should throw an exception when http client response is not successfully',
        () async {
      _mockDioPatchErrorResponse(dio: mockDio);

      expect(
        () => httpGateway.patch(path: 'path'),
        throwsA(isA<HttpRequestException>()),
      );
    });

    test('should return response data when the request is successfully',
        () async {
      final fakeHeaders = {'header': '1'};
      const fakeResponseBody = '{"data":123}';

      _mockDioPatchResponse(
        dio: mockDio,
        response: _mockedResponse(fakeResponseBody, 200),
      );

      final result = await httpGateway.patch(
        path: 'path',
        headers: fakeHeaders,
      );

      final expectedResponse =
          jsonDecode(fakeResponseBody) as Map<String, dynamic>;

      expect(result, expectedResponse);
    });

    test('should pass body to dio when the body is not empty', () async {
      final fakeBody = {'data': 1234};
      final fakeHeaders = {'header': '1'};
      const fakeResponseBody = '{"data":123}';

      _mockDioPatchResponse(
        dio: mockDio,
        response: _mockedResponse(fakeResponseBody, 200),
      );

      await httpGateway.patch(
        path: 'path',
        headers: fakeHeaders,
        body: fakeBody,
      );

      final expectedBody = jsonEncode(fakeBody);
      verify(
        () => mockDio.patch<String>(
          any(),
          options: any(named: 'options'),
          data: expectedBody,
        ),
      ).called(1);
    });
  });

  group('DELETE - ', () {
    test(
        'should throw an exception when http client response is not successfully',
        () async {
      _mockDioDeleteErrorResponse(dio: mockDio);

      expect(
        () => httpGateway.delete(path: 'path'),
        throwsA(isA<HttpRequestException>()),
      );
    });
    test('should return response data when the request is successfully',
        () async {
      final fakeHeaders = {'header': '1'};
      const fakeResponseBody = '{"data":123}';

      _mockDioDeleteResponse(
        dio: mockDio,
        response: _mockedResponse(fakeResponseBody, 200),
      );

      final result = await httpGateway.delete(
        path: 'path',
        headers: fakeHeaders,
      );

      final expectedResponse =
          jsonDecode(fakeResponseBody) as Map<String, dynamic>;

      expect(result, expectedResponse);
    });

    test('should pass body to dio when the body is not empty', () async {
      final fakeBody = {'data': 1234};
      final fakeHeaders = {'header': '1'};
      const fakeResponseBody = '{"data":123}';

      _mockDioDeleteResponse(
        dio: mockDio,
        response: _mockedResponse(fakeResponseBody, 200),
      );

      await httpGateway.delete(
        path: 'path',
        headers: fakeHeaders,
        body: fakeBody,
      );

      final expectedBody = jsonEncode(fakeBody);
      verify(
        () => mockDio.delete<String>(any(),
            options: any(named: 'options'), data: expectedBody),
      ).called(1);
    });
  });
}

dio.Response<String> _mockedResponse(
  String data,
  int statusCode, {
  dio.Headers? headers,
}) {
  final response = MockResponse<String>();
  when(() => response.statusCode).thenReturn(statusCode);
  when(() => response.data).thenReturn(data);

  if (headers != null) {
    when(() => response.headers).thenReturn(headers);
  } else {
    when(() => response.headers).thenReturn(dio.Headers());
  }

  return response;
}

void _mockDioGetResponse({
  required dio.Dio dio,
  required dio.Response<String> response,
}) =>
    when(() => dio.get<String>(
          any(),
          options: any(named: 'options'),
          queryParameters: any(named: 'queryParameters'),
        )).thenAnswer((_) => Future.value(response));

void _mockDioGetErrorResponse({
  required dio.Dio dio,
}) =>
    when(() => dio.get<String>(
          any(),
          options: any(named: 'options'),
          queryParameters: any(named: 'queryParameters'),
        )).thenThrow(Exception());

void _mockDioPostResponse({
  required dio.Dio dio,
  required dio.Response<String> response,
}) =>
    when(
      () => dio.post<String>(
        any(),
        options: any(named: 'options'),
        queryParameters: any(named: 'queryParameters'),
        data: any<dynamic>(named: 'data'),
      ),
    ).thenAnswer((_) => Future.value(response));

void _mockDioPostErrorResponse({
  required dio.Dio dio,
}) =>
    when(
      () => dio.post<String>(
        any(),
        options: any(named: 'options'),
        queryParameters: any(named: 'queryParameters'),
        data: any<dynamic>(named: 'data'),
      ),
    ).thenThrow(Exception());

void _mockDioPatchResponse({
  required dio.Dio dio,
  required dio.Response<String> response,
}) =>
    when(
      () => dio.patch<String>(
        any(),
        options: any(named: 'options'),
        queryParameters: any(named: 'queryParameters'),
        data: any<dynamic>(named: 'data'),
      ),
    ).thenAnswer((_) => Future.value(response));

void _mockDioPatchErrorResponse({
  required dio.Dio dio,
}) =>
    when(
      () => dio.patch<String>(
        any(),
        options: any(named: 'options'),
        queryParameters: any(named: 'queryParameters'),
        data: any<dynamic>(named: 'data'),
      ),
    ).thenThrow(Exception());

void _mockDioDeleteResponse({
  required dio.Dio dio,
  required dio.Response<String> response,
}) =>
    when(
      () => dio.delete<String>(
        any(),
        options: any(named: 'options'),
        queryParameters: any(named: 'queryParameters'),
        data: any<dynamic>(named: 'data'),
      ),
    ).thenAnswer((_) => Future.value(response));

void _mockDioDeleteErrorResponse({
  required dio.Dio dio,
}) =>
    when(
      () => dio.delete<String>(
        any(),
        options: any(named: 'options'),
        queryParameters: any(named: 'queryParameters'),
        data: any<dynamic>(named: 'data'),
      ),
    ).thenThrow(Exception());
