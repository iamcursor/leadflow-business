import 'dart:io';
import 'dart:convert';

import 'package:dio/dio.dart';

import '../core/contants/api_endpoints.dart';
import '../core/network/api_client.dart';
import '../core/network/network_exceptions.dart';
import '../models/business_owner_profile/business_profile.dart';
import '../models/business_owner_profile/change_password_model.dart';


class BusinessProfileService {
  final ApiClient _apiClient = ApiClient.instance;

  // Create / Update Business Profile with files (multipart/form-data)
  Future<Map<String, dynamic>> updateBusinessProfileWithFiles(
    BusinessProfileModel model, {
    String? name,
    String? phone,
    File? idProofFile,
    File? recentPhoto,
    File? logoFile,
  }) async {
    try {
      final jsonData = model.toJson();
      
      // Convert service_categories from string to array
      // Include primary_service_category in the array
      final primaryCategory = jsonData['primary_service_category']?.toString() ?? '';
      List<String> categories = [];
      
      // Always include primary category if it exists
      if (primaryCategory.isNotEmpty) {
        categories.add(primaryCategory);
      }
      
      // Add any additional categories from service_categories field
      if (jsonData['service_categories'] != null && jsonData['service_categories'].toString().isNotEmpty) {
        final additionalCategories = jsonData['service_categories'].toString()
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty && !categories.contains(e))
            .toList();
        categories.addAll(additionalCategories);
      }
      
      jsonData['service_categories'] = categories;
      
      // Convert services_offered from string to array
      if (jsonData['services_offered'] != null && jsonData['services_offered'].toString().isNotEmpty) {
        final services = jsonData['services_offered'].toString().split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
        jsonData['services_offered'] = services;
      } else {
        jsonData['services_offered'] = [];
      }
      
      // Convert business_hours from string to object
      // For FormData, we need to send nested objects as JSON string or handle them specially
      Map<String, String> businessHoursMap = {};
      if (jsonData['business_hours'] != null && jsonData['business_hours'].toString().isNotEmpty) {
        final hoursStr = jsonData['business_hours'].toString();
        // Parse "17:47 - 20:47" format
        if (hoursStr.contains(' - ')) {
          final parts = hoursStr.split(' - ');
          if (parts.length == 2) {
            businessHoursMap = {
              'start_time': parts[0].trim(),
              'end_time': parts[1].trim(),
            };
          }
        }
      }
      // For FormData with nested objects, convert to JSON string
      // The backend should parse it back to an object
      jsonData['business_hours'] = businessHoursMap.isNotEmpty 
          ? jsonEncode(businessHoursMap) 
          : jsonEncode({});
      
      // Add name field if provided
      if (name != null && name.isNotEmpty) {
        jsonData['name'] = name;
      }
      
      // Add phone field if provided
      if (phone != null && phone.isNotEmpty) {
        jsonData['phone'] = phone;
      }
      
      final formDataMap = <String, dynamic>{};
      
      // Copy all fields except arrays and objects which need special handling
      jsonData.forEach((key, value) {
        if (key == 'service_categories' || key == 'services_offered') {
          // These are already Lists, FormData should handle them
          formDataMap[key] = value;
        } else if (key == 'business_hours') {
          // business_hours is already a JSON string
          formDataMap[key] = value;
        } else {
          formDataMap[key] = value;
        }
      });

      // Add files to form data if they exist
      if (idProofFile != null && await idProofFile.exists()) {
        final fileName = idProofFile.path.split('/').last;
        formDataMap['id_proof_file'] = await MultipartFile.fromFile(
          idProofFile.path,
          filename: fileName,
        );
      }

      if (recentPhoto != null && await recentPhoto.exists()) {
        final fileName = recentPhoto.path.split('/').last;
        formDataMap['recent_photo'] = await MultipartFile.fromFile(
          recentPhoto.path,
          filename: fileName,
        );
      }

      if (logoFile != null && await logoFile.exists()) {
        final fileName = logoFile.path.split('/').last;
        formDataMap['logo'] = await MultipartFile.fromFile(
          logoFile.path,
          filename: fileName,
        );
      }

      // Remove empty file path strings (they will be replaced by actual files or left empty)
      if (formDataMap['id_proof_file'] is! MultipartFile && 
          (formDataMap['id_proof_file'] == null || formDataMap['id_proof_file'].toString().isEmpty)) {
        formDataMap.remove('id_proof_file');
      }
      if (formDataMap['recent_photo'] is! MultipartFile && 
          (formDataMap['recent_photo'] == null || formDataMap['recent_photo'].toString().isEmpty)) {
        formDataMap.remove('recent_photo');
      }
      if (formDataMap['logo'] is! MultipartFile && 
          (formDataMap['logo'] == null || formDataMap['logo'].toString().isEmpty)) {
        formDataMap.remove('logo');
      }

      final formData = FormData.fromMap(formDataMap);

      // Dio automatically sets Content-Type to multipart/form-data with boundary
      final response = await _apiClient.dio.put(
        ApiEndpoints.updateBusinessOwnerProfile,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is Map<String, dynamic>) {
          return response.data as Map<String, dynamic>;
        } else {
          throw UnknownException('Invalid response format');
        }
      } else {
        throw UnknownException(
          'Business profile update failed with status code: ${response.statusCode}',
        );
      }
    } on NetworkExceptions {
      rethrow;
    } catch (e) {
      if (e is NetworkExceptions) rethrow;
      throw UnknownException('Business profile update failed: ${e.toString()}');
    }
  }


  Future<Map<String, dynamic>> changePassword(ChangePasswordModel model) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.changePassword, // <---- ADD endpoint here
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
          'Change password failed with code: ${response.statusCode}',
        );
      }
    } on NetworkExceptions {
      rethrow;
    } catch (e) {
      if (e is NetworkExceptions) rethrow;
      throw UnknownException('Change password failed: ${e.toString()}');
    }
  }
}
