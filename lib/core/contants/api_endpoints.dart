
import 'app_contants.dart';

/// API Endpoints Configuration
/// Centralizes all API endpoint definitions for easy maintenance
class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://leadflow.techaelia.com';
  // static const String _apiVersion = AppConstants.apiVersion;
  // static const String _apiPrefix = '$_baseUrl';

  // Authentication Endpoints
  static const String login = '$baseUrl/users/login/';
  static const String register = '$baseUrl/users/signup/';
  static const String sendOTP = '$baseUrl/users/send-otp/';
  static const String verifyOTP = '$baseUrl/users/verify-otp/';
  static const String resetPassword = '$baseUrl/users/update-password/';
  // static const String logout = '$baseUrl/auth/logout';
  // static const String refreshToken = '$_apiPrefix/auth/refresh';
  // static const String forgotPassword = '$_apiPrefix/auth/forgot-password';



  // static const String socialLogin = '$_apiPrefix/auth/social-login';
  //
  // User Profile Endpoints
  static const String updateBusinessOwnerProfile = '$baseUrl/users/business-owner-profile/update/';
  static const String uploadFile = '$baseUrl/files/upload/';
  // static const String updateProfile = '$_apiPrefix/user/profile';
  // static const String uploadAvatar = '$_apiPrefix/user/avatar';
  // static const String deleteAccount = '$_apiPrefix/user/delete-account';
  static const String changePassword = '$baseUrl/users/change-password/';
  //
  // // Service Categories Endpoints
  // static const String categories = '$_apiPrefix/categories';
  // static const String categoryById = '$_apiPrefix/categories/{id}';
  //
  // // Service Providers Endpoints
  // static const String providers = '$_apiPrefix/providers';
  // static const String providerById = '$_apiPrefix/providers/{id}';
  // static const String providersByCategory =
  //     '$_apiPrefix/providers/category/{categoryId}';
  // static const String nearbyProviders = '$_apiPrefix/providers/nearby';
  // static const String searchProviders = '$_apiPrefix/providers/search';
  // static const String topRatedProviders = '$_apiPrefix/providers/top-rated';
  // static const String recommendedProviders =
  //     '$_apiPrefix/providers/recommended';
  //
  // // Booking Endpoints
  // static const String bookings = '$_apiPrefix/bookings';
  // static const String bookingById = '$_apiPrefix/bookings/{id}';
  // static const String createBooking = '$_apiPrefix/bookings';
  // static const String updateBooking = '$_apiPrefix/bookings/{id}';
  // static const String cancelBooking = '$_apiPrefix/bookings/{id}/cancel';
  // static const String rescheduleBooking =
  //     '$_apiPrefix/bookings/{id}/reschedule';
  // static const String userBookings = '$_apiPrefix/user/bookings';
  // static const String providerBookings = '$_apiPrefix/provider/bookings';
  // static const String bookingHistory = '$_apiPrefix/bookings/history';
  //
  // // Payment Endpoints
  // static const String payments = '$_apiPrefix/payments';
  // static const String paymentMethods = '$_apiPrefix/payments/methods';
  // static const String processPayment = '$_apiPrefix/payments/process';
  // static const String paymentHistory = '$_apiPrefix/payments/history';
  // static const String paymentStatus = '$_apiPrefix/payments/{id}/status';
  // static const String refundPayment = '$_apiPrefix/payments/{id}/refund';
  //
  // // Reviews and Ratings Endpoints
  // static const String reviews = '$_apiPrefix/reviews';
  // static const String reviewById = '$_apiPrefix/reviews/{id}';
  // static const String providerReviews = '$_apiPrefix/providers/{id}/reviews';
  // static const String userReviews = '$_apiPrefix/user/reviews';
  // static const String submitReview = '$_apiPrefix/reviews';
  // static const String updateReview = '$_apiPrefix/reviews/{id}';
  // static const String deleteReview = '$_apiPrefix/reviews/{id}';
  //
  // // Location Endpoints
  // static const String locations = '$_apiPrefix/locations';
  // static const String searchLocations = '$_apiPrefix/locations/search';
  // static const String nearbyLocations = '$_apiPrefix/locations/nearby';
  //
  // // Notifications Endpoints
  // static const String notifications = '$_apiPrefix/notifications';
  // static const String markNotificationRead =
  //     '$_apiPrefix/notifications/{id}/read';
  // static const String markAllNotificationsRead =
  //     '$_apiPrefix/notifications/read-all';
  // static const String deleteNotification = '$_apiPrefix/notifications/{id}';
  // static const String notificationSettings =
  //     '$_apiPrefix/notifications/settings';
  //
  // // Promotions and Offers Endpoints
  // static const String promotions = '$_apiPrefix/promotions';
  // static const String activePromotions = '$_apiPrefix/promotions/active';
  // static const String applyCoupon = '$_apiPrefix/promotions/apply-coupon';
  // static const String validateCoupon = '$_apiPrefix/promotions/validate-coupon';
  //
  // // Support Endpoints
  // static const String supportTickets = '$_apiPrefix/support/tickets';
  // static const String createSupportTicket = '$_apiPrefix/support/tickets';
  // static const String supportTicketById = '$_apiPrefix/support/tickets/{id}';
  // static const String faq = '$_apiPrefix/support/faq';
  //
  // // Settings Endpoints
  // static const String appSettings = '$_apiPrefix/settings/app';
  // static const String userSettings = '$_apiPrefix/settings/user';
  // static const String updateSettings = '$_apiPrefix/settings/user';
  //
  // // File Upload Endpoints
  // static const String uploadFile = '$_apiPrefix/files/upload';
  // static const String uploadImage = '$_apiPrefix/files/upload/image';
  // static const String uploadDocument = '$_apiPrefix/files/upload/document';
  //
  // // Analytics Endpoints
  // static const String trackEvent = '$_apiPrefix/analytics/event';
  // static const String trackScreen = '$_apiPrefix/analytics/screen';
  //
  // // Provider Specific Endpoints (for service providers)
  // static const String providerProfile = '$_apiPrefix/provider/profile';
  // static const String providerServices = '$_apiPrefix/provider/services';
  // static const String providerAvailability =
  //     '$_apiPrefix/provider/availability';
  // static const String updateAvailability = '$_apiPrefix/provider/availability';
  // static const String providerStats = '$_apiPrefix/provider/stats';
  // static const String providerEarnings = '$_apiPrefix/provider/earnings';
  //
  // // Chat/Messaging Endpoints
  // static const String conversations = '$_apiPrefix/conversations';
  // static const String conversationById = '$_apiPrefix/conversations/{id}';
  // static const String sendMessage = '$_apiPrefix/conversations/{id}/messages';
  // static const String messages = '$_apiPrefix/conversations/{id}/messages';
  //
  // // Favorites Endpoints
  // static const String favorites = '$_apiPrefix/user/favorites';
  // static const String addToFavorites = '$_apiPrefix/user/favorites';
  // static const String removeFromFavorites = '$_apiPrefix/user/favorites/{id}';
  //
  // // Search Endpoints
  // static const String search = '$_apiPrefix/search';
  // static const String searchSuggestions = '$_apiPrefix/search/suggestions';
  // static const String searchHistory = '$_apiPrefix/search/history';

  // Utility Methods

  /// Replace path parameters in endpoint URL
  /// Example: replacePathParam('/providers/{id}', 'id', '123') -> '/providers/123'
  static String replacePathParam(String endpoint, String param, String value) {
    return endpoint.replaceAll('{$param}', value);
  }

  /// Build query string from parameters
  /// Example: buildQueryString({'page': '1', 'limit': '20'}) -> '?page=1&limit=20'
  static String buildQueryString(Map<String, dynamic> params) {
    if (params.isEmpty) return '';

    final queryParams = params.entries
        .where((entry) => entry.value != null)
        .map(
          (entry) =>
      '${entry.key}=${Uri.encodeComponent(entry.value.toString())}',
    )
        .join('&');

    return queryParams.isNotEmpty ? '?$queryParams' : '';
  }

  /// Get full URL with query parameters
  static String getFullUrl(
      String endpoint, [
        Map<String, dynamic>? queryParams,
      ]) {
    final baseEndpoint = endpoint;
    final queryString = queryParams != null
        ? buildQueryString(queryParams)
        : '';
    return '$baseEndpoint$queryString';
  }

  /// Common query parameters
  static Map<String, dynamic> paginationParams({
    int page = 1,
    int limit = AppConstants.defaultPageSize,
  }) {
    return {'page': page, 'limit': limit};
  }

  static Map<String, dynamic> locationParams({
    required double latitude,
    required double longitude,
    double radius = AppConstants.searchRadius,
  }) {
    return {'latitude': latitude, 'longitude': longitude, 'radius': radius};
  }

  static Map<String, dynamic> searchParams({
    required String query,
    String? category,
    double? minRating,
    double? maxPrice,
    String? sortBy,
  }) {
    return {
      'q': query,
      if (category != null) 'category': category,
      if (minRating != null) 'min_rating': minRating,
      if (maxPrice != null) 'max_price': maxPrice,
      if (sortBy != null) 'sort_by': sortBy,
    };
  }
}
