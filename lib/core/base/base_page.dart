import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_dimensions.dart';

/// Base Page Widget
/// Provides consistent page structure and common functionality
class BasePage extends StatelessWidget {
  final String? title;
  final Widget child;
  final List<Widget>? actions;
  final Widget? leading;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final bool showAppBar;
  final bool centerTitle;
  final bool resizeToAvoidBottomInset;
  final Color? backgroundColor;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final PreferredSizeWidget? bottom;
  final bool extendBodyBehindAppBar;
  final bool extendBody;
  final EdgeInsetsGeometry? padding;
  final bool safeArea;
  final VoidCallback? onWillPop;

  const BasePage({
    super.key,
    this.title,
    required this.child,
    this.actions,
    this.leading,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.showAppBar = true,
    this.centerTitle = true,
    this.resizeToAvoidBottomInset = true,
    this.backgroundColor,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
    this.bottom,
    this.extendBodyBehindAppBar = false,
    this.extendBody = false,
    this.padding,
    this.safeArea = true,
    this.onWillPop,
  });

  @override
  Widget build(BuildContext context) {
    Widget body = child;

    // Add padding if specified
    if (padding != null) {
      body = Padding(padding: padding!, child: body);
    }

    // Add safe area if needed
    if (safeArea && !extendBodyBehindAppBar) {
      body = SafeArea(child: body);
    }

    final scaffold = Scaffold(
      backgroundColor: backgroundColor ?? AppColors.background,
      appBar: showAppBar
          ? AppBar(
              title: title != null
                  ? Text(title!, style: AppTextStyles.appBarTitle)
                  : null,
              centerTitle: centerTitle,
              actions: actions,
              leading: leading,
              bottom: bottom,
              backgroundColor: AppColors.background,
              elevation: 0,
              scrolledUnderElevation: 0,
              surfaceTintColor: Colors.transparent,
            )
          : null,
      body: body,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
      endDrawer: endDrawer,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      extendBody: extendBody,
    );

    // Wrap with WillPopScope if onWillPop is provided
    if (onWillPop != null) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            onWillPop!();
          }
        },
        child: scaffold,
      );
    }

    return scaffold;
  }
}

/// Base Page with Loading State
/// Provides consistent loading overlay functionality
class BasePageWithLoading extends StatelessWidget {
  final String? title;
  final Widget child;
  final bool isLoading;
  final String? loadingText;
  final List<Widget>? actions;
  final Widget? leading;
  final Widget? floatingActionButton;
  final bool showAppBar;
  final bool centerTitle;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  const BasePageWithLoading({
    super.key,
    this.title,
    required this.child,
    this.isLoading = false,
    this.loadingText,
    this.actions,
    this.leading,
    this.floatingActionButton,
    this.showAppBar = true,
    this.centerTitle = true,
    this.backgroundColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: title,
      actions: actions,
      leading: leading,
      floatingActionButton: floatingActionButton,
      showAppBar: showAppBar,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      padding: padding,
      child: Stack(children: [child, if (isLoading) _buildLoadingOverlay()]),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: AppColors.overlay,
      child: Center(
        child: Container(
          padding: EdgeInsets.all(AppDimensions.paddingXL),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowMedium,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: AppDimensions.iconXL,
                height: AppDimensions.iconXL,
                child: const CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              ),
              if (loadingText != null) ...[
                SizedBox(height: AppDimensions.verticalSpaceM),
                Text(
                  loadingText!,
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Base Empty State Widget
class BaseEmptyState extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? imagePath;
  final IconData? icon;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const BaseEmptyState({
    super.key,
    required this.title,
    this.subtitle,
    this.imagePath,
    this.icon,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image or Icon
            if (imagePath != null)
              Image.asset(
                imagePath!,
                width: 200.w,
                height: 200.h,
                fit: BoxFit.contain,
              )
            else if (icon != null)
              Icon(
                icon,
                size: AppDimensions.iconXXL * 2,
                color: AppColors.iconTertiary,
              ),

            SizedBox(height: AppDimensions.verticalSpaceL),

            // Title
            Text(
              title,
              style: AppTextStyles.headlineSmall,
              textAlign: TextAlign.center,
            ),

            // Subtitle
            if (subtitle != null) ...[
              SizedBox(height: AppDimensions.verticalSpaceS),
              Text(
                subtitle!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            // Action Button
            if (buttonText != null && onButtonPressed != null) ...[
              SizedBox(height: AppDimensions.verticalSpaceXL),
              SizedBox(
                width: 200.w,
                child: ElevatedButton(
                  onPressed: onButtonPressed,
                  child: Text(buttonText!),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Base Error State Widget
class BaseErrorState extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? buttonText;
  final VoidCallback? onRetry;
  final IconData? icon;

  const BaseErrorState({
    super.key,
    this.title = 'Something went wrong',
    this.subtitle,
    this.buttonText = 'Try Again',
    this.onRetry,
    this.icon = Icons.error_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error Icon
            if (icon != null)
              Icon(
                icon,
                size: AppDimensions.iconXXL * 2,
                color: AppColors.error,
              ),

            SizedBox(height: AppDimensions.verticalSpaceL),

            // Title
            Text(
              title,
              style: AppTextStyles.headlineSmall,
              textAlign: TextAlign.center,
            ),

            // Subtitle
            if (subtitle != null) ...[
              SizedBox(height: AppDimensions.verticalSpaceS),
              Text(
                subtitle!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            // Retry Button
            if (onRetry != null) ...[
              SizedBox(height: AppDimensions.verticalSpaceXL),
              SizedBox(
                width: 200.w,
                child: ElevatedButton(
                  onPressed: onRetry,
                  child: Text(buttonText!),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Base List Item Widget
class BaseListItem extends StatelessWidget {
  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final bool showDivider;

  const BaseListItem({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.padding,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          child: Padding(
            padding: padding ?? EdgeInsets.all(AppDimensions.paddingM),
            child: Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  SizedBox(width: AppDimensions.paddingM),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      title,
                      if (subtitle != null) ...[
                        SizedBox(height: AppDimensions.verticalSpaceXS),
                        subtitle!,
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  SizedBox(width: AppDimensions.paddingM),
                  trailing!,
                ],
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.divider,
            indent: AppDimensions.paddingM,
            endIndent: AppDimensions.paddingM,
          ),
      ],
    );
  }
}
