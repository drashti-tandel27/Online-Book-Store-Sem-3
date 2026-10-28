import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/book_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../utils/constants.dart';
import '../../utils/responsive.dart';
import '../auth/login_screen.dart';
import '../main_nav_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animController =
        AnimationController(
          vsync: this,
          duration:
          const Duration(milliseconds: 1400),
        );

    _fadeAnimation =
        CurvedAnimation(
          parent: _animController,
          curve: Curves.easeIn,
        );

    _scaleAnimation =
        Tween<double>(
          begin: 0.8,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: _animController,
            curve: Curves.easeOutBack,
          ),
        );

    _animController.forward();

    _initializeApp();
  }

  // ===========================================================================
  // INITIALIZE APP
  // ===========================================================================

  Future<void> _initializeApp() async {
    final minDelay = Future.delayed(
      const Duration(milliseconds: 2000),
    );

    final authProvider =
    Provider.of<AuthProvider>(
      context,
      listen: false,
    );

    final bookProvider =
    Provider.of<BookProvider>(
      context,
      listen: false,
    );

    final cartProvider =
    Provider.of<CartProvider>(
      context,
      listen: false,
    );

    final wishlistProvider =
    Provider.of<WishlistProvider>(
      context,
      listen: false,
    );

    // Preload home data.
    bookProvider.fetchHomeData();

    final isAuth =
    await authProvider.initialize();

    if (isAuth) {
      // Preload authenticated user's data.
      cartProvider.fetchCart();
      wishlistProvider.fetchWishlist();
    }

    await minDelay;

    if (!mounted) return;

    if (isAuth) {
      _navigateTo(
        const MainNavScreen(),
      );
    } else {
      _navigateTo(
        const LoginScreen(),
      );
    }
  }

  // ===========================================================================
  // NAVIGATION
  // ===========================================================================

  void _navigateTo(Widget screen) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) =>
        screen,
        transitionsBuilder:
            (
            context,
            animation,
            secondaryAnimation,
            child,
            ) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration:
        const Duration(milliseconds: 350),
      ),
    );
  }

  // ===========================================================================
  // DISPOSE
  // ===========================================================================

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      AppColors.primary,

      body: SafeArea(
        child: LayoutBuilder(
          builder:
              (context, constraints) {
            final width =
                constraints.maxWidth;

            final isMobile =
                width <
                    Responsive
                        .mobileBreakpoint;

            final logoSize =
            isMobile ? 88.0 : 104.0;

            final logoIconSize =
            isMobile ? 48.0 : 58.0;

            final titleSize =
            isMobile ? 24.0 : 28.0;

            final contentPadding =
            isMobile ? 20.0 : 32.0;

            return Center(
              child: SingleChildScrollView(
                padding:
                EdgeInsets.symmetric(
                  horizontal:
                  contentPadding,
                  vertical: 24,
                ),

                child: FadeTransition(
                  opacity:
                  _fadeAnimation,

                  child: ScaleTransition(
                    scale:
                    _scaleAnimation,

                    child: Column(
                      mainAxisSize:
                      MainAxisSize.min,

                      mainAxisAlignment:
                      MainAxisAlignment
                          .center,

                      children: [
                        _buildLogo(
                          logoSize,
                          logoIconSize,
                        ),

                        SizedBox(
                          height:
                          isMobile
                              ? 22
                              : 26,
                        ),

                        Text(
                          AppConstants
                              .appName,
                          textAlign:
                          TextAlign.center,
                          maxLines: 2,
                          overflow:
                          TextOverflow
                              .ellipsis,
                          style: TextStyle(
                            fontSize:
                            titleSize,
                            fontWeight:
                            FontWeight
                                .bold,
                            color:
                            Colors.white,
                            letterSpacing:
                            -0.5,
                          ),
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        ConstrainedBox(
                          constraints:
                          const BoxConstraints(
                            maxWidth: 420,
                          ),

                          child: const Text(

                            AppConstants
                                .appTagline,
                            textAlign:
                            TextAlign
                                .center,
                            maxLines: 2,
                            overflow:
                            TextOverflow
                                .ellipsis,
                            style:
                            TextStyle(
                              fontSize: 14,
                              color:
                              Colors.white70,
                              fontWeight:
                              FontWeight
                                  .w400,
                              letterSpacing:
                              0.5,
                            ),
                          ),
                        ),

                        SizedBox(
                          height:
                          isMobile
                              ? 40
                              : 48,
                        ),

                        const SizedBox(
                          width: 32,
                          height: 32,
                          child:
                          CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor:
                            AlwaysStoppedAnimation<
                                Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ===========================================================================
  // LOGO
  // ===========================================================================

  Widget _buildLogo(
      double size,
      double iconSize,
      ) {
    return Container(
      width: size,
      height: size,

      decoration:
      BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(
          size * 0.28,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(
              alpha: 0.20,
            ),
            blurRadius: 20,
            offset:
            const Offset(0, 10),
          ),
        ],
      ),

      child: Center(
        child: Icon(
          Icons.menu_book_rounded,
          size: iconSize,
          color:
          AppColors.primary,
        ),
      ),
    );
  }
}