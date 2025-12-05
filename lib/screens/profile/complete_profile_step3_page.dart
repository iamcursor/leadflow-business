import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/routing/route_names.dart';
import '../../providers/business_owner_provider.dart';
import '../../models/business_owner_profile/business_profile.dart';

/// Complete Profile Page - Step 3 of 5
class CompleteProfileStep3Page extends StatefulWidget {
  const CompleteProfileStep3Page({super.key});

  @override
  State<CompleteProfileStep3Page> createState() => _CompleteProfileStep3PageState();
}

class _CompleteProfileStep3PageState extends State<CompleteProfileStep3Page> {
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();
  
  final List<String> _idTypes = ['ID Card', 'Passport', 'Driving License'];

  @override
  void initState() {
    super.initState();
    // Initialize provider after build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<BusinessOwnerProvider>(context, listen: false);
      provider.initializeStep3();
    });
  }

  void _handleIdTypeSelection(String idType) {
    final provider = Provider.of<BusinessOwnerProvider>(context, listen: false);
    provider.setSelectedIdType(idType);
  }

  Future<void> _handleIdDocumentUpload() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final fileSize = await file.length();
        const maxSize = 5 * 1024 * 1024; // 5MB

        if (fileSize > maxSize) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('File size must be less than 5MB'),
              ),
            );
          }
          return;
        }

        final provider = Provider.of<BusinessOwnerProvider>(context, listen: false);
        provider.setSelectedIdDocument(file);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('ID document selected successfully'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting file: ${e.toString()}'),
          ),
        );
      }
    }
  }

  Future<void> _handlePhotoUpload() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (image != null) {
        final file = File(image.path);
        final fileSize = await file.length();
        const maxSize = 5 * 1024 * 1024; // 5MB

        if (fileSize > maxSize) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Image size must be less than 5MB'),
              ),
            );
          }
          return;
        }

        final provider = Provider.of<BusinessOwnerProvider>(context, listen: false);
        provider.setSelectedPhoto(file);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Photo selected successfully'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting image: ${e.toString()}'),
          ),
        );
      }
    }
  }

  void _handleNext() {
    if (_formKey.currentState?.validate() ?? false) {
      final provider = Provider.of<BusinessOwnerProvider>(context, listen: false);
      
      // Validate step3 required fields
      if (provider.selectedIdType == null || provider.selectedIdType!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an ID type'),
          ),
        );
        return;
      }
      
      if (provider.idDocumentPath == null || provider.idDocumentPath!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please upload an ID document'),
          ),
        );
        return;
      }
      
      if (provider.photoPath == null || provider.photoPath!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please upload a recent photo'),
          ),
        );
        return;
      }
      
      // Navigate to Step 4
      context.goNamed(RouteNames.completeProfileStep4);
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
                                  'Step 3 of 5',
                                  style: AppTextStyles.labelMedium.copyWith(
                                    fontSize: 13.sp,
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '${(provider.step3Progress * 100).toInt()}%',
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
                                value: provider.step3Progress,
                                backgroundColor: AppColors.borderLight,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                                minHeight: 6.h,
                              ),
                            ),
                        
                        SizedBox(height: AppDimensions.verticalSpaceL),
                        
                        // Verification Documents Container
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
                                  'Verification Documents',
                                  style: TextStyle(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                
                                SizedBox(height: AppDimensions.verticalSpaceS),
                                
                                Text(
                                  'Upload Government ID Proof (Any one)',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                
                                SizedBox(height: AppDimensions.verticalSpaceM),
                                
                                // ID Type Buttons
                                Row(
                                  children: _idTypes.map((String idType) {
                                    final isSelected = provider.selectedIdType == idType;
                                    return Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          right: idType != _idTypes.last 
                                              ? AppDimensions.paddingS 
                                              : 0,
                                        ),
                                        child: OutlinedButton(
                                          onPressed: () => _handleIdTypeSelection(idType),
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor: isSelected 
                                                ? AppColors.primary 
                                                : AppColors.surfaceVariant,
                                            foregroundColor: isSelected 
                                                ? AppColors.textOnPrimary 
                                                : AppColors.textPrimary,
                                            side: BorderSide(
                                              color: isSelected 
                                                  ? AppColors.primary 
                                                  : AppColors.border,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                AppDimensions.inputRadius,
                                              ),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              vertical: AppDimensions.paddingM,
                                            ),
                                          ),
                                          child: Text(
                                            idType,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                
                                SizedBox(height: AppDimensions.verticalSpaceL),
                                
                                // Upload Area for ID Document
                                InkWell(
                                  onTap: _handleIdDocumentUpload,
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                      vertical: AppDimensions.verticalSpaceXL,
                                      horizontal: AppDimensions.paddingM,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.surface,
                                      borderRadius: BorderRadius.circular(
                                        AppDimensions.inputRadius,
                                      ),
                                      border: Border.all(
                                        color: provider.selectedIdDocument != null 
                                            ? AppColors.primary 
                                            : AppColors.border,
                                        width: 1.5,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    child: provider.selectedIdDocument != null
                                        ? Row(
                                            children: [
                                              Icon(
                                                Icons.check_circle,
                                                color: AppColors.primary,
                                                size: 24.w,
                                              ),
                                              SizedBox(width: AppDimensions.paddingM),
                                              Expanded(
                                                child: Text(
                                                  provider.selectedIdDocument!.path.split('/').last,
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors.textPrimary,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  Icons.close,
                                                  size: 20.w,
                                                  color: AppColors.textSecondary,
                                                ),
                                                onPressed: () {
                                                  provider.setSelectedIdDocument(null);
                                                },
                                              ),
                                            ],
                                          )
                                        : Column(
                                            children: [
                                              Icon(
                                                Icons.description_outlined,
                                                size: 48.w,
                                                color: AppColors.iconSecondary,
                                              ),
                                              SizedBox(height: AppDimensions.verticalSpaceM),
                                              Text(
                                                'Click to upload or drag and drop',
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                              SizedBox(height: AppDimensions.verticalSpaceS),
                                              Text(
                                                'PNG, JPG, PDF up to 5MB',
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColors.textSecondary,
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
                        
                        SizedBox(height: AppDimensions.verticalSpaceL),
                        
                        // Upload Recent Photo Container
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
                                  'Upload Recent Photo (Selfie or Passport style)',
                                  style: TextStyle(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                
                                SizedBox(height: AppDimensions.verticalSpaceL),
                                
                                // Upload Area for Photo
                                InkWell(
                                  onTap: _handlePhotoUpload,
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                      vertical: AppDimensions.verticalSpaceXL,
                                      horizontal: AppDimensions.paddingM,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.surface,
                                      borderRadius: BorderRadius.circular(
                                        AppDimensions.inputRadius,
                                      ),
                                      border: Border.all(
                                        color: provider.selectedPhoto != null 
                                            ? AppColors.primary 
                                            : AppColors.border,
                                        width: 1.5,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    child: provider.selectedPhoto != null
                                        ? Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(8.r),
                                                child: Image.file(
                                                  provider.selectedPhoto!,
                                                  width: 60.w,
                                                  height: 60.w,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              SizedBox(width: AppDimensions.paddingM),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      provider.selectedPhoto!.path.split('/').last,
                                                      style: TextStyle(
                                                        fontSize: 14.sp,
                                                        fontWeight: FontWeight.w500,
                                                        color: AppColors.textPrimary,
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    SizedBox(height: 4.h),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.check_circle,
                                                          color: AppColors.primary,
                                                          size: 16.w,
                                                        ),
                                                        SizedBox(width: 4.w),
                                                        Text(
                                                          'Photo selected',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                            color: AppColors.primary,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  Icons.close,
                                                  size: 20.w,
                                                  color: AppColors.textSecondary,
                                                ),
                                                onPressed: () {
                                                  provider.setSelectedPhoto(null);
                                                },
                                              ),
                                            ],
                                          )
                                        : Column(
                                            children: [
                                              Icon(
                                                Icons.camera_alt_outlined,
                                                size: 48.w,
                                                color: AppColors.iconSecondary,
                                              ),
                                              SizedBox(height: AppDimensions.verticalSpaceM),
                                              Text(
                                                'Click to upload or drag and drop',
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                              SizedBox(height: AppDimensions.verticalSpaceS),
                                              Text(
                                                'PNG, JPG, PDF up to 5MB',
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColors.textSecondary,
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
                    onPressed: provider.isLoading ? null : _handleNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textOnPrimary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.buttonRadius,
                        ),
                      ),
                      disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
                    ),
                    child: provider.isLoading
                        ? SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.textOnPrimary,
                              ),
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
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

