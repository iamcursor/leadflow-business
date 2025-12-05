import 'dart:io';
import 'package:dio/dio.dart';

import '../contants/status_codes.dart';

/// Network Exception Classes
/// Handles different types of network errors with proper categorization
abstract class NetworkExceptions implements Exception {
  const NetworkExceptions();

  /// Handle Dio errors and convert them to appropriate NetworkException
  static NetworkExceptions handleDioError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return const ConnectionTimeoutException();
        case DioExceptionType.sendTimeout:
          return const SendTimeoutException();
        case DioExceptionType.receiveTimeout:
          return const ReceiveTimeoutException();
        case DioExceptionType.badResponse:
          return _handleResponseError(error.response);
        case DioExceptionType.cancel:
          return const RequestCancelledException();
        case DioExceptionType.connectionError:
          return _handleConnectionError(error.error);
        case DioExceptionType.badCertificate:
          return const BadCertificateException();
        case DioExceptionType.unknown:
          return _handleUnknownError(error.error);
      }
    } else if (error is SocketException) {
      return const NoInternetConnectionException();
    } else if (error is HttpException) {
      return ServerException(
        message: error.message,
        statusCode: StatusCodes.internalServerError,
      );
    } else {
      return UnknownException(error.toString());
    }
  }

  /// Handle response errors (4xx, 5xx status codes)
  static NetworkExceptions _handleResponseError(Response? response) {
    final statusCode = response?.statusCode ?? StatusCodes.unknownError;
    final message = _extractErrorMessage(response?.data);

    if (StatusCodes.isClientError(statusCode)) {
      return ClientException(
        message: message ?? StatusCodes.getErrorMessage(statusCode),
        statusCode: statusCode,
      );
    } else if (StatusCodes.isServerError(statusCode)) {
      return ServerException(
        message: message ?? StatusCodes.getErrorMessage(statusCode),
        statusCode: statusCode,
      );
    } else {
      return UnknownException(
        message ?? StatusCodes.getErrorMessage(statusCode),
      );
    }
  }

  /// Handle connection errors
  static NetworkExceptions _handleConnectionError(dynamic error) {
    if (error is SocketException) {
      return const NoInternetConnectionException();
    } else {
      return UnknownException(error.toString());
    }
  }

  /// Handle unknown errors
  static NetworkExceptions _handleUnknownError(dynamic error) {
    if (error is SocketException) {
      return const NoInternetConnectionException();
    } else {
      return UnknownException(error.toString());
    }
  }

  /// Extract error message from response data
  static String? _extractErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message'] as String? ??
          data['error'] as String? ??
          data['detail'] as String?;
    } else if (data is String) {
      return data;
    }
    return null;
  }

  /// Get user-friendly error message
  String get message;

  /// Get error status code
  int? get statusCode;

  /// Check if error should trigger retry
  bool get shouldRetry;

  /// Check if error requires authentication
  bool get requiresAuth;
}

/// No Internet Connection Exception
class NoInternetConnectionException extends NetworkExceptions {
  const NoInternetConnectionException();

  @override
  String get message =>
      StatusCodes.getErrorMessage(StatusCodes.noInternetConnection);

  @override
  int get statusCode => StatusCodes.noInternetConnection;

  @override
  bool get shouldRetry => true;

  @override
  bool get requiresAuth => false;
}

/// Connection Timeout Exception
class ConnectionTimeoutException extends NetworkExceptions {
  const ConnectionTimeoutException();

  @override
  String get message =>
      StatusCodes.getErrorMessage(StatusCodes.connectionTimeout);

  @override
  int get statusCode => StatusCodes.connectionTimeout;

  @override
  bool get shouldRetry => true;

  @override
  bool get requiresAuth => false;
}

/// Send Timeout Exception
class SendTimeoutException extends NetworkExceptions {
  const SendTimeoutException();

  @override
  String get message => 'Request send timeout. Please try again.';

  @override
  int get statusCode => StatusCodes.connectionTimeout;

  @override
  bool get shouldRetry => true;

  @override
  bool get requiresAuth => false;
}

/// Receive Timeout Exception
class ReceiveTimeoutException extends NetworkExceptions {
  const ReceiveTimeoutException();

  @override
  String get message => 'Request receive timeout. Please try again.';

  @override
  int get statusCode => StatusCodes.gatewayTimeout;

  @override
  bool get shouldRetry => true;

  @override
  bool get requiresAuth => false;
}

/// Request Cancelled Exception
class RequestCancelledException extends NetworkExceptions {
  const RequestCancelledException();

  @override
  String get message =>
      StatusCodes.getErrorMessage(StatusCodes.requestCancelled);

  @override
  int get statusCode => StatusCodes.requestCancelled;

  @override
  bool get shouldRetry => false;

  @override
  bool get requiresAuth => false;
}

/// Bad Certificate Exception
class BadCertificateException extends NetworkExceptions {
  const BadCertificateException();

  @override
  String get message => 'SSL certificate verification failed.';

  @override
  int? get statusCode => null;

  @override
  bool get shouldRetry => false;

  @override
  bool get requiresAuth => false;
}

/// Client Exception (4xx errors)
class ClientException extends NetworkExceptions {
  final String _message;
  final int _statusCode;

  const ClientException({required String message, required int statusCode})
      : _message = message,
        _statusCode = statusCode;

  @override
  String get message => _message;

  @override
  int get statusCode => _statusCode;

  @override
  bool get shouldRetry => StatusCodes.shouldRetry(_statusCode);

  @override
  bool get requiresAuth => StatusCodes.requiresAuth(_statusCode);
}

/// Server Exception (5xx errors)
class ServerException extends NetworkExceptions {
  final String _message;
  final int _statusCode;

  const ServerException({required String message, required int statusCode})
      : _message = message,
        _statusCode = statusCode;

  @override
  String get message => _message;

  @override
  int get statusCode => _statusCode;

  @override
  bool get shouldRetry => StatusCodes.shouldRetry(_statusCode);

  @override
  bool get requiresAuth => false;
}

/// Unknown Exception
class UnknownException extends NetworkExceptions {
  final String _message;

  const UnknownException(this._message);

  @override
  String get message =>
      _message.isNotEmpty ? _message : 'An unexpected error occurred.';

  @override
  int get statusCode => StatusCodes.unknownError;

  @override
  bool get shouldRetry => false;

  @override
  bool get requiresAuth => false;
}

/// Extension for easy error handling
extension NetworkExceptionsExtension on NetworkExceptions {
  /// Check if error is network related
  bool get isNetworkError {
    return this is NoInternetConnectionException ||
        this is ConnectionTimeoutException ||
        this is SendTimeoutException ||
        this is ReceiveTimeoutException;
  }

  /// Check if error is client error
  bool get isClientError => this is ClientException;

  /// Check if error is server error
  bool get isServerError => this is ServerException;

  /// Check if error is authentication related
  bool get isAuthError {
    return requiresAuth ||
        (statusCode == StatusCodes.unauthorized) ||
        (statusCode == StatusCodes.forbidden);
  }

  /// Get error category for analytics/logging
  String get errorCategory {
    if (this is NoInternetConnectionException) return 'network';
    if (this is ConnectionTimeoutException) return 'timeout';
    if (this is SendTimeoutException) return 'timeout';
    if (this is ReceiveTimeoutException) return 'timeout';
    if (this is RequestCancelledException) return 'cancelled';
    if (this is ClientException) return 'client_error';
    if (this is ServerException) return 'server_error';
    return 'unknown';
  }

  /// Get retry delay duration based on error type
  Duration get retryDelay {
    if (this is ConnectionTimeoutException) return const Duration(seconds: 2);
    if (this is SendTimeoutException) return const Duration(seconds: 2);
    if (this is ReceiveTimeoutException) return const Duration(seconds: 2);
    if (this is ServerException && statusCode == StatusCodes.tooManyRequests) {
      return const Duration(seconds: 5);
    }
    return const Duration(seconds: 1);
  }
}
