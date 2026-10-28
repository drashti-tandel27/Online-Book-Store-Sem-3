import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../utils/helpers.dart';
import '../../utils/responsive.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;

  @override
  void initState() {
    super.initState();

    final user = Provider.of<AuthProvider>(
      context,
      listen: false,
    ).user;

    _nameController = TextEditingController(
      text: user?.name ?? '',
    );

    _phoneController = TextEditingController(
      text: user?.phone ?? '',
    );

    _addressController = TextEditingController(
      text: user?.address ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // ===========================================================================
  // SAVE
  // ===========================================================================

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final auth = Provider.of<AuthProvider>(
      context,
      listen: false,
    );

    final success = await auth.updateProfile(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      Helpers.showSnackBar(
        context,
        'Profile updated successfully!',
        isSuccess: true,
      );

      Navigator.of(context).pop();
    } else if (auth.errorMessage != null) {
      Helpers.showSnackBar(
        context,
        auth.errorMessage!,
        isError: true,
      );
    }
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text('Edit Profile'),
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
              ? 28.0
              : 32.0;

          final verticalPadding =
          isMobile ? 20.0 : 28.0;

          final maxWidth =
          isMobile
              ? double.infinity
              : isTablet
              ? 650.0
              : 720.0;

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxWidth,
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.stretch,
                    children: [
                      _buildHeader(
                        context,
                        isMobile,
                      ),

                      SizedBox(
                        height: isMobile ? 22 : 28,
                      ),

                      _buildFormCard(
                        context,
                        auth,
                        isMobile: isMobile,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ===========================================================================
  // HEADER
  // ===========================================================================

  Widget _buildHeader(
      BuildContext context,
      bool isMobile,
      ) {
    return Column(
      children: [
        Container(
          width: isMobile ? 70 : 78,
          height: isMobile ? 70 : 78,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(
              alpha: 0.08,
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.person_outline_rounded,
            size: isMobile ? 36 : 40,
            color: AppColors.primary,
          ),
        ),

        const SizedBox(height: 12),

        Text(
          'Update your profile',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isMobile ? 19 : 21,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),

        const SizedBox(height: 5),

        const Text(
          'Keep your contact and delivery details up to date.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            height: 1.4,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // FORM CARD
  // ===========================================================================

  Widget _buildFormCard(
      BuildContext context,
      AuthProvider auth, {
        required bool isMobile,
      }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
        isMobile ? 18 : 24,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.03,
            ),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.stretch,
        children: [
          // -------------------------------------------------------------------
          // NAME
          // -------------------------------------------------------------------

          CustomTextField(
            controller: _nameController,
            label: 'Full Name',
            hint: 'Your full name',
            prefixIcon:
            Icons.person_outline_rounded,
            validator: Validators.name,
          ),

          const SizedBox(height: 16),

          // -------------------------------------------------------------------
          // PHONE
          // -------------------------------------------------------------------

          CustomTextField(
            controller: _phoneController,
            label: 'Phone Number',
            hint: 'Contact number',
            prefixIcon:
            Icons.phone_outlined,
            keyboardType:
            TextInputType.phone,
            validator: Validators.phone,
          ),

          const SizedBox(height: 16),

          // -------------------------------------------------------------------
          // ADDRESS
          // -------------------------------------------------------------------

          CustomTextField(
            controller: _addressController,
            label: 'Default Delivery Address',
            hint:
            'Your street address and postal code',
            prefixIcon:
            Icons.location_on_outlined,
            maxLines: 4,
            validator: Validators.address,
          ),

          const SizedBox(height: 28),

          // -------------------------------------------------------------------
          // SAVE
          // -------------------------------------------------------------------

          Align(
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isMobile
                    ? double.infinity
                    : 420,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: CustomButton(
                  text: 'Save Changes',
                  isLoading: auth.isLoading,
                  onPressed: _saveProfile,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}