import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../contants/api_endpoints.dart';
import '../contants/app_contants.dart';
import '../contants/status_codes.dart';
import '../utils/storage_service.dart';
import 'network_exceptions.dart';

/// Centralized API Client using Dio
/// Handles all HTTP requests with proper error handling and interceptors
class ApiClient {
  static ApiClient? _instance;
  late Dio _dio;

  ApiClient._internal() {
    _dio = Dio();
    _setupInterceptors();
  }

  /// Singleton instance
  static ApiClient get instance {
    _instance ??= ApiClient._internal();
    return _instance!;
  }

  /// Get Dio instance
  Dio get dio => _dio;

  /// Setup Dio configuration and interceptors
  void _setupInterceptors() {
    // Base options
    _dio.options = BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: AppConstants.connectionTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      sendTimeout: AppConstants.sendTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Add interceptors
    _dio.interceptors.addAll([
      _AuthInterceptor(),
      _LoggingInterceptor(),
      _ErrorInterceptor(),
    ]);
  }

  /// GET request
  Future<Response<T>> get<T>(
      String path, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      throw NetworkExceptions.handleDioError(e);
    }
  }

  /// POST request
  Future<Response<T>> post<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      throw NetworkExceptions.handleDioError(e);
    }
  }

  /// PUT request
  Future<Response<T>> put<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final response = await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      throw NetworkExceptions.handleDioError(e);
    }
  }

  /// PATCH request
  Future<Response<T>> patch<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final response = await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      throw NetworkExceptions.handleDioError(e);
    }
  }

  /// DELETE request
  Future<Response<T>> delete<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try {
      final response = await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      throw NetworkExceptions.handleDioError(e);
    }
  }

  /// Upload file
  Future<Response<T>> uploadFile<T>(
      String path,
      File file, {
        String fieldName = 'file',
        Map<String, dynamic>? data,
        ProgressCallback? onSendProgress,
        CancelToken? cancelToken,
      }) async {
    try {
      final fileName = file.path.split('/').last;
      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(file.path, filename: fileName),
        ...?data,
      });

      final response = await _dio.post<T>(
        path,
        data: formData,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
      );
      return response;
    } catch (e) {
      throw NetworkExceptions.handleDioError(e);
    }
  }

  /// Download file
  Future<Response> downloadFile(
      String url,
      String savePath, {
        ProgressCallback? onReceiveProgress,
        CancelToken? cancelToken,
      }) async {
    try {
      final response = await _dio.download(
        url,
        savePath,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      throw NetworkExceptions.handleDioError(e);
    }
  }

  /// Set authorization token
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Remove authorization token
  void removeAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  /// Update base URL
  void updateBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  /// Clear all interceptors and recreate
  void resetInterceptors() {
    _dio.interceptors.clear();
    _setupInterceptors();
  }
}

/// Authentication Interceptor
/// Handles token refresh and authentication logic
///
class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Add any auth-related headers or logic here
    // For example, add user agent, device info, etc.
    options.headers['User-Agent'] = 'LocalConnect-Mobile/1.0.0';
    options.headers['X-Platform'] = Platform.isAndroid ? 'android' : 'ios';

    // Automatically add token from secure storage if available
    // Skip for login and register endpoints
    final isAuthEndpoint = options.path.contains('/login/') ||
        options.path.contains('/signup/') ||
        options.path.contains('/send-otp/') ||
        options.path.contains('/verify-otp/');

    if (!isAuthEndpoint) {
      try {
        final token = await StorageService.instance.getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error loading token: $e');
        }
      }
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle token refresh on 401 errors
    if (err.response?.statusCode == StatusCodes.unauthorized) {
      // Clear invalid token
      await StorageService.instance.deleteToken();
      ApiClient.instance.removeAuthToken();
      // Implement token refresh logic here if needed
      // For now, just pass through
    }

    super.onError(err, handler);
  }
}

/// Logging Interceptor
/// Logs all HTTP requests and responses in debug mode
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      print('🚀 REQUEST[${options.method}] => PATH: ${options.path}');
      print('Headers: ${options.headers}');
      print('QueryParameters: ${options.queryParameters}');
      if (options.data != null) {
        print('Data: ${options.data}');
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print(
        '✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
      );
      print('Data: ${response.data}');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print(
        '❌ ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
      );
      print('Message: ${err.message}');
      print('Data: ${err.response?.data}');
    }
    super.onError(err, handler);
  }
}

/// Error Interceptor
/// Handles global error processing and formatting
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Process and format errors before passing them on
    NetworkExceptions.handleDioError(err);

    // You can add global error handling logic here
    // For example, show global error dialogs, logout user on certain errors, etc.

    super.onError(err, handler);
  }
}

/// API Response wrapper
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final int? statusCode;
  final Map<String, dynamic>? errors;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.statusCode,
    this.errors,
  });

  factory ApiResponse.fromResponse(Response response) {
    final responseData = response.data;

    if (responseData is Map<String, dynamic>) {
      return ApiResponse<T>(
        success: StatusCodes.isSuccess(response.statusCode ?? 0),
        data: responseData['data'] as T?,
        message: responseData['message'] as String?,
        statusCode: response.statusCode,
        errors: responseData['errors'] as Map<String, dynamic>?,
      );
    }

    return ApiResponse<T>(
      success: StatusCodes.isSuccess(response.statusCode ?? 0),
      data: responseData as T?,
      statusCode: response.statusCode,
    );
  }

  factory ApiResponse.error({
    required String message,
    int? statusCode,
    Map<String, dynamic>? errors,
  }) {
    return ApiResponse<T>(
      success: false,
      message: message,
      statusCode: statusCode,
      errors: errors,
    );
  }
}
