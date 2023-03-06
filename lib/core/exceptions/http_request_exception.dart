import 'package:clean_cubit/core/exceptions/base_exception.dart';

/// Exception class representing errors that can occur during HTTP requests.
class HttpRequestException extends BaseException {
  /// Constructs a [HttpRequestException] instance for a server response with an error status code.
  ///
  /// The [statusCode] and [debugInfo] parameters are required, and the [message] parameter is optional.
  HttpRequestException.serverResponse({
    required this.statusCode,
    required String debugInfo,
    String? message,
  }) : super(
          type: ExceptionType.serverHttp,
          debugInfo: debugInfo,
          message: message,
        );

  /// Constructs a [HttpRequestException] instance for a timeout error.
  ///
  /// The [statusCode] parameter is null, and the [type] parameter is set to [ExceptionType.timeoutHttp].
  HttpRequestException.timeout()
      : statusCode = null,
        super(
          type: ExceptionType.timeoutHttp,
        );

  /// Constructs a [HttpRequestException] instance for a handshake error.
  ///
  /// The [statusCode] parameter is null, and the [type] parameter is set to [ExceptionType.handshakeHttp].
  HttpRequestException.handshake()
      : statusCode = null,
        super(
          type: ExceptionType.handshakeHttp,
        );

  /// Constructs a [HttpRequestException] instance for a socket error.
  ///
  /// The [statusCode] parameter is null, and the [type] parameter is set to [ExceptionType.socketHttp].
  HttpRequestException.socket()
      : statusCode = null,
        super(
          type: ExceptionType.socketHttp,
        );

  /// Constructs a [HttpRequestException] instance for an unknown error.
  ///
  /// The [statusCode] parameter is null, and the [type] parameter is set to [ExceptionType.unknownHttp].
  /// The [debugInfo] parameter is set to 'Http request/response failed. Message: "$message".'
  /// The [message] parameter is required.
  HttpRequestException.unknown({
    required String message,
  })  : statusCode = null,
        super(
          type: ExceptionType.unknownHttp,
          debugInfo: 'Http request/response failed. Message: "$message".',
        );

  /// Constructs a [HttpRequestException] instance for a missing authentication token error.
  ///
  /// The [statusCode] parameter is set to 500, and the [type] parameter is set to [ExceptionType.missingAuthToken].
  /// The [debugInfo] parameter is set to 'Missing auth token when trying to make a request.'.
  HttpRequestException.missingAuth()
      : statusCode = 500,
        super(
          type: ExceptionType.missingAuthToken,
          debugInfo: 'Missing auth token when trying to make a request.',
        );

  /// The HTTP status code associated with the exception, or null if not applicable.
  final int? statusCode;
}
