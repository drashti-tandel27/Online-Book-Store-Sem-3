import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../utils/responsive.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../auth/login_screen.dart';
import '../orders/orders_screen.dart';
import '../wishlist/wishlist_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // ===========================================================================
  // CHANGE PASSWORD
  // ===========================================================================

  void _showChangePasswordModal(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    final currentPwController =
    TextEditingController();
    final newPwController =
    TextEditingController();
    final confirmPwController =
    TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: Responsive.isMobile(context)
                  ? 20
                  : 32,
              right: Responsive.isMobile(context)
                  ? 20
                  : 32,
              top: 24,
              bottom:
              MediaQuery.viewInsetsOf(ctx).bottom +
                  24,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 560,
                ),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Change Password',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.close,
                              ),
                              onPressed: () =>
                                  Navigator.pop(ctx),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        CustomTextField(
                          controller:
                          currentPwController,
                          label: 'Current Password',
                          hint:
                          'Enter your existing password',
                          prefixIcon:
                          Icons.lock_outline_rounded,
                          isPassword: true,
                          validator:
                          Validators.password,
                        ),

                        const SizedBox(height: 14),

                        CustomTextField(
                          controller:
                          newPwController,
                          label: 'New Password',
                          hint:
                          'At least 6 characters',
                          prefixIcon:
                          Icons.lock_reset_rounded,
                          isPassword: true,
                          validator:
                          Validators.password,
                        ),

                        const SizedBox(height: 14),

                        CustomTextField(
                          controller:
                          confirmPwController,
                          label:
                          'Confirm New Password',
                          hint:
                          'Re-enter new password',
                          prefixIcon:
                          Icons.lock_reset_rounded,
                          isPassword: true,
                          validator: (val) =>
                              Validators
                                  .confirmPassword(
                                val,
                                newPwController.text,
                              ),
                        ),

                        const SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            text: 'Update Password',
                            onPressed: () async {
                              if (!formKey
                                  .currentState!
                                  .validate()) {
                                return;
                              }

                              Navigator.pop(ctx);

                              final auth =
                              Provider.of<AuthProvider>(
                                context,
                                listen: false,
                              );

                              final success =
                              await auth.changePassword(
                                currentPassword:
                                currentPwController.text,
                                newPassword:
                                newPwController.text,
                                newPasswordConfirmation:
                                confirmPwController.text,
                              );

                              if (context.mounted) {
                                if (success) {
                                  Helpers.showSnackBar(
                                    context,
                                    'Password updated successfully!',
                                    isSuccess: true,
                                  );
                                } else if (
                                auth.errorMessage != null
                                ) {
                                  Helpers.showSnackBar(
                                    context,
                                    auth.errorMessage!,
                                    isError: true,
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ).whenComplete(() {
      currentPwController.dispose();
      newPwController.dispose();
      confirmPwController.dispose();
    });
  }

  // ===========================================================================
  // ABOUT
  // ===========================================================================

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.menu_book_rounded,
                color: AppColors.primary,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  AppConstants.appName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: const SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Version 1.0.0 (Production Build)',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'A modern e-commerce mobile experience powered by Flutter, Laravel REST APIs, and MySQL.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  '© 2026 Online Book Store System. All rights reserved.',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(ctx),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text('My Profile'),
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          final isMobile =
              width < Responsive.mobileBreakpoint;

          final isTablet =
              width >= Responsive.mobileBreakpoint &&
                  width < Responsive.tabletBreakpoint;

          final horizontalPadding =
          isMobile
              ? 16.0
              : isTablet
              ? 24.0
              : 32.0;

          final maxWidth =
          isMobile
              ? double.infinity
              : isTablet
              ? 760.0
              : 900.0;

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxWidth,
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: isMobile ? 16 : 24,
                ),
                child: Column(
                  children: [
                    _buildUserHeader(
                      context,
                      auth,
                      user,
                      isMobile: isMobile,
                      isTablet: isTablet,
                    ),

                    SizedBox(
                      height: isMobile ? 18 : 24,
                    ),

                    _buildOptionsCard(
                      context,
                      auth,
                      isMobile: isMobile,
                    ),

                    SizedBox(
                      height: isMobile ? 24 : 32,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ===========================================================================
  // USER HEADER
  // ===========================================================================

  Widget _buildUserHeader(
      BuildContext context,
      AuthProvider auth,
      dynamic user, {
        required bool isMobile,
        required bool isTablet,
      }) {
    final avatarRadius =
    isMobile
        ? 38.0
        : isTablet
        ? 44.0
        : 48.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
        isMobile ? 18 : 24,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius:
        BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.03,
            ),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: auth.isAuthenticated
          ? _buildLoggedInHeader(
        context,
        user,
        avatarRadius,
        isMobile,
      )
          : _buildGuestHeader(
        context,
        isMobile,
      ),
    );
  }

  // ===========================================================================
  // LOGGED IN HEADER
  // ===========================================================================

  Widget _buildLoggedInHeader(
      BuildContext context,
      dynamic user,
      double avatarRadius,
      bool isMobile,
      ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide =
            constraints.maxWidth >= 600;

        final avatar = CircleAvatar(
          radius: avatarRadius,
          backgroundColor:
          AppColors.primary,
          child: Text(
            user?.name.isNotEmpty == true
                ? user!.name[0].toUpperCase()
                : 'U',
            style: TextStyle(
              fontSize:
              avatarRadius * 0.8,
              fontWeight:
              FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );

        final info = Column(
          crossAxisAlignment: wide
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            Text(
              user?.name ?? 'Reader',
              textAlign: wide
                  ? TextAlign.start
                  : TextAlign.center,
              maxLines: 2,
              overflow:
              TextOverflow.ellipsis,
              style: TextStyle(
                fontSize:
                isMobile ? 18 : 20,
                fontWeight:
                FontWeight.bold,
                color:
                AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              user?.email ?? '',
              textAlign: wide
                  ? TextAlign.start
                  : TextAlign.center,
              maxLines: 2,
              overflow:
              TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                color:
                AppColors.textSecondary,
              ),
            ),

            if (user?.phone != null &&
                user!.phone!.isNotEmpty) ...[
              const SizedBox(height: 3),
              Text(
                user.phone!,
                style: const TextStyle(
                  fontSize: 12,
                  color:
                  AppColors.textMuted,
                ),
              ),
            ],

            if (user?.isAdmin == true) ...[
              const SizedBox(height: 10),
              Container(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color:
                  AppColors.secondaryLight,
                  borderRadius:
                  BorderRadius.circular(12),
                ),
                child: const Text(
                  'ADMINISTRATOR',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight:
                    FontWeight.bold,
                    color:
                    AppColors.secondaryDark,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ],
        );

        if (!wide) {
          return Column(
            children: [
              avatar,
              const SizedBox(height: 14),
              info,
            ],
          );
        }

        return Row(
          children: [
            avatar,
            const SizedBox(width: 22),
            Expanded(child: info),
          ],
        );
      },
    );
  }

  // ===========================================================================
  // GUEST HEADER
  // ===========================================================================

  Widget _buildGuestHeader(
      BuildContext context,
      bool isMobile,
      ) {
    return Column(
      children: [
        CircleAvatar(
          radius: isMobile ? 36 : 42,
          backgroundColor:
          AppColors.surfaceVariant,
          child: Icon(
            Icons.person_outline_rounded,
            size: isMobile ? 40 : 46,
            color: AppColors.textMuted,
          ),
        ),

        const SizedBox(height: 14),

        const Text(
          'Guest Reader',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),

        const SizedBox(height: 5),

        const Text(
          'Sign in to sync your cart, orders & wishlist',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            height: 1.4,
            color: AppColors.textSecondary,
          ),
        ),

        const SizedBox(height: 16),

        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 360,
          ),
          child: SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: 'Sign In / Register',
              height: 44,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) =>
                    const LoginScreen(),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // OPTIONS
  // ===========================================================================

  Widget _buildOptionsCard(
      BuildContext context,
      AuthProvider auth, {
        required bool isMobile,
      }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius:
        BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: [
          if (auth.isAuthenticated) ...[
            _buildOptionTile(
              context,
              icon: Icons.edit_outlined,
              title: 'Edit Profile',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) =>
                    const EditProfileScreen(),
                  ),
                );
              },
            ),

            const Divider(height: 1),

            _buildOptionTile(
              context,
              icon:
              Icons.receipt_long_outlined,
              title: 'My Orders',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) =>
                    const OrdersScreen(),
                  ),
                );
              },
            ),

            const Divider(height: 1),

            _buildOptionTile(
              context,
              icon:
              Icons.favorite_border_rounded,
              title: 'My Wishlist',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) =>
                    const WishlistScreen(),
                  ),
                );
              },
            ),

            const Divider(height: 1),

            _buildOptionTile(
              context,
              icon:
              Icons.lock_outline_rounded,
              title: 'Change Password',
              onTap: () =>
                  _showChangePasswordModal(
                    context,
                  ),
            ),

            const Divider(height: 1),
          ],

          _buildOptionTile(
            context,
            icon:
            Icons.info_outline_rounded,
            title: 'About Bookstore App',
            onTap: () =>
                _showAboutDialog(context),
          ),

          if (auth.isAuthenticated) ...[
            const Divider(height: 1),

            _buildOptionTile(
              context,
              icon:
              Icons.logout_rounded,
              title: 'Sign Out',
              isDestructive: true,
              onTap: () async {
                final confirm =
                await Helpers
                    .showConfirmationDialog(
                  context,
                  title: 'Sign Out',
                  content:
                  'Are you sure you want to sign out from your account?',
                  confirmText: 'Sign Out',
                  isDestructive: true,
                );

                if (confirm == true &&
                    context.mounted) {
                  await auth.logout();

                  if (context.mounted) {
                    Provider.of<CartProvider>(
                      context,
                      listen: false,
                    ).clearCart();

                    Helpers.showSnackBar(
                      context,
                      'Signed out successfully',
                    );
                  }
                }
              },
            ),
          ],
        ],
      ),
    );
  }

  // ===========================================================================
  // OPTION TILE
  // ===========================================================================

  Widget _buildOptionTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
        bool isDestructive = false,
      }) {
    return ListTile(
      contentPadding:
      const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 3,
      ),

      minLeadingWidth: 28,

      leading: Icon(
        icon,
        color: isDestructive
            ? AppColors.error
            : AppColors.primary,
        size: 22,
      ),

      title: Text(
        title,
        maxLines: 1,
        overflow:
        TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 14,
          fontWeight:
          FontWeight.w600,
          color: isDestructive
              ? AppColors.error
              : AppColors.textPrimary,
        ),
      ),

      trailing: isDestructive
          ? null
          : const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 14,
        color: AppColors.textMuted,
      ),

      onTap: onTap,
    );
  }
}