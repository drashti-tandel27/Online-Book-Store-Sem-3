import 'package:flutter/material.dart';

/// Responsive Breakpoint Utility and Container
class Responsive {
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 1200.0;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobileBreakpoint;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tabletBreakpoint;

  static bool isWide(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= mobileBreakpoint;

  static double screenWidth(BuildContext context) =>
      MediaQuery.sizeOf(context).width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.sizeOf(context).height;

  /// Returns a responsive value based on current screen width
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= tabletBreakpoint) {
      return desktop ?? tablet ?? mobile;
    }
    if (width >= mobileBreakpoint) {
      return tablet ?? mobile;
    }
    return mobile;
  }

  /// Calculates optimal grid column count for catalog and book lists
  static int gridColumns(
    BuildContext context, {
    int mobile = 2,
    int tablet = 3,
    int desktop = 5,
  }) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 1600) return desktop + 1;
    if (width >= tabletBreakpoint) return desktop;
    if (width >= 900) return tablet + 1;
    if (width >= mobileBreakpoint) return tablet;
    return mobile;
  }

  /// Responsive horizontal padding
  static EdgeInsets horizontalPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= tabletBreakpoint) {
      return const EdgeInsets.symmetric(horizontal: 32.0);
    }
    if (width >= mobileBreakpoint) {
      return const EdgeInsets.symmetric(horizontal: 24.0);
    }
    return const EdgeInsets.symmetric(horizontal: 16.0);
  }
}

/// A wrapper widget that centers content and constrains its maximum width
/// on large screens to prevent unnatural horizontal stretching on desktop/web.
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry alignment;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth = 1280.0,
    this.padding,
    this.alignment = Alignment.topCenter,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: padding != null
            ? Padding(padding: padding!, child: child)
            : child,
      ),
    );
  }
}

/// LayoutBuilder widget that dynamically switches between mobile, tablet, and desktop layouts
class ResponsiveLayout extends StatelessWidget {
  final Widget Function(BuildContext context) mobile;
  final Widget Function(BuildContext context)? tablet;
  final Widget Function(BuildContext context)? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= Responsive.tabletBreakpoint && desktop != null) {
          return desktop!(context);
        }
        if (constraints.maxWidth >= Responsive.mobileBreakpoint && tablet != null) {
          return tablet!(context);
        }
        return mobile(context);
      },
    );
  }
}
