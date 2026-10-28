import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../utils/responsive.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ============================================================
  // REGISTER
  // ============================================================

  Future<void> _handleRegister() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider =
    Provider.of<AuthProvider>(context, listen: false);

    final success = await authProvider.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      password: _passwordController.text,
      passwordConfirmation: _confirmPasswordController.text,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully'),
          backgroundColor: AppColors.success,
        ),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authProvider.errorMessage ??
                'Registration failed. Please try again.',
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        title: const Text(
          'Create Account',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            final isMobile =
                width < Responsive.mobileBreakpoint;

            final isTablet =
                width >= Responsive.mobileBreakpoint &&
                    width < Responsive.tabletBreakpoint;

            final isDesktop =
                width >= Responsive.tabletBreakpoint;

            final horizontalPadding = isMobile
                ? 16.0
                : isTablet
                ? 28.0
                : 32.0;

            final topPadding = isMobile
                ? 16.0
                : isTablet
                ? 28.0
                : 32.0;

            final maxFormWidth = isMobile
                ? double.infinity
                : isTablet
                ? 560.0
                : 600.0;

            return SingleChildScrollView(
              keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag,
              physics:
              const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                topPadding,
                horizontalPadding,
                32,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: maxFormWidth,
                  ),
                  child: Container(
                    width: double.infinity,

                    padding: EdgeInsets.all(
                      isMobile ? 0 : 32,
                    ),

                    decoration: BoxDecoration(
                      color: isMobile
                          ? Colors.transparent
                          : AppColors.surface,

                      borderRadius:
                      BorderRadius.circular(20),

                      border: isMobile
                          ? null
                          : Border.all(
                        color: AppColors.border,
                      ),

                      boxShadow: isMobile
                          ? null
                          : [
                        BoxShadow(
                          color: Colors.black
                              .withValues(alpha: 0.05),
                          blurRadius: 20,
                          offset:
                          const Offset(0, 6),
                        ),
                      ],
                    ),

                    child: Form(
                      key: _formKey,

                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          // ==================================================
                          // HEADER
                          // ==================================================

                          Center(
                            child: Column(
                              children: [
                                Container(
                                  width:
                                  isMobile ? 64 : 72,
                                  height:
                                  isMobile ? 64 : 72,
                                  decoration:
                                  BoxDecoration(
                                    color: AppColors.primary
                                        .withValues(
                                      alpha: 0.10,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons
                                        .person_add_alt_1_rounded,
                                    size:
                                    isMobile ? 30 : 34,
                                    color:
                                    AppColors.primary,
                                  ),
                                ),

                                const SizedBox(height: 14),

                                Text(
                                  'Join BookStore',
                                  textAlign:
                                  TextAlign.center,
                                  style: TextStyle(
                                    fontSize:
                                    isDesktop
                                        ? 24
                                        : 22,
                                    fontWeight:
                                    FontWeight.bold,
                                    color: AppColors
                                        .textPrimary,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                const Text(
                                  'Create your account to continue',
                                  textAlign:
                                  TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors
                                        .textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 28),

                          // ==================================================
                          // FULL NAME
                          // ==================================================

                          CustomTextField(
                            controller:
                            _nameController,
                            label: 'Full Name',
                            hint:
                            'Enter your full name',
                            prefixIcon:
                            Icons
                                .person_outline_rounded,
                            textInputAction:
                            TextInputAction.next,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty) {
                                return 'Please enter your full name';
                              }

                              if (value.trim().length <
                                  2) {
                                return 'Name must be at least 2 characters';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 18),

                          // ==================================================
                          // EMAIL
                          // ==================================================

                          CustomTextField(
                            controller:
                            _emailController,
                            label: 'Email Address',
                            hint:
                            'Enter your email address',
                            prefixIcon:
                            Icons.email_outlined,
                            keyboardType:
                            TextInputType.emailAddress,
                            textInputAction:
                            TextInputAction.next,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty) {
                                return 'Please enter your email address';
                              }

                              final emailRegex =
                              RegExp(
                                r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                              );

                              if (!emailRegex.hasMatch(
                                value.trim(),
                              )) {
                                return 'Please enter a valid email address';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 18),

                          // ==================================================
                          // PHONE
                          // ==================================================

                          CustomTextField(
                            controller:
                            _phoneController,
                            label: 'Phone Number',
                            hint:
                            'e.g. +1 555 123 4567',
                            prefixIcon:
                            Icons.phone_outlined,
                            keyboardType:
                            TextInputType.phone,
                            textInputAction:
                            TextInputAction.next,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty) {
                                return 'Please enter your phone number';
                              }

                              final phone =
                              value.trim();

                              if (phone.length < 7) {
                                return 'Please enter a valid phone number';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 18),

                          // ==================================================
                          // DELIVERY ADDRESS
                          // ==================================================

                          CustomTextField(
                            controller:
                            _addressController,
                            label: 'Delivery Address',
                            hint:
                            'Enter your delivery address',
                            prefixIcon:
                            Icons
                                .location_on_outlined,

                            // IMPORTANT:
                            // Multiline address field.
                            maxLines: 3,

                            // IMPORTANT:
                            // Do NOT use TextInputAction.newline
                            // with this CustomTextField setup.
                            textInputAction:
                            TextInputAction.done,

                            keyboardType:
                            TextInputType.multiline,

                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty) {
                                return 'Please enter your delivery address';
                              }

                              if (value.trim().length <
                                  10) {
                                return 'Please enter a valid address';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 18),

                          // ==================================================
                          // PASSWORD
                          // ==================================================

                          CustomTextField(
                            controller:
                            _passwordController,
                            label: 'Password',
                            hint:
                            'Enter your password',
                            prefixIcon:
                            Icons
                                .lock_outline_rounded,
                            isPassword: true,
                            textInputAction:
                            TextInputAction.next,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty) {
                                return 'Please enter your password';
                              }

                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 18),

                          // ==================================================
                          // CONFIRM PASSWORD
                          // ==================================================

                          CustomTextField(
                            controller:
                            _confirmPasswordController,
                            label: 'Confirm Password',
                            hint:
                            'Re-enter your password',
                            prefixIcon:
                            Icons
                                .lock_outline_rounded,
                            isPassword: true,
                            textInputAction:
                            TextInputAction.done,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty) {
                                return 'Please confirm your password';
                              }

                              if (value !=
                                  _passwordController
                                      .text) {
                                return 'Passwords do not match';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 26),

                          // ==================================================
                          // CREATE ACCOUNT
                          // ==================================================

                          Center(
                            child: ConstrainedBox(
                              constraints:
                              const BoxConstraints(
                                maxWidth: 500,
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                child: CustomButton(
                                  text:
                                  'Create Account',
                                  isLoading:
                                  authProvider
                                      .isLoading,
                                  onPressed:
                                  authProvider
                                      .isLoading
                                      ? null
                                      : _handleRegister,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 22),

                          // ==================================================
                          // LOGIN
                          // ==================================================

                          Center(
                            child: Wrap(
                              alignment:
                              WrapAlignment.center,
                              crossAxisAlignment:
                              WrapCrossAlignment.center,
                              children: [
                                const Text(
                                  'Already have an account? ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors
                                        .textSecondary,
                                  ),
                                ),

                                TextButton(
                                  onPressed: () {
                                    Navigator.of(
                                      context,
                                    ).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                        const LoginScreen(),
                                      ),
                                    );
                                  },
                                  style:
                                  TextButton.styleFrom(
                                    padding:
                                    const EdgeInsets
                                        .symmetric(
                                      horizontal: 4,
                                      vertical: 4,
                                    ),
                                    minimumSize:
                                    Size.zero,
                                    tapTargetSize:
                                    MaterialTapTargetSize
                                        .shrinkWrap,
                                  ),
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight:
                                      FontWeight.w700,
                                      color: AppColors
                                          .primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 8),
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
}