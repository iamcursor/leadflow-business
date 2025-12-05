/// Route Names Constants
/// Centralizes all route names for consistent navigation throughout the app
class RouteNames {
  RouteNames._();

  // Root Routes
  static const String root = '/';
  static const String splash = '/splash';

  // Authentication Routes
  // static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String otpVerification = '/otp-verification';
  static const String verificationSuccess = '/verification-success';

  // Onboarding Routes
  static const String onboarding = '/onboarding';

  // Main Navigation Routes (with persistent bottom nav)
  static const String home = '/home';
  static const String explore = '/explore';
  static const String bookings = '/bookings';
  static const String chat = '/chat';
  static const String profile = '/profile';

  // Service Routes
  static const String serviceCategory = '/service-category';
  static const String serviceProvider = '/service-provider';
  static const String serviceProviderDetail = '/service-provider-detail';
  static const String serviceBooking = '/service-booking';
  static const String serviceCheckout = '/service-checkout';

  // Booking Routes
  static const String bookingDetail = '/booking-detail';
  static const String bookingTracking = '/booking-tracking';
  static const String bookingHistory = '/booking-history';
  static const String bookingReschedule = '/booking-reschedule';

  // Payment Routes
  static const String payment = '/payment';
  static const String paymentMethods = '/payment-methods';
  static const String paymentHistory = '/payment-history';
  static const String paymentSuccess = '/payment-success';
  static const String paymentFailed = '/payment-failed';

  // Review Routes
  static const String writeReview = '/write-review';
  static const String reviewList = '/review-list';

  // Profile Routes
  static const String completeProfile = '/complete-profile';
  static const String completeProfileStep2 = '/complete-profile-step2';
  static const String completeProfileStep3 = '/complete-profile-step3';
  static const String completeProfileStep4 = '/complete-profile-step4';
  static const String completeProfileStep5 = '/complete-profile-step5';
  static const String editProfile = '/edit-profile';
  static const String changePassword = '/change-password';
  static const String savedAddresses = '/saved-addresses';
  static const String addAddress = '/add-address';
  static const String editAddress = '/edit-address';

  // Settings Routes
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String notificationSettings = '/notification-settings';
  static const String languageSettings = '/language-settings';
  static const String privacySettings = '/privacy-settings';

  // Support Routes
  static const String helpCenter = '/help-center';
  static const String contactSupport = '/contact-support';
  static const String faq = '/faq';
  static const String reportIssue = '/report-issue';

  // Favorites Routes
  static const String favorites = '/favorites';

  // Search Routes
  static const String search = '/search';
  static const String searchResults = '/search-results';

  // Location Routes
  static const String selectLocation = '/select-location';
  static const String locationPermission = '/location-permission';

  // Chat Routes
  static const String chatDetail = '/chat-detail';
  static const String chatList = '/chat-list';

  // Promotion Routes
  static const String promotions = '/promotions';
  static const String promotionDetail = '/promotion-detail';

  // Legal Routes
  static const String termsOfService = '/terms-of-service';
  static const String privacyPolicy = '/privacy-policy';

  // Error Routes
  static const String notFound = '/not-found';
  static const String error = '/error';

  // Provider Routes (for service providers)
  static const String providerDashboard = '/provider-dashboard';
  static const String providerProfile = '/provider-profile';
  static const String providerServices = '/provider-services';
  static const String providerBookings = '/provider-bookings';
  static const String providerEarnings = '/provider-earnings';
  static const String providerAvailability = '/provider-availability';

  // Route Paths with Parameters
  static String serviceProviderDetailPath(String providerId) =>
      '/service-provider-detail/$providerId';

  static String bookingDetailPath(String bookingId) =>
      '/booking-detail/$bookingId';

  static String chatDetailPath(String conversationId) =>
      '/chat-detail/$conversationId';

  static String serviceBookingPath(String providerId, String serviceId) =>
      '/service-booking/$providerId/$serviceId';

  static String editAddressPath(String addressId) => '/edit-address/$addressId';

  static String promotionDetailPath(String promotionId) =>
      '/promotion-detail/$promotionId';

  // Route Groups for easier navigation handling
  static const List<String> authRoutes = [
    // welcome,
    login,
    register,
    forgotPassword,
    resetPassword,
    otpVerification,
  ];

  static const List<String> mainNavigationRoutes = [
    home,
    explore,
    bookings,
    chat,
    profile,
  ];

  static const List<String> publicRoutes = [
    splash,
    // welcome,
    login,
    register,
    forgotPassword,
    resetPassword,
    otpVerification,
    onboarding,
    termsOfService,
    privacyPolicy,
  ];

  static const List<String> protectedRoutes = [
    home,
    explore,
    bookings,
    chat,
    profile,
    serviceProvider,
    serviceProviderDetail,
    serviceBooking,
    serviceCheckout,
    bookingDetail,
    bookingTracking,
    payment,
    writeReview,
    editProfile,
    settings,
    favorites,
  ];

  /// Check if route requires authentication
  static bool requiresAuth(String route) {
    return protectedRoutes.contains(route) ||
        route.startsWith('/service-provider-detail/') ||
        route.startsWith('/booking-detail/') ||
        route.startsWith('/chat-detail/') ||
        route.startsWith('/service-booking/');
  }

  /// Check if route is part of main navigation
  static bool isMainNavigationRoute(String route) {
    return mainNavigationRoutes.contains(route);
  }

  /// Check if route is public (no auth required)
  static bool isPublicRoute(String route) {
    return publicRoutes.contains(route);
  }

  /// Get route name without parameters
  static String getRouteNameWithoutParams(String fullPath) {
    // Remove query parameters
    final pathWithoutQuery = fullPath.split('?').first;

    // Handle parameterized routes
    if (pathWithoutQuery.startsWith('/service-provider-detail/')) {
      return serviceProviderDetail;
    } else if (pathWithoutQuery.startsWith('/booking-detail/')) {
      return bookingDetail;
    } else if (pathWithoutQuery.startsWith('/chat-detail/')) {
      return chatDetail;
    } else if (pathWithoutQuery.startsWith('/service-booking/')) {
      return serviceBooking;
    } else if (pathWithoutQuery.startsWith('/edit-address/')) {
      return editAddress;
    } else if (pathWithoutQuery.startsWith('/promotion-detail/')) {
      return promotionDetail;
    }

    return pathWithoutQuery;
  }

  /// Get bottom navigation index for route
  static int? getBottomNavIndex(String route) {
    switch (route) {
      case home:
        return 0;
      case explore:
        return 1;
      case bookings:
        return 2;
      case chat:
        return 3;
      case profile:
        return 4;
      default:
        return null;
    }
  }

  /// Get route from bottom navigation index
  static String getRouteFromBottomNavIndex(int index) {
    switch (index) {
      case 0:
        return home;
      case 1:
        return explore;
      case 2:
        return bookings;
      case 3:
        return chat;
      case 4:
        return profile;
      default:
        return home;
    }
  }
}
