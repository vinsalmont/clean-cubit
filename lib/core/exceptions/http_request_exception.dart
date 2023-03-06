import 'package:clean_cubit/core/exceptions/base_exception.dart';

class HttpRequestException extends BaseException {
  HttpRequestException.serverResponse({
    required this.statusCode,
    required String debugInfo,
    String? message,
  }) : super(
          type: ExceptionType.serverHttp,
          debugInfo: debugInfo,
          message: message,
        );

  HttpRequestException.timeout()
      : statusCode = null,
        super(
          type: ExceptionType.timeoutHttp,
        );

  HttpRequestException.handshake()
      : statusCode = null,
        super(
          type: ExceptionType.handshakeHttp,
        );

  HttpRequestException.socket()
      : statusCode = null,
        super(
          type: ExceptionType.socketHttp,
        );

  HttpRequestException.unknown({
    required String message,
  })  : statusCode = null,
        super(
          type: ExceptionType.unknownHttp,
          debugInfo: 'Http request/response failed. Message: "$message".',
        );

  HttpRequestException.missingAuth()
      : statusCode = 500,
        super(
          type: ExceptionType.missingAuthToken,
          debugInfo: 'Missing auth token when trying to make a request.',
        );

  final int? statusCode;
}
