import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/app_colors.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../utils/responsive.dart';

import 'auth/login_screen.dart';
import 'cart/cart_screen.dart';
import 'categories/categories_screen.dart';
import 'home/home_screen.dart';
import 'profile/profile_screen.dart';
import 'wishlist/wishlist_screen.dart';

class MainNavScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavScreen({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainNavScreen> createState() =>
      _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  late int _currentIndex;

  final List<Widget> _screens = const [
    HomeScreen(),
    CategoriesScreen(),
    WishlistScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();

    _currentIndex = widget.initialIndex.clamp(
      0,
      _screens.length - 1,
    );
  }

  // ===========================================================================
  // TAB SWITCH
  // ===========================================================================

  void switchTab(int index) {
    if (index < 0 || index >= _screens.length) {
      return;
    }

    if (_currentIndex == index) {
      return;
    }

    setState(() {
      _currentIndex = index;
    });
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final cartCount =
        context.watch<CartProvider>().itemCount;

    final wishlistCount =
        context.watch<WishlistProvider>().itemCount;

    final auth =
    context.watch<AuthProvider>();

    final isDesktop =
    Responsive.isDesktop(context);

    final isTablet =
    Responsive.isTablet(context);

    // =========================================================================
    // DESKTOP >= 1200
    // =========================================================================

    if (isDesktop) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Row(
          children: [
            _buildDesktopSidebar(
              cartCount,
              wishlistCount,
              auth,
            ),

            const VerticalDivider(
              width: 1,
              thickness: 1,
              color: AppColors.border,
            ),

            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: _screens,
              ),
            ),
          ],
        ),
      );
    }

    // =========================================================================
    // TABLET 600 - 1199
    // =========================================================================

    if (isTablet) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Row(
          children: [
            _buildTabletNavigationRail(
              cartCount,
              wishlistCount,
            ),

            const VerticalDivider(
              width: 1,
              thickness: 1,
              color: AppColors.border,
            ),

            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: _screens,
              ),
            ),
          ],
        ),
      );
    }

    // =========================================================================
    // MOBILE < 600
    // =========================================================================

    return Scaffold(
      backgroundColor: AppColors.background,

      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      bottomNavigationBar:
      _buildMobileBottomNavigation(
        cartCount,
        wishlistCount,
      ),
    );
  }

  // ===========================================================================
  // MOBILE BOTTOM NAVIGATION
  // ===========================================================================

  Widget _buildMobileBottomNavigation(
      int cartCount,
      int wishlistCount,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: switchTab,

          selectedItemColor:
          AppColors.primary,

          unselectedItemColor:
          AppColors.textMuted,

          backgroundColor:
          Colors.white,

          elevation: 0,

          type:
          BottomNavigationBarType.fixed,

          selectedFontSize: 11,
          unselectedFontSize: 10,

          items: [
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
              ),
              activeIcon: Icon(
                Icons.home_rounded,
              ),
              label: 'Home',
            ),

            const BottomNavigationBarItem(
              icon: Icon(
                Icons.category_outlined,
              ),
              activeIcon: Icon(
                Icons.category_rounded,
              ),
              label: 'Categories',
            ),

            BottomNavigationBarItem(
              icon: _buildBadgeIcon(
                icon:
                Icons.favorite_border_rounded,
                count: wishlistCount,
                badgeColor:
                AppColors.secondary,
                fontSize: 10,
              ),
              activeIcon: _buildBadgeIcon(
                icon:
                Icons.favorite_rounded,
                count: wishlistCount,
                badgeColor:
                AppColors.secondary,
                fontSize: 10,
              ),
              label: 'Wishlist',
            ),

            BottomNavigationBarItem(
              icon: _buildBadgeIcon(
                icon:
                Icons.shopping_bag_outlined,
                count: cartCount,
                badgeColor:
                AppColors.error,
                fontSize: 10,
              ),
              activeIcon: _buildBadgeIcon(
                icon:
                Icons.shopping_bag_rounded,
                count: cartCount,
                badgeColor:
                AppColors.error,
                fontSize: 10,
              ),
              label: 'Cart',
            ),

            const BottomNavigationBarItem(
              icon: Icon(
                Icons.person_outline_rounded,
              ),
              activeIcon: Icon(
                Icons.person_rounded,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // TABLET NAVIGATION RAIL
  // ===========================================================================

  Widget _buildTabletNavigationRail(
      int cartCount,
      int wishlistCount,
      ) {
    return NavigationRail(
      selectedIndex: _currentIndex,
      onDestinationSelected: switchTab,

      backgroundColor: Colors.white,

      labelType:
      NavigationRailLabelType.all,

      minWidth: 76,

      selectedIconTheme:
      const IconThemeData(
        color: AppColors.primary,
        size: 24,
      ),

      unselectedIconTheme:
      const IconThemeData(
        color: AppColors.textMuted,
        size: 23,
      ),

      selectedLabelTextStyle:
      const TextStyle(
        color: AppColors.primary,
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),

      unselectedLabelTextStyle:
      const TextStyle(
        color: AppColors.textMuted,
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),

      leading: Padding(
        padding:
        const EdgeInsets.symmetric(
          vertical: 20,
        ),
        child: Container(
          width: 44,
          height: 44,

          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius:
            BorderRadius.circular(12),
          ),

          child: const Center(
            child: Icon(
              Icons.menu_book_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ),

      destinations: [
        const NavigationRailDestination(
          icon: Icon(
            Icons.home_outlined,
          ),
          selectedIcon: Icon(
            Icons.home_rounded,
          ),
          label: Text('Home'),
        ),

        const NavigationRailDestination(
          icon: Icon(
            Icons.category_outlined,
          ),
          selectedIcon: Icon(
            Icons.category_rounded,
          ),
          label: Text('Categories'),
        ),

        NavigationRailDestination(
          icon: _buildBadgeIcon(
            icon:
            Icons.favorite_border_rounded,
            count: wishlistCount,
            badgeColor:
            AppColors.secondary,
            fontSize: 9,
          ),
          selectedIcon:
          _buildBadgeIcon(
            icon:
            Icons.favorite_rounded,
            count: wishlistCount,
            badgeColor:
            AppColors.secondary,
            fontSize: 9,
          ),
          label: const Text('Wishlist'),
        ),

        NavigationRailDestination(
          icon: _buildBadgeIcon(
            icon:
            Icons.shopping_bag_outlined,
            count: cartCount,
            badgeColor:
            AppColors.error,
            fontSize: 9,
          ),
          selectedIcon:
          _buildBadgeIcon(
            icon:
            Icons.shopping_bag_rounded,
            count: cartCount,
            badgeColor:
            AppColors.error,
            fontSize: 9,
          ),
          label: const Text('Cart'),
        ),

        const NavigationRailDestination(
          icon: Icon(
            Icons.person_outline_rounded,
          ),
          selectedIcon: Icon(
            Icons.person_rounded,
          ),
          label: Text('Profile'),
        ),
      ],
    );
  }

  // ===========================================================================
  // DESKTOP SIDEBAR
  // ===========================================================================

  Widget _buildDesktopSidebar(
      int cartCount,
      int wishlistCount,
      AuthProvider auth,
      ) {
    return Container(
      width: 260,
      color: Colors.white,

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          // -------------------------------------------------------------------
          // LOGO / BRAND
          // -------------------------------------------------------------------

          Padding(
            padding:
            const EdgeInsets.fromLTRB(
              24,
              28,
              24,
              24,
            ),

            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,

                  decoration:
                  BoxDecoration(
                    color:
                    AppColors.primary,

                    borderRadius:
                    BorderRadius.circular(
                      12,
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: AppColors
                            .primary
                            .withValues(
                          alpha: 0.25,
                        ),
                        blurRadius: 10,
                        offset:
                        const Offset(0, 4),
                      ),
                    ],
                  ),

                  child: const Center(
                    child: Icon(
                      Icons
                          .menu_book_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                const Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    children: [
                      Text(
                        'BookStore',
                        maxLines: 1,
                        overflow:
                        TextOverflow
                            .ellipsis,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight:
                          FontWeight.bold,
                          color: AppColors
                              .textPrimary,
                          letterSpacing:
                          -0.3,
                        ),
                      ),

                      SizedBox(height: 2),

                      Text(
                        'Online Library',
                        maxLines: 1,
                        overflow:
                        TextOverflow
                            .ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors
                              .textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(
            height: 1,
            color: AppColors.border,
          ),

          const SizedBox(height: 16),

          // -------------------------------------------------------------------
          // NAVIGATION ITEMS
          // -------------------------------------------------------------------

          Padding(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 16,
            ),

            child: Column(
              children: [
                _buildSidebarItem(
                  index: 0,
                  icon:
                  Icons.home_outlined,
                  activeIcon:
                  Icons.home_rounded,
                  title: 'Home',
                ),

                _buildSidebarItem(
                  index: 1,
                  icon:
                  Icons.category_outlined,
                  activeIcon:
                  Icons.category_rounded,
                  title: 'Categories',
                ),

                _buildSidebarItem(
                  index: 2,
                  icon:
                  Icons.favorite_border_rounded,
                  activeIcon:
                  Icons.favorite_rounded,
                  title: 'Wishlist',
                  badgeCount:
                  wishlistCount,
                  badgeColor:
                  AppColors.secondary,
                ),

                _buildSidebarItem(
                  index: 3,
                  icon:
                  Icons.shopping_bag_outlined,
                  activeIcon:
                  Icons.shopping_bag_rounded,
                  title: 'My Cart',
                  badgeCount:
                  cartCount,
                  badgeColor:
                  AppColors.error,
                ),

                _buildSidebarItem(
                  index: 4,
                  icon:
                  Icons.person_outline_rounded,
                  activeIcon:
                  Icons.person_rounded,
                  title:
                  'Profile & Account',
                ),
              ],
            ),
          ),

          const Spacer(),

          // -------------------------------------------------------------------
          // USER / GUEST CARD
          // -------------------------------------------------------------------

          Padding(
            padding:
            const EdgeInsets.all(16),

            child: _buildUserCard(auth),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // ===========================================================================
  // USER CARD
  // ===========================================================================

  Widget _buildUserCard(
      AuthProvider auth,
      ) {
    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color:
        AppColors.surfaceVariant,

        borderRadius:
        BorderRadius.circular(14),

        border: Border.all(
          color: AppColors.border,
        ),
      ),

      child: auth.isAuthenticated
          ? _buildAuthenticatedUser(auth)
          : _buildGuestUser(),
    );
  }

  // ===========================================================================
  // AUTHENTICATED USER
  // ===========================================================================

  Widget _buildAuthenticatedUser(
      AuthProvider auth,
      ) {
    final userName =
        auth.user?.name.trim() ?? '';

    final userEmail =
        auth.user?.email.trim() ?? '';
    return Row(
      children: [
        CircleAvatar(
          radius: 18,

          backgroundColor:
          AppColors.primary,

          child: Text(
            _getUserInitial(userName),
            style:
            const TextStyle(
              color: Colors.white,
              fontWeight:
              FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            mainAxisSize:
            MainAxisSize.min,

            children: [
              Text(
                userName.isEmpty
                    ? 'User'
                    : userName,

                maxLines: 1,

                overflow:
                TextOverflow.ellipsis,

                style:
                const TextStyle(
                  fontWeight:
                  FontWeight.bold,
                  fontSize: 13,
                  color:
                  AppColors.textPrimary,
                ),
              ),

              if (userEmail.isNotEmpty)
                Text(
                  userEmail,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style:
                  const TextStyle(
                    fontSize: 11,
                    color:
                    AppColors.textSecondary,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // GUEST USER
  // ===========================================================================

  Widget _buildGuestUser() {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.stretch,

      mainAxisSize:
      MainAxisSize.min,

      children: [
        const Text(
          'Welcome Guest',
          maxLines: 1,
          overflow:
          TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight:
            FontWeight.bold,
            fontSize: 12,
            color:
            AppColors.textPrimary,
          ),
        ),

        const SizedBox(height: 4),

        const Text(
          'Sign in to sync your cart & books',
          maxLines: 2,
          overflow:
          TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 10,
            color:
            AppColors.textSecondary,
          ),
        ),

        const SizedBox(height: 8),

        SizedBox(
          height: 34,

          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                  const LoginScreen(),
                ),
              );
            },

            style:
            ElevatedButton.styleFrom(
              minimumSize:
              const Size(
                double.infinity,
                32,
              ),

              padding:
              const EdgeInsets.symmetric(
                horizontal: 10,
              ),

              backgroundColor:
              AppColors.primary,

              shape:
              RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(
                  8,
                ),
              ),
            ),

            child: const Text(
              'Sign In',
              maxLines: 1,
              overflow:
              TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // DESKTOP SIDEBAR ITEM
  // ===========================================================================

  Widget _buildSidebarItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String title,
    int? badgeCount,
    Color? badgeColor,
  }) {
    final isSelected =
        _currentIndex == index;

    final showBadge =
        badgeCount != null &&
            badgeCount > 0;

    return Padding(
      padding:
      const EdgeInsets.only(
        bottom: 6,
      ),

      child: Material(
        color: isSelected
            ? AppColors.primary
            .withValues(
          alpha: 0.10,
        )
            : Colors.transparent,

        borderRadius:
        BorderRadius.circular(10),

        child: InkWell(
          onTap: () =>
              switchTab(index),

          borderRadius:
          BorderRadius.circular(10),

          hoverColor:
          AppColors.primary
              .withValues(
            alpha: 0.05,
          ),

          child: Padding(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),

            child: Row(
              children: [
                Icon(
                  isSelected
                      ? activeIcon
                      : icon,

                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,

                  size: 20,
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Text(
                    title,

                    maxLines: 1,

                    overflow:
                    TextOverflow.ellipsis,

                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                ),

                if (showBadge)
                  const SizedBox(width: 8),

                if (showBadge)
                  Container(
                    constraints:
                    const BoxConstraints(
                      minWidth: 20,
                    ),

                    padding:
                    const EdgeInsets
                        .symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),

                    decoration:
                    BoxDecoration(
                      color:
                      badgeColor ??
                          AppColors.primary,

                      borderRadius:
                      BorderRadius.circular(
                        10,
                      ),
                    ),

                    child: Text(
                      '$badgeCount',

                      textAlign:
                      TextAlign.center,

                      maxLines: 1,

                      overflow:
                      TextOverflow
                          .ellipsis,

                      style:
                      const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // BADGE ICON
  // ===========================================================================

  Widget _buildBadgeIcon({
    required IconData icon,
    required int count,
    required Color badgeColor,
    double fontSize = 10,
  }) {
    return Badge(
      isLabelVisible: count > 0,

      label: Text(
        _badgeText(count),

        style: TextStyle(
          fontSize: fontSize,
          fontWeight:
          FontWeight.w600,
        ),
      ),

      backgroundColor:
      badgeColor,

      child: Icon(icon),
    );
  }

  // ===========================================================================
  // BADGE TEXT
  // ===========================================================================

  String _badgeText(int count) {
    if (count > 99) {
      return '99+';
    }

    return '$count';
  }

  // ===========================================================================
  // USER INITIAL
  // ===========================================================================

  String _getUserInitial(
      String? name,
      ) {
    final value =
        name?.trim() ?? '';

    if (value.isEmpty) {
      return 'U';
    }

    return value
        .substring(0, 1)
        .toUpperCase();
  }
}