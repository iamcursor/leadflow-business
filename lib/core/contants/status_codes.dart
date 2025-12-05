/// HTTP Status Codes and API Response Constants
/// Provides standardized status code handling for API responses
class StatusCodes {
  StatusCodes._();

  // Success Status Codes (2xx)
  static const int ok = 200;
  static const int created = 201;
  static const int accepted = 202;
  static const int noContent = 204;

  // Client Error Status Codes (4xx)
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int methodNotAllowed = 405;
  static const int conflict = 409;
  static const int unprocessableEntity = 422;
  static const int tooManyRequests = 429;

  // Server Error Status Codes (5xx)
  static const int internalServerError = 500;
  static const int badGateway = 502;
  static const int serviceUnavailable = 503;
  static const int gatewayTimeout = 504;

  // Custom App Status Codes
  static const int noInternetConnection = 1000;
  static const int connectionTimeout = 1001;
  static const int requestCancelled = 1002;
  static const int unknownError = 1003;

  /// Check if status code indicates success
  static bool isSuccess(int statusCode) {
    return statusCode >= 200 && statusCode < 300;
  }

  /// Check if status code indicates client error
  static bool isClientError(int statusCode) {
    return statusCode >= 400 && statusCode < 500;
  }

  /// Check if status code indicates server error
  static bool isServerError(int statusCode) {
    return statusCode >= 500 && statusCode < 600;
  }

  /// Get user-friendly error message for status code
  static String getErrorMessage(int statusCode) {
    switch (statusCode) {
    // Success messages
      case ok:
        return 'Request successful';
      case created:
        return 'Resource created successfully';
      case accepted:
        return 'Request accepted';
      case noContent:
        return 'No content available';

    // Client error messages
      case badRequest:
        return 'Invalid request. Please check your input and try again.';
      case unauthorized:
        return 'Authentication required. Please login to continue.';
      case forbidden:
        return 'Access denied. You don\'t have permission to perform this action.';
      case notFound:
        return 'The requested resource was not found.';
      case methodNotAllowed:
        return 'This operation is not allowed.';
      case conflict:
        return 'A conflict occurred. The resource already exists.';
      case unprocessableEntity:
        return 'The request contains invalid data. Please check and try again.';
      case tooManyRequests:
        return 'Too many requests. Please wait a moment and try again.';

    // Server error messages
      case internalServerError:
        return 'Server error occurred. Please try again later.';
      case badGateway:
        return 'Service temporarily unavailable. Please try again later.';
      case serviceUnavailable:
        return 'Service is currently unavailable. Please try again later.';
      case gatewayTimeout:
        return 'Request timeout. Please check your connection and try again.';

    // Custom error messages
      case noInternetConnection:
        return 'No internet connection. Please check your network and try again.';
      case connectionTimeout:
        return 'Connection timeout. Please try again.';
      case requestCancelled:
        return 'Request was cancelled.';
      case unknownError:
        return 'An unexpected error occurred. Please try again.';

      default:
        return 'An error occurred. Please try again.';
    }
  }

  /// Get status category name
  static String getStatusCategory(int statusCode) {
    if (isSuccess(statusCode)) {
      return 'Success';
    } else if (isClientError(statusCode)) {
      return 'Client Error';
    } else if (isServerError(statusCode)) {
      return 'Server Error';
    } else if (statusCode >= 1000 && statusCode < 2000) {
      return 'Network Error';
    } else {
      return 'Unknown Error';
    }
  }

  /// Check if error should be retried
  static bool shouldRetry(int statusCode) {
    return statusCode == connectionTimeout ||
        statusCode == gatewayTimeout ||
        statusCode == serviceUnavailable ||
        statusCode == badGateway ||
        statusCode == tooManyRequests;
  }

  /// Check if error requires user authentication
  static bool requiresAuth(int statusCode) {
    return statusCode == unauthorized || statusCode == forbidden;
  }
}

/// API Response Status Enum
enum ApiResponseStatus {
  success,
  loading,
  error,
  noData,
  noInternet,
  timeout,
  cancelled,
}

/// Extension for ApiResponseStatus
extension ApiResponseStatusExtension on ApiResponseStatus {
  bool get isSuccess => this == ApiResponseStatus.success;
  bool get isLoading => this == ApiResponseStatus.loading;
  bool get isError => this == ApiResponseStatus.error;
  bool get hasNoData => this == ApiResponseStatus.noData;
  bool get hasNoInternet => this == ApiResponseStatus.noInternet;
  bool get isTimeout => this == ApiResponseStatus.timeout;
  bool get isCancelled => this == ApiResponseStatus.cancelled;

  String get message {
    switch (this) {
      case ApiResponseStatus.success:
        return 'Operation completed successfully';
      case ApiResponseStatus.loading:
        return 'Loading...';
      case ApiResponseStatus.error:
        return 'An error occurred';
      case ApiResponseStatus.noData:
        return 'No data available';
      case ApiResponseStatus.noInternet:
        return 'No internet connection';
      case ApiResponseStatus.timeout:
        return 'Request timeout';
      case ApiResponseStatus.cancelled:
        return 'Request cancelled';
    }
  }
}
