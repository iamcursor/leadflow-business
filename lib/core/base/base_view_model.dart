import 'package:flutter/foundation.dart';

import '../contants/status_codes.dart';
import '../network/network_exceptions.dart';

/// Base View Model for MVVM Architecture
/// Provides common functionality for all view models
abstract class BaseViewModel extends ChangeNotifier {
  ApiResponseStatus _status = ApiResponseStatus.loading;
  String? _errorMessage;
  NetworkExceptions? _exception;

  // Getters
  ApiResponseStatus get status => _status;
  String? get errorMessage => _errorMessage;
  NetworkExceptions? get exception => _exception;
  bool get isLoading => _status == ApiResponseStatus.loading;
  bool get isSuccess => _status == ApiResponseStatus.success;
  bool get isError => _status == ApiResponseStatus.error;
  bool get hasNoData => _status == ApiResponseStatus.noData;
  bool get hasNoInternet => _status == ApiResponseStatus.noInternet;

  /// Set loading state
  void setLoading() {
    _status = ApiResponseStatus.loading;
    _errorMessage = null;
    _exception = null;
    notifyListeners();
  }

  /// Set success state
  void setSuccess() {
    _status = ApiResponseStatus.success;
    _errorMessage = null;
    _exception = null;
    notifyListeners();
  }

  /// Set error state
  void setError(String message, {NetworkExceptions? exception}) {
    _status = ApiResponseStatus.error;
    _errorMessage = message;
    _exception = exception;
    notifyListeners();
  }

  /// Set no data state
  void setNoData() {
    _status = ApiResponseStatus.noData;
    _errorMessage = null;
    _exception = null;
    notifyListeners();
  }

  /// Set no internet state
  void setNoInternet() {
    _status = ApiResponseStatus.noInternet;
    _errorMessage = 'No internet connection';
    _exception = const NoInternetConnectionException();
    notifyListeners();
  }

  /// Handle network exceptions
  void handleException(NetworkExceptions exception) {
    _exception = exception;
    _errorMessage = exception.message;

    if (exception is NoInternetConnectionException) {
      _status = ApiResponseStatus.noInternet;
    } else {
      _status = ApiResponseStatus.error;
    }

    notifyListeners();
  }

  /// Execute async operation with error handling
  Future<T?> executeAsync<T>(
    Future<T> Function() operation, {
    bool showLoading = true,
    String? errorMessage,
  }) async {
    try {
      if (showLoading) setLoading();

      final result = await operation();
      setSuccess();
      return result;
    } on NetworkExceptions catch (e) {
      handleException(e);
      return null;
    } catch (e) {
      setError(errorMessage ?? 'An unexpected error occurred');
      debugPrint('Unexpected error: $e');
      return null;
    }
  }

  /// Retry last operation
  Future<void> retry() async {
    // Override in subclasses to implement retry logic
  }

  /// Reset state
  void reset() {
    _status = ApiResponseStatus.loading;
    _errorMessage = null;
    _exception = null;
    notifyListeners();
  }

  /// Dispose resources
  @override
  void dispose() {
    super.dispose();
  }
}

/// Generic List View Model
abstract class BaseListViewModel<T> extends BaseViewModel {
  List<T> _items = [];
  bool _hasMoreData = true;
  int _currentPage = 1;
  bool _isLoadingMore = false;

  // Getters
  List<T> get items => _items;
  bool get hasMoreData => _hasMoreData;
  int get currentPage => _currentPage;
  bool get isLoadingMore => _isLoadingMore;
  bool get isEmpty => _items.isEmpty && !isLoading;

  /// Load initial data
  Future<void> loadData({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _hasMoreData = true;
      _items.clear();
    }

    await executeAsync(() async {
      final newItems = await fetchData(_currentPage);

      if (newItems.isEmpty) {
        if (_items.isEmpty) {
          setNoData();
        } else {
          _hasMoreData = false;
        }
      } else {
        if (refresh) {
          _items = newItems;
        } else {
          _items.addAll(newItems);
        }

        _hasMoreData = newItems.length >= getPageSize();
        _currentPage++;
      }

      return _items;
    });
  }

  /// Load more data for pagination
  Future<void> loadMoreData() async {
    if (_isLoadingMore || !_hasMoreData) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final newItems = await fetchData(_currentPage);

      if (newItems.isEmpty) {
        _hasMoreData = false;
      } else {
        _items.addAll(newItems);
        _hasMoreData = newItems.length >= getPageSize();
        _currentPage++;
      }
    } catch (e) {
      debugPrint('Error loading more data: $e');
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// Refresh data
  Future<void> refreshData() async {
    await loadData(refresh: true);
  }

  /// Add item to list
  void addItem(T item) {
    _items.insert(0, item);
    notifyListeners();
  }

  /// Update item in list
  void updateItem(T item, bool Function(T) predicate) {
    final index = _items.indexWhere(predicate);
    if (index != -1) {
      _items[index] = item;
      notifyListeners();
    }
  }

  /// Remove item from list
  void removeItem(bool Function(T) predicate) {
    _items.removeWhere(predicate);
    notifyListeners();
  }

  /// Clear all items
  void clearItems() {
    _items.clear();
    _currentPage = 1;
    _hasMoreData = true;
    notifyListeners();
  }

  // Abstract methods to be implemented by subclasses
  Future<List<T>> fetchData(int page);
  int getPageSize();

  @override
  void reset() {
    super.reset();
    _items.clear();
    _currentPage = 1;
    _hasMoreData = true;
    _isLoadingMore = false;
  }
}

/// Generic Detail View Model
abstract class BaseDetailViewModel<T> extends BaseViewModel {
  T? _data;
  final String id;

  BaseDetailViewModel(this.id);

  // Getters
  T? get data => _data;
  bool get hasData => _data != null;

  /// Load data by ID
  Future<void> loadData() async {
    await executeAsync(() async {
      _data = await fetchData(id);
      return _data;
    });
  }

  /// Update data
  void updateData(T newData) {
    _data = newData;
    setSuccess();
  }

  /// Clear data
  void clearData() {
    _data = null;
    notifyListeners();
  }

  // Abstract method to be implemented by subclasses
  Future<T> fetchData(String id);

  @override
  void reset() {
    super.reset();
    _data = null;
  }
}

/// Form View Model Base
abstract class BaseFormViewModel extends BaseViewModel {
  final Map<String, String> _errors = {};
  bool _isSubmitting = false;

  // Getters
  Map<String, String> get errors => _errors;
  bool get isSubmitting => _isSubmitting;
  bool get isValid => _errors.isEmpty;

  /// Validate field
  void validateField(String field, String? value) {
    final error = getFieldError(field, value);
    if (error != null) {
      _errors[field] = error;
    } else {
      _errors.remove(field);
    }
    notifyListeners();
  }

  /// Validate all fields
  bool validateAll() {
    _errors.clear();
    final fields = getFieldsToValidate();

    for (final entry in fields.entries) {
      final error = getFieldError(entry.key, entry.value);
      if (error != null) {
        _errors[entry.key] = error;
      }
    }

    notifyListeners();
    return _errors.isEmpty;
  }

  /// Submit form
  Future<bool> submitForm() async {
    if (!validateAll()) return false;

    _isSubmitting = true;
    notifyListeners();

    try {
      final success = await performSubmit();
      if (success) {
        setSuccess();
      } else {
        setError('Form submission failed');
      }
      return success;
    } catch (e) {
      setError('An error occurred during submission');
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  /// Clear all errors
  void clearErrors() {
    _errors.clear();
    notifyListeners();
  }

  /// Set field error
  void setFieldError(String field, String error) {
    _errors[field] = error;
    notifyListeners();
  }

  /// Clear field error
  void clearFieldError(String field) {
    _errors.remove(field);
    notifyListeners();
  }

  // Abstract methods to be implemented by subclasses
  String? getFieldError(String field, String? value);
  Map<String, String?> getFieldsToValidate();
  Future<bool> performSubmit();

  @override
  void reset() {
    super.reset();
    _errors.clear();
    _isSubmitting = false;
  }
}
