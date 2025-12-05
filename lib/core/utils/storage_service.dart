import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Storage Service
/// Handles secure storage operations for tokens and sensitive data
class StorageService {
  static StorageService? _instance;
  late FlutterSecureStorage _storage;

  // Storage keys
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _savedEmailKey = 'saved_email';
  static const String _savedPasswordKey = 'saved_password';

  StorageService._internal() {
    _storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device,
      ),
    );
  }

  /// Singleton instance
  static StorageService get instance {
    _instance ??= StorageService._internal();
    return _instance!;
  }

  /// Save authentication token
  Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: _tokenKey, value: token);
    } catch (e) {
      throw Exception('Failed to save token: $e');
    }
  }

  /// Get authentication token
  Future<String?> getToken() async {
    try {
      return await _storage.read(key: _tokenKey);
    } catch (e) {
      throw Exception('Failed to get token: $e');
    }
  }

  /// Save refresh token
  Future<void> saveRefreshToken(String refreshToken) async {
    try {
      await _storage.write(key: _refreshTokenKey, value: refreshToken);
    } catch (e) {
      throw Exception('Failed to save refresh token: $e');
    }
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: _refreshTokenKey);
    } catch (e) {
      throw Exception('Failed to get refresh token: $e');
    }
  }

  /// Delete authentication token
  Future<void> deleteToken() async {
    try {
      await _storage.delete(key: _tokenKey);
    } catch (e) {
      throw Exception('Failed to delete token: $e');
    }
  }

  /// Delete refresh token
  Future<void> deleteRefreshToken() async {
    try {
      await _storage.delete(key: _refreshTokenKey);
    } catch (e) {
      throw Exception('Failed to delete refresh token: $e');
    }
  }

  /// Clear all stored tokens
  Future<void> clearAllTokens() async {
    try {
      await _storage.delete(key: _tokenKey);
      await _storage.delete(key: _refreshTokenKey);
    } catch (e) {
      throw Exception('Failed to clear tokens: $e');
    }
  }

  /// Check if user is logged in (has a token)
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Save user credentials (email and password)
  Future<void> saveCredentials(String email, String password) async {
    try {
      await _storage.write(key: _savedEmailKey, value: email);
      await _storage.write(key: _savedPasswordKey, value: password);
    } catch (e) {
      throw Exception('Failed to save credentials: $e');
    }
  }

  /// Get saved email
  Future<String?> getSavedEmail() async {
    try {
      return await _storage.read(key: _savedEmailKey);
    } catch (e) {
      throw Exception('Failed to get saved email: $e');
    }
  }

  /// Get saved password
  Future<String?> getSavedPassword() async {
    try {
      return await _storage.read(key: _savedPasswordKey);
    } catch (e) {
      throw Exception('Failed to get saved password: $e');
    }
  }

  /// Check if saved credentials exist
  Future<bool> hasSavedCredentials() async {
    try {
      final email = await getSavedEmail();
      final password = await getSavedPassword();
      return email != null && email.isNotEmpty && password != null && password.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Clear saved credentials
  Future<void> clearSavedCredentials() async {
    try {
      await _storage.delete(key: _savedEmailKey);
      await _storage.delete(key: _savedPasswordKey);
    } catch (e) {
      throw Exception('Failed to clear saved credentials: $e');
    }
  }
}

