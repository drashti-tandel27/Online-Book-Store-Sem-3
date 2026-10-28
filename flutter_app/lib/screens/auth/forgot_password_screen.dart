import 'package:flutter/material.dart';

import '../../config/app_colors.dart';
import '../../utils/helpers.dart';
import '../../utils/responsive.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _isLoading = false;
  bool _submitted = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // ===========================================================================
  // SUBMIT
  // ===========================================================================

  Future<void> _handleSubmit() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Existing reset-link simulation.
    await Future.delayed(
      const Duration(milliseconds: 1000),
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _submitted = true;
    });

    Helpers.showSnackBar(
      context,
      'Password reset instructions sent to ${_emailController.text.trim()}',
      isSuccess: true,
    );
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),

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

            final horizontalPadding =
            isMobile
                ? 20.0
                : isTablet
                ? 32.0
                : 40.0;

            final verticalPadding =
            isMobile ? 20.0 : 32.0;

            final cardPadding =
            isMobile
                ? 0.0
                : isTablet
                ? 32.0
                : 40.0;

            return Center(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior
                    .onDrag,

                padding: EdgeInsets.symmetric(
                  horizontal:
                  horizontalPadding,
                  vertical:
                  verticalPadding,
                ),

                child: ConstrainedBox(
                  constraints:
                  const BoxConstraints(
                    maxWidth: 520,
                  ),

                  child: Container(
                    width: double.infinity,

                    padding: EdgeInsets.all(
                      cardPadding,
                    ),

                    decoration: isMobile
                        ? null
                        : BoxDecoration(
                      color:
                      AppColors.cardBg,
                      borderRadius:
                      BorderRadius.circular(
                        24,
                      ),
                      border: Border.all(
                        color:
                        AppColors.border,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors
                              .black
                              .withValues(
                            alpha: 0.04,
                          ),
                          blurRadius: 24,
                          offset:
                          const Offset(
                            0,
                            10,
                          ),
                        ),
                      ],
                    ),

                    child: AnimatedSwitcher(
                      duration:
                      const Duration(
                        milliseconds: 250,
                      ),
                      child: _submitted
                          ? _buildSuccessState(
                        isMobile,
                      )
                          : _buildFormState(
                        isMobile,
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
  // FORM
  // ===========================================================================

  Widget _buildFormState(
      bool isMobile,
      ) {
    return Form(
      key: _formKey,

      child: Column(
        key: const ValueKey('forgot-form'),
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          _buildIconHeader(
            isMobile,
          ),

          const SizedBox(height: 20),

          Text(
            'Reset your password',
            style: TextStyle(
              fontSize:
              isMobile ? 22 : 24,
              fontWeight:
              FontWeight.bold,
              color:
              AppColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Enter your registered email address and we will send you instructions to reset your password.',
            style: TextStyle(
              fontSize: 14,
              height: 1.45,
              color:
              AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 28),

          CustomTextField(
            controller:
            _emailController,
            label: 'Email Address',
            hint:
            'Enter your registered email',
            prefixIcon:
            Icons.email_outlined,
            keyboardType:
            TextInputType.emailAddress,
            textInputAction:
            TextInputAction.done,
            validator:
            Validators.email,
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: 'Send Reset Link',
              isLoading: _isLoading,
              onPressed:
              _handleSubmit,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // HEADER ICON
  // ===========================================================================

  Widget _buildIconHeader(
      bool isMobile,
      ) {
    return Container(
      padding: EdgeInsets.all(
        isMobile ? 14 : 16,
      ),

      decoration: BoxDecoration(
        color: AppColors.primary
            .withValues(alpha: 0.10),
        borderRadius:
        BorderRadius.circular(16),
      ),

      child: Icon(
        Icons.lock_reset_rounded,
        size: isMobile ? 34 : 38,
        color: AppColors.primary,
      ),
    );
  }

  // ===========================================================================
  // SUCCESS
  // ===========================================================================

  Widget _buildSuccessState(
      bool isMobile,
      ) {
    return Center(
      key: const ValueKey('success-state'),

      child: Column(
        mainAxisSize:
        MainAxisSize.min,
        crossAxisAlignment:
        CrossAxisAlignment.center,

        children: [
          Container(
            padding: EdgeInsets.all(
              isMobile ? 18 : 20,
            ),

            decoration:
            const BoxDecoration(
              color:
              AppColors.successBg,
              shape: BoxShape.circle,
            ),

            child: Icon(
              Icons.mark_email_read_rounded,
              size: isMobile ? 46 : 52,
              color:
              AppColors.success,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'Check Your Email',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize:
              isMobile ? 20 : 22,
              fontWeight:
              FontWeight.bold,
              color:
              AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'We sent a password reset link to ${_emailController.text.trim()}',
            textAlign:
            TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              height: 1.45,
              color:
              AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 28),

          ConstrainedBox(
            constraints:
            const BoxConstraints(
              maxWidth: 360,
            ),

            child: SizedBox(
              width: double.infinity,

              child: CustomButton(
                text: 'Back to Login',
                onPressed: () =>
                    Navigator.of(context)
                        .pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}