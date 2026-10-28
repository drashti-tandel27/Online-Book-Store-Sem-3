import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../utils/helpers.dart';
import '../../utils/responsive.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../main_nav_screen.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ===========================================================================
  // LOGIN
  // ===========================================================================

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = Provider.of<AuthProvider>(
      context,
      listen: false,
    );

    final success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      if (authProvider.user?.isAdmin == true) {
        Helpers.showSnackBar(
          context,
          'Admin account detected. For full management, please use the Web Admin Panel.',
          isSuccess: true,
        );
      } else {
        Helpers.showSnackBar(
          context,
          'Welcome back, ${authProvider.user?.name ?? 'Reader'}!',
          isSuccess: true,
        );
      }

      // Preload cart and wishlist.
      Provider.of<CartProvider>(
        context,
        listen: false,
      ).fetchCart();

      Provider.of<WishlistProvider>(
        context,
        listen: false,
      ).fetchWishlist();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (ctx) => const MainNavScreen(),
        ),
            (route) => false,
      );
    } else if (authProvider.errorMessage != null) {
      Helpers.showSnackBar(
        context,
        authProvider.errorMessage!,
        isError: true,
      );
    }
  }

  // ===========================================================================
  // NAVIGATION
  // ===========================================================================

  void _openForgotPassword() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const ForgotPasswordScreen(),
      ),
    );
  }

  void _openRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const RegisterScreen(),
      ),
    );
  }

  void _continueAsGuest() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => const MainNavScreen(),
      ),
    );
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            final isMobile =
                width < Responsive.mobileBreakpoint;

            final isTablet =
                width >= Responsive.mobileBreakpoint &&
                    width < Responsive.tabletBreakpoint;

            final horizontalPadding = isMobile
                ? 20.0
                : isTablet
                ? 32.0
                : 40.0;

            final verticalPadding = isMobile
                ? 24.0
                : 32.0;

            final cardPadding = isMobile
                ? 0.0
                : isTablet
                ? 32.0
                : 40.0;

            return Center(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 500,
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(cardPadding),
                    decoration: isMobile
                        ? null
                        : BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius:
                      BorderRadius.circular(24),
                      border: Border.all(
                        color: AppColors.border,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: 0.04,
                          ),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          _buildLogo(isMobile),

                          SizedBox(
                            height: isMobile ? 24 : 28,
                          ),

                          _buildHeader(isMobile),

                          SizedBox(
                            height: isMobile ? 28 : 34,
                          ),

                          _buildEmailField(),

                          const SizedBox(height: 18),

                          _buildPasswordField(),

                          const SizedBox(height: 4),

                          _buildForgotPassword(),

                          const SizedBox(height: 20),

                          _buildLoginButton(authProvider),

                          const SizedBox(height: 24),

                          _buildRegisterPrompt(),

                          const SizedBox(height: 12),

                          _buildGuestButton(),
                        ],
                      ),
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

  Widget _buildLogo(bool isMobile) {
    final size = isMobile ? 68.0 : 76.0;
    final iconSize = isMobile ? 35.0 : 40.0;

    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(
            isMobile ? 19 : 21,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(
                alpha: 0.25,
              ),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Icon(
          Icons.menu_book_rounded,
          color: Colors.white,
          size: iconSize,
        ),
      ),
    );
  }

  // ===========================================================================
  // HEADER
  // ===========================================================================

  Widget _buildHeader(bool isMobile) {
    return Column(
      children: [
        const Center(
          child: Text(
            'Welcome Back!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
        ),

        const SizedBox(height: 7),

        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
          ),
          child: Text(
            'Sign in to access your saved books and orders',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 13 : 14,
              height: 1.4,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // EMAIL FIELD
  // ===========================================================================

  Widget _buildEmailField() {
    return CustomTextField(
      controller: _emailController,
      label: 'Email Address',
      hint: 'Enter your email (e.g. user@example.com)',
      prefixIcon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: Validators.email,
    );
  }

  // ===========================================================================
  // PASSWORD FIELD
  // ===========================================================================

  Widget _buildPasswordField() {
    return CustomTextField(
      controller: _passwordController,
      label: 'Password',
      hint: 'Enter your password',
      prefixIcon: Icons.lock_outline_rounded,
      isPassword: true,
      textInputAction: TextInputAction.done,
      validator: Validators.password,
    );
  }

  // ===========================================================================
  // FORGOT PASSWORD
  // ===========================================================================

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: _openForgotPassword,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 8,
          ),
          minimumSize: Size.zero,
          tapTargetSize:
          MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text(
          'Forgot Password?',
        ),
      ),
    );
  }

  // ===========================================================================
  // LOGIN BUTTON
  // ===========================================================================

  Widget _buildLoginButton(
      AuthProvider authProvider,
      ) {
    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        text: 'Sign In',
        isLoading: authProvider.isLoading,
        onPressed: _handleLogin,
      ),
    );
  }

  // ===========================================================================
  // REGISTER PROMPT
  // ===========================================================================

  Widget _buildRegisterPrompt() {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment:
        WrapCrossAlignment.center,
        spacing: 4,
        runSpacing: 2,
        children: [
          const Text(
            "Don't have an account?",
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          GestureDetector(
            onTap: _openRegister,
            child: const Text(
              'Register',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // GUEST
  // ===========================================================================

  Widget _buildGuestButton() {
    return Center(
      child: TextButton(
        onPressed: _continueAsGuest,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
        ),
        child: const Text(
          'Browse as Guest',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}