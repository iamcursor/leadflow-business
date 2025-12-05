import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/routing/route_names.dart';
import '../../providers/business_owner_provider.dart';

/// Complete Profile Page - Step 1 of 5
class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _alternatePhoneController = TextEditingController();
  
  final List<String> _genderOptions = ['Male', 'Female', 'Other'];
  final List<String> _cityOptions = [
    'Lahore',
    'Karachi',
    'Islamabad',
    'Rawalpindi',
    'Faisalabad',
    'Multan',
    'Peshawar',
    'Quetta',
  ];

  @override
  void initState() {
    super.initState();
    
    // Add listeners to update progress when fields change
    _fullNameController.addListener(_updateProgress);
    _dateOfBirthController.addListener(_updateProgress);
    _mobileNumberController.addListener(_updateProgress);
    _alternatePhoneController.addListener(_updateProgress);
    
    // Initialize provider after build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<BusinessOwnerProvider>(context, listen: false);
      provider.initializeStep1();
      
      // Pre-populate fields with existing values from provider
      if (provider.fullName != null && provider.fullName!.isNotEmpty) {
        _fullNameController.text = provider.fullName!;
      }
      
      if (provider.selectedDate != null) {
        _dateOfBirthController.text = _formatDate(provider.selectedDate);
      }
      
      if (provider.mobileNumber != null && provider.mobileNumber!.isNotEmpty) {
        _mobileNumberController.text = provider.mobileNumber!;
      }
      
      if (provider.alternatePhone != null && provider.alternatePhone!.isNotEmpty) {
        _alternatePhoneController.text = provider.alternatePhone!;
      }
      
      _updateProgress();
    });
  }
  
  void _updateProgress() {
    final provider = Provider.of<BusinessOwnerProvider>(context, listen: false);
    provider.setFullName(_fullNameController.text.trim().isEmpty ? null : _fullNameController.text.trim());
    provider.setMobileNumber(_mobileNumberController.text.trim().isEmpty ? null : _mobileNumberController.text.trim());
    provider.setAlternatePhone(_alternatePhoneController.text.trim().isEmpty ? null : _alternatePhoneController.text.trim());
    provider.setSelectedCity(provider.selectedCity);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _dateOfBirthController.dispose();
    _mobileNumberController.dispose();
    _alternatePhoneController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final provider = Provider.of<BusinessOwnerProvider>(context, listen: false);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: provider.selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.textOnPrimary,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != provider.selectedDate) {
      provider.setSelectedDate(picked);
      _dateOfBirthController.text = _formatDate(picked);
      _updateProgress();
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  void _handleNext() {
    if (_formKey.currentState?.validate() ?? false) {
      // Navigate to Step 2
      context.goNamed(RouteNames.completeProfileStep2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BusinessOwnerProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                // Main Content
                Expanded(
                  child: Container(
                    color: AppColors.background,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.screenPaddingHorizontal,
                        vertical: AppDimensions.screenPaddingVertical,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: AppDimensions.verticalSpaceS),
                            
                            // Title
                            Center(
                              child: Text(
                                'Complete Your Profile',
                                style: AppTextStyles.appBarTitle.copyWith(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            
                            SizedBox(height: AppDimensions.verticalSpaceS),
                            
                            // Subtitle
                            Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppDimensions.paddingM,
                                ),
                                child: Text(
                                  'Help customer know you better and get more bookings.',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontSize: 14.sp,
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            
                            SizedBox(height: AppDimensions.verticalSpaceM),
                            
                            // Progress Section
                            Row(
                              children: [
                                Text(
                                  'Step 1 of 5',
                                  style: AppTextStyles.labelMedium.copyWith(
                                    fontSize: 13.sp,
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '${(provider.step1Progress * 100).toInt()}%',
                                  style: AppTextStyles.labelMedium.copyWith(
                                    fontSize: 13.sp,
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                              ],
                            ),
                            
                            SizedBox(height: AppDimensions.verticalSpaceS),
                            
                            // Progress Bar
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4.r),
                              child: LinearProgressIndicator(
                                value: provider.step1Progress,
                                backgroundColor: AppColors.borderLight,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                                minHeight: 6.h,
                              ),
                            ),
                        
                        SizedBox(height: AppDimensions.verticalSpaceL),
                        
                        // Personal Information Section
                        Text(
                          'Personal Information',
                          style: AppTextStyles.titleLarge.copyWith(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      
                      SizedBox(height: AppDimensions.verticalSpaceS),
                      
                        // Full Name Field
                        Text('Full Name', style: TextStyle(
                          fontSize: 14.w,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,

                        )),
                        SizedBox(height: AppDimensions.verticalSpaceS),
                        TextFormField(
                          controller: _fullNameController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(hintText: 'Your full name'),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                      
                      SizedBox(height: AppDimensions.verticalSpaceS),
                      
                        // Gender Field
                        Text(
                          'Gender',
                            style: TextStyle(
                              fontSize: 14.w,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,

                            )
                          ),

                        SizedBox(height: AppDimensions.verticalSpaceS),
                        DropdownButtonFormField<String>(
                          value: provider.selectedGender,
                          decoration: const InputDecoration(hintText: 'Select your gender'),
                          style: AppTextStyles.inputText,
                          items: _genderOptions.map((String gender) {
                            return DropdownMenuItem<String>(
                              value: gender,
                              child: Text(gender),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            provider.setSelectedGender(newValue);
                            _updateProgress();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select your gender';
                            }
                            return null;
                          },
                        ),
                      
                      SizedBox(height: AppDimensions.verticalSpaceS),
                      
                        // Date of Birth Field
                        Text(
                          'Date of Birth',
                            style: TextStyle(
                              fontSize: 14.w,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,

                            )
                        ),
                        SizedBox(height: AppDimensions.verticalSpaceS),
                        TextFormField(
                          controller: _dateOfBirthController,
                          readOnly: true,
                          onTap: () => _selectDate(context),
                          decoration: const InputDecoration(
                            hintText: 'Select your date of birth',
                            suffixIcon: Icon(
                              Icons.calendar_today,
                              color: AppColors.iconSecondary,
                            ),
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? true || provider.selectedDate == null) {
                              return 'Please select your date of birth';
                            }
                            return null;
                          },
                        ),
                      
                      SizedBox(height: AppDimensions.verticalSpaceS),
                      
                        // Mobile Number Field
                        Text(
                          'Mobile Number',
                            style: TextStyle(
                              fontSize: 14.w,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,

                            )
                        ),
                        SizedBox(height: AppDimensions.verticalSpaceS),
                        TextFormField(
                          controller: _mobileNumberController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(hintText: 'Your phone no'),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please enter your mobile number';
                            }
                            return null;
                          },
                        ),
                        
                        SizedBox(height: AppDimensions.verticalSpaceS),
                        
                        // Alternate Phone Number Field
                        Text(
                          'Alternate Phone Number',
                            style: TextStyle(
                              fontSize: 14.w,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,

                            )
                        ),
                        SizedBox(height: AppDimensions.verticalSpaceS),
                        TextFormField(
                          controller: _alternatePhoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(hintText: 'Your phone no'),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please enter alternate phone number';
                            }
                            return null;
                          },
                        ),
                        
                        SizedBox(height: AppDimensions.verticalSpaceS),
                        
                        // City / Town Field
                        Text(
                          'City / Town',
                            style: TextStyle(
                              fontSize: 14.w,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,

                            )
                        ),
                        SizedBox(height: AppDimensions.verticalSpaceS),
                        DropdownButtonFormField<String>(
                          value: provider.selectedCity,
                          decoration: const InputDecoration(hintText: 'Your city'),
                          style: AppTextStyles.inputText,

                          items: _cityOptions.map((String city) {
                            return DropdownMenuItem<String>(
                              value: city,
                              child: Text(city),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            provider.setSelectedCity(newValue);
                            _updateProgress();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select your city';
                            }
                            return null;
                          },
                        ),
                        
                        // Bottom padding for scroll
                        SizedBox(height: AppDimensions.verticalSpaceXL),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            // Next Button
            Container(
              padding: EdgeInsets.all(AppDimensions.screenPaddingHorizontal),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  height: AppDimensions.buttonHeight,
                  child: ElevatedButton(
                    onPressed: _handleNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textOnPrimary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.buttonRadius,
                        ),
                      ),
                    ),
                    child: Text(
                      'Next',
                      style: AppTextStyles.buttonLarge
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
      },
    );
  }
}

