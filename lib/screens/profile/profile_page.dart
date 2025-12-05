import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/routing/route_names.dart';
import '../../providers/business_owner_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: AppDimensions.verticalSpaceS),
                          
                          // Title
                          Center(
                            child: Text(
                              'Profile',
                              style: AppTextStyles.appBarTitle.copyWith(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          
                          SizedBox(height: AppDimensions.verticalSpaceL),
                          
                          // Profile Card
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
                              child: Row(
                                children: [
                                  // Profile Picture with Camera Icon
                                  Stack(
                                    children: [
                                      Container(
                                        width: 80.w,
                                        height: 80.w,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.backgroundSecondary,
                                        ),
                                        child: provider.photoPath != null && provider.photoPath!.isNotEmpty
                                            ? ClipOval(
                                                child: Image.asset(
                                                  provider.photoPath!,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            : Icon(
                                                Icons.person,
                                                size: 40.w,
                                                color: AppColors.textSecondary,
                                              ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          width: 24.w,
                                          height: 24.w,
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: AppColors.surface,
                                              width: 2,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.camera_alt,
                                            size: 12.w,
                                            color: AppColors.textOnPrimary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  SizedBox(width: AppDimensions.paddingM),
                                  
                                  // Profile Information
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Name
                                        Text(
                                          provider.fullName ?? 'Alexander Knight',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        

                                        
                                        // Verified Electrician
                                        Text(
                                          'Verified ${provider.selectedServiceCategory ?? 'Electrician'}',
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        

                                        
                                        // Location
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              size: 15.w,
                                              color: AppColors.textPrimary,
                                            ),
                                            SizedBox(width: 4.w),
                                            Expanded(
                                              child: Text(
                                                '${provider.selectedCity ?? 'Saket'}, Pakistan (1.2 km away)',
                                                style: TextStyle(
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        

                                        
                                        // Rating
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              size: 18.w,
                                              color: AppColors.ratingActive,
                                            ),
                                            SizedBox(width: 4.w),
                                            Text(
                                              '4.5 (72 Jobs)',
                                              style: TextStyle(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          SizedBox(height: AppDimensions.verticalSpaceM),
                          
                          // Account Management Options Card
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
                              border: Border.all(
                                color: AppColors.borderLight,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                // Edit Personal Details
                                _buildMenuItem(
                                  icon: Icons.note_add,
                                  title: 'Edit Personal Details',
                                  subtitle: 'Edit your account details',
                                  onTap: () {
                                    context.pushNamed(RouteNames.editProfile);
                                  },
                                ),
                                
                                Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: AppColors.borderLight,
                                ),
                                
                                // Change Password
                                _buildMenuItem(
                                  icon: Icons.help_outline,
                                  title: 'Change Password',
                                  subtitle: 'Change your password',
                                  onTap: () {
                                    context.pushNamed(RouteNames.changePassword);
                                  },
                                ),
                                
                                Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: AppColors.borderLight,
                                ),
                                
                                // Notifications Preferences
                                _buildMenuItem(
                                  icon: Icons.notifications_outlined,
                                  title: 'Notifications Preferences',
                                  subtitle: 'Control alerts, reminders',
                                  onTap: () {
                                    context.pushNamed(RouteNames.notificationSettings);
                                  },
                                ),
                                
                                Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: AppColors.borderLight,
                                ),
                                
                                // Delete Account
                                _buildMenuItem(
                                  icon: Icons.help_outline,
                                  title: 'Delete Account',
                                  subtitle: 'App permissions, security',
                                  onTap: () {
                                    // TODO: Implement delete account functionality
                                  },
                                ),
                              ],
                            ),
                          ),
                          
                          SizedBox(height: AppDimensions.verticalSpaceM),
                          
                          // Logout Button Card
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
                              border: Border.all(
                                color: AppColors.error,
                                width: 1,
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                // TODO: Implement logout functionality
                                _showLogoutDialog(context);
                              },
                              borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
                              child: Padding(
                                padding: EdgeInsets.all(AppDimensions.cardPadding),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.logout,
                                      size: 20.w,
                                      color: AppColors.error,
                                    ),
                                    SizedBox(width: AppDimensions.paddingS),
                                    Text(
                                      'Logout',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.error,
                                      ),
                                    ),
                                  ],
                                ),
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
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.cardPadding),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(AppDimensions.paddingS),
              decoration: BoxDecoration(
                color: AppColors.backgroundSecondary,
                borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
              ),
              child: Icon(
                icon,
                size: 20.w,
                color: AppColors.primary,
              ),
            ),
            
            SizedBox(width: AppDimensions.paddingM),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            Icon(
              Icons.arrow_forward_ios,
              size: 16.w,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
  
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.dialogRadius),
          ),
          title: Text(
            'Logout',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Implement logout functionality
                // Navigate to login screen
                context.goNamed(RouteNames.login);
              },
              child: Text(
                'Logout',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
