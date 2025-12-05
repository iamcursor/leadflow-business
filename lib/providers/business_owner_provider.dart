import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/network/network_exceptions.dart';
import '../models/business_owner_profile/business_profile.dart';
import '../models/business_owner_profile/change_password_model.dart';
import '../services/business_owner_profile_services.dart';

class BusinessOwnerProvider with ChangeNotifier {
  // Step 1 - Personal Information

  final BusinessProfileService _service = BusinessProfileService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Map<String, dynamic>? _response;
  Map<String, dynamic>? get response => _response;

  String? _fullName;
  String? get fullName => _fullName;
  
  String? _selectedGender;
  String? get selectedGender => _selectedGender;
  
  DateTime? _selectedDate;
  DateTime? get selectedDate => _selectedDate;
  
  String? _selectedCity;
  String? get selectedCity => _selectedCity;
  
  String? _mobileNumber;
  String? get mobileNumber => _mobileNumber;
  
  String? _alternatePhone;
  String? get alternatePhone => _alternatePhone;
  
  double _step1Progress = 0.0;
  double get step1Progress => _step1Progress;
  
  // Step 2 - Service Details
  String? _selectedExperience;
  String? get selectedExperience => _selectedExperience;
  
  String? _selectedServiceCategory;
  String? get selectedServiceCategory => _selectedServiceCategory;
  
  double _serviceRadius = 10.0;
  double get serviceRadius => _serviceRadius;
  
  bool _useCurrentLocation = false;
  bool get useCurrentLocation => _useCurrentLocation;
  
  final Map<String, bool> _subServices = {
    'Wiring': false,
    'Switch/Socket Installation': false,
    'Fan Installation': false,
    'Light Fitting': false,
    'Electrical Troubleshooting': false,
    'Other': false,
  };
  Map<String, bool> get subServices => Map.unmodifiable(_subServices);
  
  double _step2Progress = 0.0;
  double get step2Progress => _step2Progress;
  
  // Step 3 - Verification Documents
  String? _selectedIdType;
  String? get selectedIdType => _selectedIdType;
  
  String? _idDocumentPath;
  String? get idDocumentPath => _idDocumentPath;
  
  File? _selectedIdDocument;
  File? get selectedIdDocument => _selectedIdDocument;
  
  String? _photoPath;
  String? get photoPath => _photoPath;
  
  File? _selectedPhoto;
  File? get selectedPhoto => _selectedPhoto;
  
  double _step3Progress = 0.4;
  double get step3Progress => _step3Progress;
  
  // Step 4 - Availability & Rates
  TimeOfDay? _startTime;
  TimeOfDay? get startTime => _startTime;
  
  TimeOfDay? _endTime;
  TimeOfDay? get endTime => _endTime;
  
  String? _serviceRate;
  String? get serviceRate => _serviceRate;
  
  final Map<String, bool> _availabilityDays = {
    'Mon': false,
    'Tue': false,
    'Wed': false,
    'Thur': false,
    'Fri': false,
    'Sat': false,
    'Sun': false,
  };
  Map<String, bool> get availabilityDays => Map.unmodifiable(_availabilityDays);
  
  double _step4Progress = 0.0;
  double get step4Progress => _step4Progress;
  
  // Step 5 - Confirmation
  bool _confirmInformation = false;
  bool get confirmInformation => _confirmInformation;
  
  double get step5Progress => _confirmInformation ? 1.0 : 0.8;


  
  // Step 1 Methods
  void setFullName(String? value) {
    _fullName = value;
    _updateStep1Progress();
    notifyListeners();
  }
  
  void setSelectedGender(String? value) {
    _selectedGender = value;
    _updateStep1Progress();
    notifyListeners();
  }
  
  void setSelectedDate(DateTime? value) {
    _selectedDate = value;
    _updateStep1Progress();
    notifyListeners();
  }
  
  void setSelectedCity(String? value) {
    _selectedCity = value;
    _updateStep1Progress();
    notifyListeners();
  }
  
  void setMobileNumber(String? value) {
    _mobileNumber = value;
    _updateStep1Progress();
    notifyListeners();
  }
  
  void setAlternatePhone(String? value) {
    _alternatePhone = value;
    _updateStep1Progress();
    notifyListeners();
  }
  
  void _updateStep1Progress() {
    int filledFields = 0;
    int totalFields = 6; // Full Name, Gender, Date of Birth, Mobile, Alternate Phone, City
    
    if (_fullName != null && _fullName!.trim().isNotEmpty) {
      filledFields++;
    }
    
    if (_selectedGender != null && _selectedGender!.isNotEmpty) {
      filledFields++;
    }
    
    if (_selectedDate != null) {
      filledFields++;
    }
    
    if (_mobileNumber != null && _mobileNumber!.trim().isNotEmpty) {
      filledFields++;
    }
    
    if (_alternatePhone != null && _alternatePhone!.trim().isNotEmpty) {
      filledFields++;
    }
    
    if (_selectedCity != null && _selectedCity!.isNotEmpty) {
      filledFields++;
    }
    
    _step1Progress = (filledFields / totalFields) * 0.2;
  }
  
  // Step 2 Methods
  void setSelectedExperience(String? value) {
    _selectedExperience = value;
    _updateStep2Progress();
    notifyListeners();
  }
  
  void setSelectedServiceCategory(String? value) {
    _selectedServiceCategory = value;
    _updateStep2Progress();
    notifyListeners();
  }
  
  void setServiceRadius(double value) {
    _serviceRadius = value;
    _updateStep2Progress();
    notifyListeners();
  }
  
  void setUseCurrentLocation(bool value) {
    _useCurrentLocation = value;
    notifyListeners();
  }
  
  void setSubService(String service, bool value) {
    _subServices[service] = value;
    _updateStep2Progress();
    notifyListeners();
  }
  
  void _updateStep2Progress() {
    int filledFields = 0;
    int totalFields = 4;
    
    if (_selectedExperience != null && _selectedExperience!.isNotEmpty) {
      filledFields++;
    }
    
    if (_selectedServiceCategory != null && _selectedServiceCategory!.isNotEmpty) {
      filledFields++;
    }
    
    // Service Radius always has a value (default 10)
    filledFields++;
    
    bool hasSubServiceSelected = _subServices.values.any((isSelected) => isSelected);
    if (hasSubServiceSelected) {
      filledFields++;
    }
    
    _step2Progress = 0.2 + (filledFields / totalFields) * 0.2;
  }
  
  // Step 3 Methods
  void setSelectedIdType(String? value) {
    _selectedIdType = value;
    notifyListeners();
  }
  
  void setIdDocumentPath(String? value) {
    _idDocumentPath = value;
    if (value != null && value.isNotEmpty) {
      _selectedIdDocument = File(value);
    } else {
      _selectedIdDocument = null;
    }
    _updateStep3Progress();
    notifyListeners();
  }
  
  void setPhotoPath(String? value) {
    _photoPath = value;
    if (value != null && value.isNotEmpty) {
      _selectedPhoto = File(value);
    } else {
      _selectedPhoto = null;
    }
    _updateStep3Progress();
    notifyListeners();
  }
  
  void setSelectedIdDocument(File? file) {
    _selectedIdDocument = file;
    _idDocumentPath = file?.path;
    _updateStep3Progress();
    notifyListeners();
  }
  
  void setSelectedPhoto(File? file) {
    _selectedPhoto = file;
    _photoPath = file?.path;
    _updateStep3Progress();
    notifyListeners();
  }
  
  void _updateStep3Progress() {
    int filledFields = 0;
    int totalFields = 2; // ID Document, Photo
    
    if (_idDocumentPath != null && _idDocumentPath!.isNotEmpty) {
      filledFields++;
    }
    
    if (_photoPath != null && _photoPath!.isNotEmpty) {
      filledFields++;
    }
    
    _step3Progress = 0.4 + (filledFields / totalFields) * 0.2;
  }
  
  // Step 4 Methods
  void setStartTime(TimeOfDay? value) {
    _startTime = value;
    _updateStep4Progress();
    notifyListeners();
  }
  
  void setEndTime(TimeOfDay? value) {
    _endTime = value;
    _updateStep4Progress();
    notifyListeners();
  }
  
  void setServiceRate(String? value) {
    _serviceRate = value;
    _updateStep4Progress();
    notifyListeners();
  }
  
  void setAvailabilityDay(String day, bool value) {
    _availabilityDays[day] = value;
    _updateStep4Progress();
    notifyListeners();
  }
  
  void _updateStep4Progress() {
    int filledFields = 0;
    int totalFields = 4; // Start Time, End Time, At least one Availability Day checkbox, Service Rate
    
    if (_startTime != null) {
      filledFields++;
    }
    
    if (_endTime != null) {
      filledFields++;
    }
    
    bool hasAvailabilityDaySelected = _availabilityDays.values.any((isSelected) => isSelected);
    if (hasAvailabilityDaySelected) {
      filledFields++;
    }
    
    if (_serviceRate != null && _serviceRate!.isNotEmpty) {
      filledFields++;
    }
    
    if (filledFields == totalFields) {
      _step4Progress = 0.8;
    } else {
      _step4Progress = 0.6 + (filledFields / totalFields) * 0.2;
    }
  }
  
  // Step 5 Methods
  void setConfirmInformation(bool value) {
    _confirmInformation = value;
    notifyListeners();
  }
  
  // Initialize step 1 with default date
  void initializeStep1() {
    _selectedDate = DateTime(2025, 8, 17);
    _updateStep1Progress();
    notifyListeners();
  }
  
  // Initialize step 2
  void initializeStep2() {
    _updateStep2Progress();
    notifyListeners();
  }
  
  // Initialize step 3
  void initializeStep3() {
    _updateStep3Progress();
    notifyListeners();
  }
  
  // Initialize step 4
  void initializeStep4() {
    _updateStep4Progress();
    notifyListeners();
  }




  Future<bool> updateBusinessProfileWithFiles(
    BusinessProfileModel model, {
    String? name,
    String? phone,
    File? idProofFile,
    File? recentPhoto,
    File? logoFile,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final data = await _service.updateBusinessProfileWithFiles(
        model,
        name: name,
        phone: phone,
        idProofFile: idProofFile,
        recentPhoto: recentPhoto,
        logoFile: logoFile,
      );

      _response = data;
      _isLoading = false;
      notifyListeners();

      return true;
    } on NetworkExceptions {
      _isLoading = false;
      notifyListeners();
      rethrow;
    } catch (e) {
      _isLoading = false;
      notifyListeners();

      print("Business Profile Update Error → $e");
      return false;
    }
  }

  // Change Password - Password Visibility States
  bool _obscureOldPassword = true;
  bool get obscureOldPassword => _obscureOldPassword;

  bool _obscureNewPassword = true;
  bool get obscureNewPassword => _obscureNewPassword;

  bool _obscureConfirmPassword = true;
  bool get obscureConfirmPassword => _obscureConfirmPassword;

  void toggleObscureOldPassword() {
    _obscureOldPassword = !_obscureOldPassword;
    notifyListeners();
  }

  void toggleObscureNewPassword() {
    _obscureNewPassword = !_obscureNewPassword;
    notifyListeners();
  }

  void toggleObscureConfirmPassword() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  // change password provider
  Future<bool> changePassword(ChangePasswordModel model) async {
    try {
      _isLoading = true;
      notifyListeners();

      final data = await _service.changePassword(model);

      _response = data;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print("Change Password Error → $e");
      return false;
    }
  }
}


