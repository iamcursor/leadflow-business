import 'package:leadflow_business/models/auth/login_model.dart';
import 'package:leadflow_business/models/auth/reset_password_model.dart';
import 'package:leadflow_business/models/auth/send_otp_model.dart';
import 'package:leadflow_business/models/auth/verify_otp_model.dart';

import '../../core/network/api_client.dart';
import '../../core/contants/api_endpoints.dart';
import '../../models/auth/signup_model.dart';
import '../../core/network/network_exceptions.dart';

/// Sign Up Service
/// Handles user registration API calls
class SignupService {
  final ApiClient _apiClient = ApiClient.instance;

  //Login Service
  Future<Map<String, dynamic>> login(LoginModel model) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: model.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is Map<String, dynamic>) {
          return response.data as Map<String, dynamic>;
        } else {
          throw UnknownException('Invalid response format');
        }
      } else {
        throw UnknownException(
          'Login failed with status code: ${response.statusCode}',
        );
      }
    } on NetworkExceptions {
      rethrow;
    } catch (e) {
      if (e is NetworkExceptions) rethrow;
      throw UnknownException('Login failed: ${e.toString()}');
    }
  }

  //SignUp Service

  Future<Map<String, dynamic>> signUp(SignUpModel model) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.register,
        data: model.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is Map<String, dynamic>) {
          return response.data as Map<String, dynamic>;
        } else {
          throw UnknownException('Invalid response format');
        }
      } else {
        throw UnknownException(
          'Signup failed with status code: ${response.statusCode}',
        );
      }
    } on NetworkExceptions {
      rethrow;
    } catch (e) {
      if (e is NetworkExceptions) rethrow;
      throw UnknownException('Signup failed: ${e.toString()}');
    }
  }

  //Send OTP Service

  Future<Map<String, dynamic>> sendOtp(SendOtpModel model) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.sendOTP,
        data: model.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is Map<String, dynamic>) {
          return response.data as Map<String, dynamic>;
        } else {
          throw UnknownException('Invalid response format');
        }
      } else {
        throw UnknownException(
          'Sending Otp failed with status code: ${response.statusCode}',
        );
      }
    } on NetworkExceptions {
      rethrow;
    } catch (e) {
      if (e is NetworkExceptions) rethrow;
      throw UnknownException('Sending Otp failed: ${e.toString()}');
    }
  }

  //Verify OTP Service

  Future<Map<String, dynamic>> verifyOtp(VerifyOtpModel model) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.verifyOTP,
        data: model.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is Map<String, dynamic>) {
          return response.data as Map<String, dynamic>;
        } else {
          throw UnknownException('Invalid response format');
        }
      } else {
        throw UnknownException(
          'Verification Otp failed with status code: ${response.statusCode}',
        );
      }
    } on NetworkExceptions {
      rethrow;
    } catch (e) {
      if (e is NetworkExceptions) rethrow;
      throw UnknownException('Verification Otp failed: ${e.toString()}');
    }
  }

  //Reset Password Service
  Future<Map<String, dynamic>> resetPassword(ResetPasswordModel model) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.resetPassword,
        data: model.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is Map<String, dynamic>) {
          return response.data as Map<String, dynamic>;
        } else {
          throw UnknownException('Invalid response format');
        }
      } else {
        throw UnknownException(
          'Reset Password failed with status code: ${response.statusCode}',
        );
      }
    } on NetworkExceptions {
      rethrow;
    } catch (e) {
      if (e is NetworkExceptions) rethrow;
      throw UnknownException('Reset Password failed: ${e.toString()}');
    }
  }
  //Google sign in service


}


