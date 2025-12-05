

import 'package:flutter_screenutil/flutter_screenutil.dart';

/// App Dimensions using ScreenUtil for responsive design
/// All dimensions are responsive and work across all screen sizes including iPad
class AppDimensions {
  AppDimensions._();

  // Padding & Margins
  static double get paddingXS => 4.w;
  static double get paddingS => 8.w;
  static double get paddingM => 16.w;
  static double get paddingL => 24.w;
  static double get paddingXL => 32.w;
  static double get paddingXXL => 48.w;

  // Vertical Spacing
  static double get verticalSpaceXS => 4.h;
  static double get verticalSpaceS => 8.h;
  static double get verticalSpaceM => 16.h;
  static double get verticalSpaceL => 24.h;
  static double get verticalSpaceXL => 32.h;
  static double get verticalSpaceXXL => 48.h;

  // Border Radius
  static double get radiusXS => 4.r;
  static double get radiusS => 8.r;
  static double get radiusM => 12.r;
  static double get radiusL => 16.r;
  static double get radiusXL => 24.r;
  static double get radiusXXL => 32.r;
  static double get radiusRound => 50.r;

  // Icon Sizes
  static double get iconXS => 12.w;
  static double get iconS => 16.w;
  static double get iconM => 24.w;
  static double get iconL => 32.w;
  static double get iconXL => 48.w;
  static double get iconXXL => 64.w;

  // Button Dimensions
  static double get buttonHeight => 48.h;
  static double get buttonHeightS => 36.h;
  static double get buttonHeightL => 56.h;
  static double get buttonRadius => 12.r;
  static double get buttonPadding => 16.w;

  // Input Field Dimensions
  static double get inputHeight => 48.h;
  static double get inputRadius => 8.r;
  static double get inputPadding => 16.w;

  // Card Dimensions
  static double get cardRadius => 12.r;
  static double get cardPadding => 16.w;
  static double get cardElevation => 2.0;

  // App Bar
  static double get appBarHeight => 56.h;
  static double get appBarElevation => 0.0;

  // Bottom Navigation
  static double get bottomNavHeight => 60.h;
  static double get bottomNavRadius => 16.r;

  // Avatar Sizes
  static double get avatarS => 32.w;
  static double get avatarM => 48.w;
  static double get avatarL => 64.w;
  static double get avatarXL => 96.w;

  // Service Provider Card
  static double get serviceCardHeight => 120.h;
  static double get serviceCardWidth => 280.w;
  static double get serviceCardRadius => 12.r;

  // Service Category Icon
  static double get categoryIconSize => 48.w;
  static double get categoryIconRadius => 12.r;

  // Rating Star Size
  static double get ratingStarSize => 16.w;

  // Search Bar
  static double get searchBarHeight => 44.h;
  static double get searchBarRadius => 22.r;

  // Banner Dimensions
  static double get bannerHeight => 140.h;
  static double get bannerRadius => 12.r;

  // Divider
  static double get dividerThickness => 1.0;
  static double get dividerIndent => 16.w;

  // Shadow
  static double get shadowBlurRadius => 8.0;
  static double get shadowSpreadRadius => 0.0;
  static double get shadowOffset => 2.0;

  // Snackbar
  static double get snackbarRadius => 8.r;
  static double get snackbarPadding => 16.w;
  static double get snackbarMargin => 16.w;

  // Modal/Dialog
  static double get dialogRadius => 16.r;
  static double get dialogPadding => 24.w;
  static double get dialogMaxWidth => 320.w;

  // List Item
  static double get listItemHeight => 72.h;
  static double get listItemPadding => 16.w;

  // Booking Card
  static double get bookingCardHeight => 100.h;
  static double get bookingCardRadius => 12.r;

  // Status Indicator
  static double get statusIndicatorSize => 8.w;
  static double get statusIndicatorRadius => 4.r;

  // Progress Indicator
  static double get progressIndicatorSize => 24.w;
  static double get progressIndicatorStroke => 2.0;

  // Tab Bar
  static double get tabBarHeight => 48.h;
  static double get tabIndicatorHeight => 3.h;

  // Floating Action Button
  static double get fabSize => 56.w;
  static double get fabMiniSize => 40.w;

  // Screen Padding
  static double get screenPaddingHorizontal => 16.w;
  static double get screenPaddingVertical => 16.h;
  static double get screenPaddingTop => 22.h; // Safe area top

  // Responsive Breakpoints
  static double get mobileMaxWidth => 480.w;
  static double get tabletMaxWidth => 768.w;
  static double get desktopMinWidth => 1024.w;

  // Animation Durations (in milliseconds)
  static const int animationDurationFast = 200;
  static const int animationDurationNormal = 300;
  static const int animationDurationSlow = 500;
}
