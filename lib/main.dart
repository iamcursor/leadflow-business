import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leadflow_business/providers/auth_provider.dart';
import 'package:leadflow_business/providers/business_owner_provider.dart';
import 'core/routing/app_route.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/storage_service.dart';
import 'core/network/api_client.dart';

import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Initialize FCM service
   NotificationService().requestNotificationPermission();
   NotificationService().isTokenRefresh();
   NotificationService().getFcmToken();
  
  // Initialize API client with stored token if available
  await _initializeApp();
  
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => BusinessOwnerProvider()),
        ],
        child: const MyApp(),
      ),
  );
}

/// Initialize app - load stored token and set it in API client
Future<void> _initializeApp() async {
  try {
    final token = await StorageService.instance.getToken();
    if (token != null && token.isNotEmpty) {
      ApiClient.instance.setAuthToken(token);
    }
  } catch (e) {
    // Handle error silently or log it
    debugPrint('Error initializing app: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'LeadFlow Business',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          routerConfig: AppRouter.instance.router,
        );
      },
    );
  }
}
