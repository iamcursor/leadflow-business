import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/routing/route_names.dart';
import '../../providers/business_owner_provider.dart';

/// Complete Profile Page - Step 2 of 5
class CompleteProfileStep2Page extends StatefulWidget {
  const CompleteProfileStep2Page({super.key});

  @override
  State<CompleteProfileStep2Page> createState() => _CompleteProfileStep2PageState();
}

class _CompleteProfileStep2PageState extends State<CompleteProfileStep2Page> {
  final _formKey = GlobalKey<FormState>();
  
  final List<String> _experienceOptions = [
    'Less than 1 year',
    '1-2 years',
    '3-5 years',
    '6-10 years',
    'More than 10 years',
  ];
  
  final List<String> _serviceCategoryOptions = [
    'Electrician',
    'Plumber',
    'AC Repair',
    'Carpenter',
    'Painter',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    // Initialize provider after build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<BusinessOwnerProvider>(context, listen: false);
      provider.initializeStep2();
    });
  }

  void _handleNext() {
    if (_formKey.currentState?.validate() ?? false) {
      // Navigate to Step 3
      context.push(RouteNames.completeProfileStep3);
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
                                  'Step 2 of 5',
                                  style: AppTextStyles.labelMedium.copyWith(
                                    fontSize: 13.sp,
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '${(provider.step2Progress * 100).toInt()}%',
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
                                value: provider.step2Progress,
                                backgroundColor: AppColors.borderLight,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                                minHeight: 6.h,
                              ),
                            ),
                        
                        SizedBox(height: AppDimensions.verticalSpaceM),
                        
                        // Personal Information Card
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
                            border: Border.all(
                              color: AppColors.borderLight,
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(AppDimensions.cardPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Personal Information',
                                  style: TextStyle(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                
                                SizedBox(height: AppDimensions.verticalSpaceS),
                                
                                // Years of Experience
                                Text(
                                  'Years of Experience',
                                  style: TextStyle(
                                    fontSize: 14.w,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: AppDimensions.verticalSpaceS),
                                DropdownButtonFormField<String>(
                                  value: provider.selectedExperience,
                                  style: AppTextStyles.inputText,
                                  decoration: const InputDecoration(
                                    hintText: 'Select your experience',
                                    suffixIcon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: AppColors.iconSecondary,
                                    ),
                                  ),
                                  items: _experienceOptions.map((String experience) {
                                    return DropdownMenuItem<String>(
                                      value: experience,
                                      child: Text(experience),
                                    );
                                  }).toList(),
                                  onChanged: provider.setSelectedExperience,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select your experience';
                                    }
                                    return null;
                                  },
                                ),
                                
                                SizedBox(height: AppDimensions.verticalSpaceS),
                                
                                // Primary Service Category
                                Text(
                                  'Primary Service Category',
                                  style: TextStyle(
                                    fontSize: 14.w,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: AppDimensions.verticalSpaceS),
                                DropdownButtonFormField<String>(
                                  value: provider.selectedServiceCategory,
                                  style: AppTextStyles.inputText,
                                  decoration: const InputDecoration(
                                    hintText: 'Select service category',
                                    suffixIcon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: AppColors.iconSecondary,
                                    ),
                                  ),
                                  items: _serviceCategoryOptions.map((String category) {
                                    return DropdownMenuItem<String>(
                                      value: category,
                                      child: Text(category),
                                    );
                                  }).toList(),
                                  onChanged: provider.setSelectedServiceCategory,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select service category';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        SizedBox(height: AppDimensions.verticalSpaceL),
                        
                        // Service Details Card - Sub Services
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
                            border: Border.all(
                              color: AppColors.borderLight,
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(AppDimensions.cardPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Service Details',
                                  style: TextStyle(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                
                                SizedBox(height: AppDimensions.verticalSpaceS),
                                
                                Text(
                                  'Sub Services Offered',
                                  style: TextStyle(
                                    fontSize: 14.w,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                
                                SizedBox(height: AppDimensions.verticalSpaceS),
                                
                                // Checkboxes
                                ...provider.subServices.keys.map((String service) {
                                  return CheckboxListTile(
                                    contentPadding: EdgeInsets.zero,
                                    dense: true,
                                    visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                                    title: Text(
                                      service,
                                      style: AppTextStyles.labelLarge.copyWith(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    value: provider.subServices[service],
                                    onChanged: (val) => provider.setSubService(service, val!),
                                    controlAffinity: ListTileControlAffinity.leading,
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        ),
                        
                        SizedBox(height: AppDimensions.verticalSpaceM),
                        
                        // Service Details Card - Service Area Radius
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
                            border: Border.all(
                              color: AppColors.borderLight,
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(AppDimensions.cardPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Service Details',
                                  style: TextStyle(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                
                                SizedBox(height: AppDimensions.verticalSpaceS),
                                
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Service Area Radius',
                                      style: TextStyle(
                                        fontSize: 14.w,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      '${provider.serviceRadius.toInt()} km',
                                      style: AppTextStyles.titleLarge.copyWith(
                                        fontSize: 14.w,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                
                                SizedBox(height: AppDimensions.verticalSpaceM),
                                
                                // Slider
                                SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor: AppColors.primary,
                                    inactiveTrackColor: AppColors.borderLight,
                                    trackHeight: 4.0,
                                    thumbColor: AppColors.primary,
                                    thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 8.0,
                                    ),
                                    overlayShape: const RoundSliderOverlayShape(
                                      overlayRadius: 16.0,
                                    ),
                                    overlayColor: AppColors.primary.withOpacity(0.1),
                                  ),
                                  child: Slider(
                                    value: provider.serviceRadius,
                                    min: 2,
                                    max: 25,
                                    divisions: 23,
                                    activeColor: AppColors.primary,
                                    inactiveColor: AppColors.borderLight,
                                    onChanged: (double value) {
                                      provider.setServiceRadius(value);
                                    },
                                  ),
                                ),
                                
                                // Slider Labels
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '2 km',
                                      style: AppTextStyles.labelSmall.copyWith(
                                        fontSize: 12.sp,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    Text(
                                      '25 km',
                                      style: AppTextStyles.labelSmall.copyWith(
                                        fontSize: 12.sp,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                                
                                
                                
                                // Use Current Location Checkbox
                                CheckboxListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    'Use current location as center',
                                    style: AppTextStyles.labelLarge.copyWith(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  value: provider.useCurrentLocation,
                                  onChanged: (bool? value) {
                                    provider.setUseCurrentLocation(value ?? false);
                                  },
                                  controlAffinity: ListTileControlAffinity.leading,
                                ),
                              ],
                            ),
                          ),
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

