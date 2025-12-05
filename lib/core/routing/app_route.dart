import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../screens/auth/login_page.dart';
import '../../screens/auth/register_page.dart';
import '../../screens/auth/forgot_password_page.dart';
import '../../screens/auth/verify_email_page.dart';
import '../../screens/auth/verification_success_page.dart';
import '../../screens/auth/reset_password_page.dart';
import '../../screens/bookings/bookings_page.dart';
import '../../screens/chat/chat_page.dart';
import '../../screens/explore/explore_page.dart';
import '../../screens/profile/profile_page.dart';
import '../../screens/profile/complete_profile_page.dart';
import '../../screens/profile/complete_profile_step2_page.dart';
import '../../screens/profile/complete_profile_step3_page.dart';
import '../../screens/profile/complete_profile_step4_page.dart';
import '../../screens/profile/complete_profile_step5_page.dart';
import '../../screens/profile/change_password_page.dart';
import '../../screens/splash/splash_page.dart';
import '../../widgets/main_navigation_wrapper.dart';
import 'route_names.dart';
import '../base/base_page.dart';

class AppRouter {
  static AppRouter? _instance;
  late GoRouter _router;

  AppRouter._internal() {
    _router = _createRouter();
  }

  static AppRouter get instance {
    _instance ??= AppRouter._internal();
    return _instance!;
  }

  GoRouter get router => _router;

  /// Create and configure GoRouter
  GoRouter _createRouter() {
    return GoRouter(
      initialLocation: RouteNames.splash,
      debugLogDiagnostics: true,

      // Global error handling
      errorBuilder: (context, state) => ErrorPage(
        error: state.error.toString(),
        routeName: state.matchedLocation,
      ),

      // Route redirect logic
      redirect: (context, state) {
        return _handleRedirect(context, state);
      },

      // Route definitions
      routes: [
        // Splash Route
        GoRoute(
          path: RouteNames.splash,
          name: RouteNames.splash,
          builder: (context, state) => const SplashPage(),
        ),

        // Authentication Routes
        // GoRoute(
        //   path: RouteNames.welcome,
        //   name: RouteNames.welcome,
        //   builder: (context, state) => const WelcomePage(),
        // ),
        GoRoute(
          path: RouteNames.login,
          name: RouteNames.login,
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: RouteNames.register,
          name: RouteNames.register,
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: RouteNames.forgotPassword,
          name: RouteNames.forgotPassword,
          builder: (context, state) => const ForgotPasswordPage(),
        ),
        GoRoute(
          path: RouteNames.otpVerification,
          name: RouteNames.otpVerification,
          builder: (context, state) {
            final emailParam = state.uri.queryParameters['email'];
            final email = emailParam != null ? Uri.decodeComponent(emailParam) : null;
            return VerifyEmailPage(email: email);
          },
        ),
        GoRoute(
          path: RouteNames.verificationSuccess,
          name: RouteNames.verificationSuccess,
          builder: (context, state) {
            final emailParam = state.uri.queryParameters['email'];
            final email = emailParam != null ? Uri.decodeComponent(emailParam) : null;
            return VerificationSuccessPage(email: email);
          },
        ),
        GoRoute(
          path: RouteNames.resetPassword,
          name: RouteNames.resetPassword,
          builder: (context, state) {
            final emailParam = state.uri.queryParameters['email'];
            final email = emailParam != null ? Uri.decodeComponent(emailParam) : null;
            return ResetPasswordPage(email: email);
          },
        ),
        GoRoute(
          path: RouteNames.completeProfile,
          name: RouteNames.completeProfile,
          builder: (context, state) => const CompleteProfilePage(),
        ),
        GoRoute(
          path: RouteNames.completeProfileStep2,
          name: RouteNames.completeProfileStep2,
          builder: (context, state) => const CompleteProfileStep2Page(),
        ),
        GoRoute(
          path: RouteNames.completeProfileStep3,
          name: RouteNames.completeProfileStep3,
          builder: (context, state) => const CompleteProfileStep3Page(),
        ),
        GoRoute(
          path: RouteNames.completeProfileStep4,
          name: RouteNames.completeProfileStep4,
          builder: (context, state) => const CompleteProfileStep4Page(),
        ),
        GoRoute(
          path: RouteNames.completeProfileStep5,
          name: RouteNames.completeProfileStep5,
          builder: (context, state) => const CompleteProfileStep5Page(),
        ),

        // Main Navigation Shell Route with Persistent Bottom Navigation
        ShellRoute(
          builder: (context, state, child) {
            return MainNavigationWrapper(child: child);
          },
          routes: [
            // Home Route
            GoRoute(
              path: RouteNames.home,
              name: RouteNames.home,
              builder: (context, state) => const HomePage(),
            ),

            // Explore Route
            GoRoute(
              path: RouteNames.explore,
              name: RouteNames.explore,
              builder: (context, state) => const ExplorePage(),
            ),

            // Bookings Route
            GoRoute(
              path: RouteNames.bookings,
              name: RouteNames.bookings,
              builder: (context, state) => const BookingsPage(),
            ),

            // Chat Route
            GoRoute(
              path: RouteNames.chat,
              name: RouteNames.chat,
              builder: (context, state) => const ChatPage(),
            ),

            // Profile Route
            GoRoute(
              path: RouteNames.profile,
              name: RouteNames.profile,
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),

        // Service Provider Detail Route (outside shell for full screen)
        GoRoute(
          path: '/service-provider-detail/:providerId',
          name: RouteNames.serviceProviderDetail,
          builder: (context, state) {
            final providerId = state.pathParameters['providerId']!;
            return ServiceProviderDetailPage(providerId: providerId);
          },
        ),

        // Booking Detail Route
        GoRoute(
          path: '/booking-detail/:bookingId',
          name: RouteNames.bookingDetail,
          builder: (context, state) {
            final bookingId = state.pathParameters['bookingId']!;
            return BookingDetailPage(bookingId: bookingId);
          },
        ),

        // Service Booking Route
        GoRoute(
          path: '/service-booking/:providerId/:serviceId',
          name: RouteNames.serviceBooking,
          builder: (context, state) {
            final providerId = state.pathParameters['providerId']!;
            final serviceId = state.pathParameters['serviceId']!;
            return ServiceBookingPage(
              providerId: providerId,
              serviceId: serviceId,
            );
          },
        ),

        // Chat Detail Route
        GoRoute(
          path: '/chat-detail/:conversationId',
          name: RouteNames.chatDetail,
          builder: (context, state) {
            final conversationId = state.pathParameters['conversationId']!;
            return ChatDetailPage(conversationId: conversationId);
          },
        ),

        // Search Route
        GoRoute(
          path: RouteNames.search,
          name: RouteNames.search,
          builder: (context, state) => const SearchPage(),
        ),

        // Settings Route
        GoRoute(
          path: RouteNames.settings,
          name: RouteNames.settings,
          builder: (context, state) => const SettingsPage(),
        ),

        // Edit Profile Route
        GoRoute(
          path: RouteNames.editProfile,
          name: RouteNames.editProfile,
          builder: (context, state) => const EditProfilePage(),
        ),

        // Change Password Route
        GoRoute(
          path: RouteNames.changePassword,
          name: RouteNames.changePassword,
          builder: (context, state) => const ChangePasswordPage(),
        ),

        // Notifications Route
        GoRoute(
          path: RouteNames.notifications,
          name: RouteNames.notifications,
          builder: (context, state) => const NotificationsPage(),
        ),

        // Favorites Route
        GoRoute(
          path: RouteNames.favorites,
          name: RouteNames.favorites,
          builder: (context, state) => const FavoritesPage(),
        ),

        // Help Center Route
        GoRoute(
          path: RouteNames.helpCenter,
          name: RouteNames.helpCenter,
          builder: (context, state) => const HelpCenterPage(),
        ),

        // Write Review Route
        GoRoute(
          path: RouteNames.writeReview,
          name: RouteNames.writeReview,
          builder: (context, state) {
            final bookingId = state.uri.queryParameters['bookingId'];
            final providerId = state.uri.queryParameters['providerId'];
            return WriteReviewPage(
              bookingId: bookingId,
              providerId: providerId,
            );
          },
        ),

        // Payment Routes
        GoRoute(
          path: RouteNames.payment,
          name: RouteNames.payment,
          builder: (context, state) {
            final bookingId = state.uri.queryParameters['bookingId'];
            return PaymentPage(bookingId: bookingId);
          },
        ),

        GoRoute(
          path: RouteNames.paymentSuccess,
          name: RouteNames.paymentSuccess,
          builder: (context, state) {
            final paymentId = state.uri.queryParameters['paymentId'];
            return PaymentSuccessPage(paymentId: paymentId);
          },
        ),

        // Legal Routes
        GoRoute(
          path: RouteNames.termsOfService,
          name: RouteNames.termsOfService,
          builder: (context, state) => const TermsOfServicePage(),
        ),

        GoRoute(
          path: RouteNames.privacyPolicy,
          name: RouteNames.privacyPolicy,
          builder: (context, state) => const PrivacyPolicyPage(),
        ),
      ],
    );
  }

  /// Handle route redirects and authentication
  String? _handleRedirect(BuildContext context, GoRouterState state) {
    final location = state.matchedLocation;

    // TODO: Implement authentication check
    // final isAuthenticated = ref.watch(authProvider).isAuthenticated;
    // For now, allow all routes during development

    // Redirect logic will be implemented when authentication is added
    // if (!isAuthenticated && RouteNames.requiresAuth(location)) {
    //   return RouteNames.welcome;
    // }
    //
    // if (isAuthenticated && RouteNames.authRoutes.contains(location)) {
    //   return RouteNames.home;
    // }

    return null; // No redirect needed during development
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BasePage(
      title: 'Home',
      showAppBar: false,
      child: Center(child: Text('Home Page - Coming Soon')),
    );
  }
}

/// Extension for easy navigation
extension AppRouterExtension on GoRouter {
  /// Navigate to route with proper disposal of previous route
  void navigateAndDispose(
      String routeName, {
        Map<String, String>? pathParameters,
        Map<String, dynamic>? queryParameters,
      }) {
    if (pathParameters != null || queryParameters != null) {
      goNamed(
        routeName,
        pathParameters: pathParameters ?? {},
        queryParameters:
        queryParameters?.map(
              (key, value) => MapEntry(key, value.toString()),
        ) ??
            {},
      );
    } else {
      goNamed(routeName);
    }
  }

  /// Push route without disposing previous route
  void pushRoute(
      String routeName, {
        Map<String, String>? pathParameters,
        Map<String, dynamic>? queryParameters,
      }) {
    if (pathParameters != null || queryParameters != null) {
      pushNamed(
        routeName,
        pathParameters: pathParameters ?? {},
        queryParameters:
        queryParameters?.map(
              (key, value) => MapEntry(key, value.toString()),
        ) ??
            {},
      );
    } else {
      pushNamed(routeName);
    }
  }

  /// Replace current route
  void replaceRoute(
      String routeName, {
        Map<String, String>? pathParameters,
        Map<String, dynamic>? queryParameters,
      }) {
    if (pathParameters != null || queryParameters != null) {
      pushReplacementNamed(
        routeName,
        pathParameters: pathParameters ?? {},
        queryParameters:
        queryParameters?.map(
              (key, value) => MapEntry(key, value.toString()),
        ) ??
            {},
      );
    } else {
      pushReplacementNamed(routeName);
    }
  }
}

// Placeholder pages (to be implemented in respective screens)
class ServiceProviderDetailPage extends StatelessWidget {
  final String providerId;
  const ServiceProviderDetailPage({super.key, required this.providerId});
  @override
  Widget build(BuildContext context) => BasePage(
    title: 'Provider Detail',
    child: Center(child: Text('Provider: $providerId')),
  );
}

class BookingDetailPage extends StatelessWidget {
  final String bookingId;
  const BookingDetailPage({super.key, required this.bookingId});
  @override
  Widget build(BuildContext context) => BasePage(
    title: 'Booking Detail',
    child: Center(child: Text('Booking: $bookingId')),
  );
}

class ServiceBookingPage extends StatelessWidget {
  final String providerId;
  final String serviceId;
  const ServiceBookingPage({
    super.key,
    required this.providerId,
    required this.serviceId,
  });
  @override
  Widget build(BuildContext context) => BasePage(
    title: 'Book Service',
    child: Center(child: Text('Provider: $providerId, Service: $serviceId')),
  );
}

class ChatDetailPage extends StatelessWidget {
  final String conversationId;
  const ChatDetailPage({super.key, required this.conversationId});
  @override
  Widget build(BuildContext context) => BasePage(
    title: 'Chat',
    child: Center(child: Text('Conversation: $conversationId')),
  );
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});
  @override
  Widget build(BuildContext context) => const BasePage(
    title: 'Search',
    child: Center(child: Text('Search Page')),
  );
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) => const BasePage(
    title: 'Settings',
    child: Center(child: Text('Settings Page')),
  );
}

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});
  @override
  Widget build(BuildContext context) => const BasePage(
    title: 'Edit Profile',
    child: Center(child: Text('Edit Profile Page')),
  );
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});
  @override
  Widget build(BuildContext context) => const BasePage(
    title: 'Notifications',
    child: Center(child: Text('Notifications Page')),
  );
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});
  @override
  Widget build(BuildContext context) => const BasePage(
    title: 'Favorites',
    child: Center(child: Text('Favorites Page')),
  );
}

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});
  @override
  Widget build(BuildContext context) => const BasePage(
    title: 'Help Center',
    child: Center(child: Text('Help Center Page')),
  );
}

class WriteReviewPage extends StatelessWidget {
  final String? bookingId;
  final String? providerId;
  const WriteReviewPage({super.key, this.bookingId, this.providerId});
  @override
  Widget build(BuildContext context) => BasePage(
    title: 'Write Review',
    child: Center(child: Text('Review for: $providerId')),
  );
}

class PaymentPage extends StatelessWidget {
  final String? bookingId;
  const PaymentPage({super.key, this.bookingId});
  @override
  Widget build(BuildContext context) => BasePage(
    title: 'Payment',
    child: Center(child: Text('Payment for: $bookingId')),
  );
}

class PaymentSuccessPage extends StatelessWidget {
  final String? paymentId;
  const PaymentSuccessPage({super.key, this.paymentId});
  @override
  Widget build(BuildContext context) => BasePage(
    title: 'Payment Success',
    child: Center(child: Text('Payment: $paymentId')),
  );
}

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});
  @override
  Widget build(BuildContext context) => const BasePage(
    title: 'Terms of Service',
    child: Center(child: Text('Terms of Service')),
  );
}

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});
  @override
  Widget build(BuildContext context) => const BasePage(
    title: 'Privacy Policy',
    child: Center(child: Text('Privacy Policy')),
  );
}

class ErrorPage extends StatelessWidget {
  final String error;
  final String routeName;
  const ErrorPage({super.key, required this.error, required this.routeName});
  @override
  Widget build(BuildContext context) => BasePage(
    title: 'Error',
    child: Center(
      child: Column(
        children: [Text('Error: $error'), Text('Route: $routeName')],
      ),
    ),
  );
}
