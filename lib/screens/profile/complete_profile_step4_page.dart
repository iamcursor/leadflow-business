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
class CompleteProfileStep4Page extends StatefulWidget {
  const CompleteProfileStep4Page({super.key});

  @override
  State<CompleteProfileStep4Page> createState() => _CompleteProfileStep4PageState();
}

class _CompleteProfileStep4PageState extends State<CompleteProfileStep4Page> {
  final _formKey = GlobalKey<FormState>();

  final List<String> _serviceRateOptions = [
    '\$500',
    '\$600',
    '\$700',
    '\$800',
    '\$900',
    '\$1000',
    '\$1200',
    '\$1500',
  ];

  @override
  void initState() {
    super.initState();
    // Initialize provider after build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<BusinessOwnerProvider>(context, listen: false);
      provider.initializeStep4();
    });
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final provider = Provider.of<BusinessOwnerProvider>(context, listen: false);
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: provider.startTime ?? TimeOfDay.now(),
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
    if (picked != null && picked != provider.startTime) {
      provider.setStartTime(picked);
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final provider = Provider.of<BusinessOwnerProvider>(context, listen: false);
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: provider.endTime ?? TimeOfDay.now(),
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
    if (picked != null && picked != provider.endTime) {
      provider.setEndTime(picked);
    }
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return '';
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  void _handleNext() {
    if (_formKey.currentState?.validate() ?? false) {
      // Navigate to Step 5
      context.goNamed(RouteNames.completeProfileStep5);
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
                                  'Step 4 of 5',
                                  style: AppTextStyles.labelMedium.copyWith(
                                      fontSize: 13.sp,
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '${(provider.step4Progress * 100).toInt()}%',
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
                                value: provider.step4Progress,
                                backgroundColor: AppColors.borderLight,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                                minHeight: 6.h,
                              ),
                            ),

                        SizedBox(height: AppDimensions.verticalSpaceM),

                        // Availability & Rates Card
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
                                  'Availability & Rates',
                                  style: TextStyle(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                
                                SizedBox(height: AppDimensions.verticalSpaceS),
                                
                                Text(
                                  'Working Hours',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                
                                SizedBox(height: AppDimensions.verticalSpaceS),
                                
                                // Time Picker Fields
                                Row(
                                  children: [
                                    // Start Time
                                    Expanded(
                                      child: InkWell(
                                        onTap: () => _selectStartTime(context),
                                        child: InputDecorator(
                                          decoration: InputDecoration(
                                            hintText: 'Start time',
                                            hintStyle: AppTextStyles.inputText.copyWith(
                                              color: AppColors.textPrimary,
                                            ),
                                            suffixIcon: const Icon(
                                              Icons.keyboard_arrow_down,
                                              color: AppColors.primary,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
                                              borderSide: const BorderSide(
                                                color: AppColors.borderLight,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
                                              borderSide: const BorderSide(
                                                color: AppColors.borderLight,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
                                              borderSide: const BorderSide(
                                                color: AppColors.primary,
                                              ),
                                            ),
                                            contentPadding: EdgeInsets.symmetric(
                                              horizontal: AppDimensions.paddingM,
                                              vertical: AppDimensions.paddingM,
                                            ),
                                          ),
                                          child: Text(
                                            provider.startTime != null ? _formatTime(provider.startTime) : 'Start time',
                                            style: AppTextStyles.inputText.copyWith(
                                              color: provider.startTime != null 
                                                ? AppColors.textPrimary 
                                                : AppColors.textHint,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    
                                    SizedBox(width: AppDimensions.paddingM),
                                    
                                    // End Time
                                    Expanded(
                                      child: InkWell(
                                        onTap: () => _selectEndTime(context),
                                        child: InputDecorator(
                                          decoration: InputDecoration(
                                            hintText: 'End time',
                                            hintStyle: AppTextStyles.inputText.copyWith(
                                              color: AppColors.textPrimary,
                                            ),
                                            suffixIcon: const Icon(
                                              Icons.keyboard_arrow_down,
                                              color: AppColors.primary,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
                                              borderSide: const BorderSide(
                                                color: AppColors.borderLight,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
                                              borderSide: const BorderSide(
                                                color: AppColors.borderLight,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
                                              borderSide: const BorderSide(
                                                color: AppColors.primary,
                                              ),
                                            ),
                                            contentPadding: EdgeInsets.symmetric(
                                              horizontal: AppDimensions.paddingM,
                                              vertical: AppDimensions.paddingM,
                                            ),
                                          ),
                                          child: Text(
                                            provider.endTime != null ? _formatTime(provider.endTime) : 'End time',
                                            style: AppTextStyles.inputText.copyWith(
                                              color: provider.endTime != null 
                                                ? AppColors.textPrimary 
                                                : AppColors.textHint,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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
                                  'Availability Days',
                                  style: TextStyle(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),


                                SizedBox(height: AppDimensions.verticalSpaceS),

                                // Checkboxes
                                ...provider.availabilityDays.keys.map((String service) {
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
                                    value: provider.availabilityDays[service],
                                    onChanged: (bool? value) {
                                      provider.setAvailabilityDay(service, value ?? false);
                                    },
                                    controlAffinity: ListTileControlAffinity.leading,
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: AppDimensions.verticalSpaceM),

                        // Service Rate Card
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
                                  'Base Service Rate',
                                  style: TextStyle(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: AppDimensions.verticalSpaceS),
                                DropdownButtonFormField<String>(
                                  value: provider.serviceRate,
                                  style: AppTextStyles.inputText,
                                  decoration: const InputDecoration(
                                    hintText: 'Select service rate',
                                    suffixIcon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: AppColors.iconSecondary,
                                    ),
                                  ),
                                  items: _serviceRateOptions.map((String rate) {
                                    return DropdownMenuItem<String>(
                                      value: rate,
                                      child: Text(rate),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    provider.setServiceRate(newValue);
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select service rate';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: AppDimensions.verticalSpaceM),
                                Text(
                                  'This is your starting rate per hour. You can adjust rates for specific services later',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: AppDimensions.verticalSpaceM),

                        // Tip Banner
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.paddingM,
                            vertical: AppDimensions.paddingM,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.warning,// Light yellow background
                            borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
                            border: Border.all(
                              color: AppColors.warningDark,
                              width: 1,
                            ),
                          ),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                                height: 1.4,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Tip: Being available on weekends and setting competitive rates can help you get more bookings!',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.warningDark,
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),


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

