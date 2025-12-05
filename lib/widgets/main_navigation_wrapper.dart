import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/routing/route_names.dart';

/// Main Navigation Wrapper with Persistent Bottom Navigation
/// Provides consistent bottom navigation across main app screens
class MainNavigationWrapper extends StatefulWidget {
  final Widget child;

  const MainNavigationWrapper({super.key, required this.child});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateIndexFromRoute();
  }


  void _updateIndexFromRoute() {
    final location = GoRouterState.of(context).matchedLocation;
    final index = _getIndexFromRoute(location);
    if (index != null && _currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  int? _getIndexFromRoute(String route) {
    switch (route) {
      case RouteNames.explore:
        return 0;
      case RouteNames.bookings:
        return 1;
      case RouteNames.home:
        return 2; // Earnings maps to home
      case RouteNames.chat:
        return 3;
      case RouteNames.profile:
        return 4;
      default:
        return null;
    }
  }

  void _onItemTapped(int index) {
    final routes = [
      RouteNames.explore,
      RouteNames.bookings,
      RouteNames.home, // Earnings maps to home
      RouteNames.chat,
      RouteNames.profile,
    ];

    if (index < routes.length) {
      setState(() {
        _currentIndex = index;
      });
      context.go(routes[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

/// Alternative Custom Bottom Navigation (if persistent_bottom_nav_bar doesn't work as expected)
class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(
            color: AppColors.borderLight,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Container(
          height: AppDimensions.bottomNavHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.grid_view_rounded, 'Explore'),
              _buildNavItem(1, Icons.note_add_rounded, 'Bookings'),
              _buildNavItem(2, Icons.credit_card_rounded, 'Earnings'),
              _buildNavItem(3, Icons.chat_bubble_outline_rounded, 'Chats'),
              _buildNavItem(4, Icons.person_rounded, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingS,
          vertical: AppDimensions.paddingXS,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.iconSecondary,
              size: AppDimensions.iconM,
            ),
            SizedBox(height: 2.h),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: isSelected
                      ? AppTextStyles.navLabelActive
                      : AppTextStyles.navLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (isSelected)
                  Container(
                    margin: EdgeInsets.only(top: 2.h),
                    height: 2.h,
                    width: 20.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(1.r),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
