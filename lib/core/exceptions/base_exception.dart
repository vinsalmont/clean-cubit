import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// A function type that takes a [BaseException] as its parameter and returns
/// `void`.
///
/// This function can be used as a callback to observe all [BaseException]
/// instances.
typedef ExceptionObserver = void Function(BaseException exception);

/// The core [Exception] class - every class that represents an [Exception]
/// should extend from [BaseException].
///
/// The difference between throwing an [Error] and an [Exception] can be found
/// in their respective declarations in
/// `dart.core`.
@immutable
abstract class BaseException extends Equatable implements Exception {
  /// Creates a new instance of [BaseException].
  ///
  /// The [type] parameter is required and should be one of the values defined
  /// in the [ExceptionType] enum.
  /// The [debugInfo] parameter is an optional string that holds debug
  /// information about the exception.
  /// The [message] parameter is an optional server exception message that may
  /// be used to present relevant information to the user when no additional
  /// context is available.
  /// The [triggerObserver] parameter is an optional boolean that indicates
  /// whether the [BaseException.observer] callback should be triggered.
  /// This is set to `true` by default.
  BaseException({
    required this.type,
    this.debugInfo,
    this.message,
    bool triggerObserver = true,
  }) {
    if (triggerObserver) {
      observer?.call(this);
    }
  }

  /// The type of the exception.
  final ExceptionType type;

  /// Holds exception debug information.
  final String? debugInfo;

  /// Optional server exception message.
  ///
  /// May be used to present relevant information to the user when no additional
  ///  context is available.
  final String? message;

  /// Unique instance to observe all [BaseException] instances
  ///
  /// This observer is called whenever the constructor body -
  /// of a new [BaseException] instance - runs.
  static ExceptionObserver? observer;

  @override
  List<Object> get props => [type];

  @override
  String toString() => '''
  [BaseException - $type] $debugInfo.
  Server message: $message
  ''';
}

/// An enum that defines the types of exceptions that can be thrown.
enum ExceptionType {
  unexpected,

  // InconsistentStateError
  inconsistentState,
  coordinatorInconsistentState,
  serviceInconsistentState,
  gatewayInconsistentState,
  repositoryInconsistentState,
  cubitInconsistentState,
  layoutInconsistentState,

  // HTTP
  serverHttp,
  timeoutHttp,
  handshakeHttp,
  socketHttp,
  unknownHttp,
  missingAuthToken,
}
