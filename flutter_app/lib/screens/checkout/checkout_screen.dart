import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../utils/helpers.dart';
import '../../utils/responsive.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../orders/order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  final TextEditingController _notesController =
  TextEditingController();

  String _selectedPaymentMethod = 'Cash on Delivery';

  @override
  void initState() {
    super.initState();

    final auth =
    Provider.of<AuthProvider>(context, listen: false);

    _nameController =
        TextEditingController(text: auth.user?.name ?? '');
    _phoneController =
        TextEditingController(text: auth.user?.phone ?? '');
    _addressController =
        TextEditingController(text: auth.user?.address ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // =============================================================
  // PLACE ORDER
  // =============================================================

  Future<void> _handlePlaceOrder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final cartProvider =
    Provider.of<CartProvider>(context, listen: false);

    if (cartProvider.isEmpty) {
      Helpers.showSnackBar(
        context,
        'Your cart is empty',
        isError: true,
      );
      return;
    }

    final orderProvider =
    Provider.of<OrderProvider>(context, listen: false);

    final itemsPayload = cartProvider.items.map((item) {
      return {
        'book_id': item.bookId,
        'quantity': item.quantity,
        'price': item.price,
      };
    }).toList();

    final order = await orderProvider.placeOrder(
      shippingAddress: _addressController.text,
      paymentMethod: _selectedPaymentMethod,
      recipientName: _nameController.text,
      recipientPhone: _phoneController.text,
      notes: _notesController.text,
      items: itemsPayload,
    );

    if (!mounted) {
      return;
    }

    if (order != null) {
      await cartProvider.clearCart();

      if (!mounted) {
        return;
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => OrderSuccessScreen(order: order),
        ),
      );
    } else if (orderProvider.errorMessage != null) {
      Helpers.showSnackBar(
        context,
        orderProvider.errorMessage!,
        isError: true,
      );
    }
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final orderProvider = context.watch<OrderProvider>();

    final isMobile = Responsive.isMobile(context);
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              isMobile ? 16 : 24,
              20,
              isMobile ? 16 : 24,
              32,
            ),
            child: ResponsiveContainer(
              maxWidth: 1250,
              child: isDesktop
                  ? _buildDesktopLayout(
                context,
                cartProvider,
                orderProvider,
              )
                  : _buildMobileTabletLayout(
                context,
                cartProvider,
                orderProvider,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =============================================================
  // MOBILE + TABLET
  // =============================================================

  Widget _buildMobileTabletLayout(
      BuildContext context,
      CartProvider cartProvider,
      OrderProvider orderProvider,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildShippingSection(context),
        const SizedBox(height: 20),
        _buildPaymentSection(context),
        const SizedBox(height: 20),
        _buildOrderSummary(cartProvider),
        const SizedBox(height: 28),
        _buildPlaceOrderButton(
          cartProvider,
          orderProvider,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // =============================================================
  // DESKTOP
  // =============================================================

  Widget _buildDesktopLayout(
      BuildContext context,
      CartProvider cartProvider,
      OrderProvider orderProvider,
      ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // -------------------------------------------------------
        // LEFT: SHIPPING + PAYMENT
        // -------------------------------------------------------
        Expanded(
          flex: 6,
          child: Column(
            children: [
              _buildShippingSection(context),
              const SizedBox(height: 20),
              _buildPaymentSection(context),
            ],
          ),
        ),

        const SizedBox(width: 24),

        // -------------------------------------------------------
        // RIGHT: SUMMARY + ORDER
        // -------------------------------------------------------
        Expanded(
          flex: 4,
          child: Column(
            children: [
              _buildOrderSummary(cartProvider),
              const SizedBox(height: 20),
              _buildPlaceOrderButton(
                cartProvider,
                orderProvider,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =============================================================
  // SHIPPING
  // =============================================================

  Widget _buildShippingSection(BuildContext context) {
    return _buildSectionCard(
      title: 'Shipping Details',
      icon: Icons.local_shipping_outlined,
      child: Column(
        children: [
          CustomTextField(
            controller: _nameController,
            label: 'Recipient Name',
            hint: 'Full Name',
            prefixIcon: Icons.person_outline_rounded,
            validator: Validators.name,
          ),
          const SizedBox(height: 14),

          CustomTextField(
            controller: _phoneController,
            label: 'Contact Phone',
            hint: 'Phone number for delivery updates',
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: Validators.phone,
          ),
          const SizedBox(height: 14),

          CustomTextField(
            controller: _addressController,
            label: 'Delivery Address',
            hint:
            'Street Address, Apartment, City, Postal Code',
            prefixIcon: Icons.location_on_outlined,
            maxLines: 2,
            validator: Validators.address,
          ),
          const SizedBox(height: 14),

          CustomTextField(
            controller: _notesController,
            label: 'Delivery Instructions (Optional)',
            hint: 'e.g. Leave package at front door',
            prefixIcon: Icons.note_outlined,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  // =============================================================
  // PAYMENT
  // =============================================================

  Widget _buildPaymentSection(BuildContext context) {
    return _buildSectionCard(
      title: 'Payment Method',
      icon: Icons.payment_outlined,
      child: Column(
        children: [
          _buildPaymentOption(
            title: 'Cash on Delivery',
            subtitle:
            'Pay with cash upon receiving your books',
            icon: Icons.money_rounded,
            value: 'Cash on Delivery',
          ),

          const Divider(height: 16),

          _buildPaymentOption(
            title: 'Credit / Debit Card',
            subtitle:
            'Visa, Mastercard, RuPay (Simulated)',
            icon: Icons.credit_card_rounded,
            value: 'Credit / Debit Card',
          ),

          const Divider(height: 16),

          _buildPaymentOption(
            title: 'UPI / NetBanking',
            subtitle:
            'Instant secure bank transfer (Simulated)',
            icon: Icons.account_balance_rounded,
            value: 'UPI / NetBanking',
          ),
        ],
      ),
    );
  }

  // =============================================================
  // ORDER SUMMARY
  // =============================================================

  Widget _buildOrderSummary(
      CartProvider cartProvider,
      ) {
    return _buildSectionCard(
      title:
      'Order Summary (${cartProvider.itemCount} items)',
      icon: Icons.receipt_long_outlined,
      child: Column(
        children: [
          ...cartProvider.items.map(
                (item) {
              return Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        '${item.quantity}x  ${item.book?.title ?? "Book #${item.bookId}"}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      Helpers.formatPrice(item.subtotal),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const Divider(height: 20),

          _buildSummaryRow(
            'Subtotal',
            Helpers.formatPrice(
              cartProvider.subtotal,
            ),
          ),

          const SizedBox(height: 7),

          _buildSummaryRow(
            'Shipping Fee',
            cartProvider.shippingFee == 0
                ? 'FREE'
                : Helpers.formatPrice(
              cartProvider.shippingFee,
            ),
            valueColor: cartProvider.shippingFee == 0
                ? AppColors.success
                : AppColors.textPrimary,
          ),

          const SizedBox(height: 7),

          _buildSummaryRow(
            'Estimated Tax (5%)',
            Helpers.formatPrice(
              cartProvider.tax,
            ),
          ),

          const Divider(height: 20),

          Row(
            children: [
              const Expanded(
                child: Text(
                  'Total to Pay',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                Helpers.formatPrice(
                  cartProvider.totalAmount,
                ),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
      String label,
      String value, {
        Color? valueColor,
      }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color:
            valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  // =============================================================
  // PLACE ORDER
  // =============================================================

  Widget _buildPlaceOrderButton(
      CartProvider cartProvider,
      OrderProvider orderProvider,
      ) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 600,
      ),
      child: SizedBox(
        width: double.infinity,
        child: CustomButton(
          text:
          'Place Order • ${Helpers.formatPrice(cartProvider.totalAmount)}',
          icon: Icons.check_circle_outline_rounded,
          isLoading: orderProvider.isPlacingOrder,
          onPressed: _handlePlaceOrder,
        ),
      ),
    );
  }

  // =============================================================
  // SECTION CARD
  // =============================================================

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  // =============================================================
  // PAYMENT OPTION
  // =============================================================

  Widget _buildPaymentOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required String value,
  }) {
    final isSelected =
        _selectedPaymentMethod == value;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding:
        const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    .withValues(alpha: 0.1)
                    : AppColors.surfaceVariant,
                borderRadius:
                BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? AppColors.primary
                    : AppColors.textSecondary,
                size: 22,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color:
                      AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow:
                    TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color:
                      AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textMuted,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                child: Container(
                  width: 12,
                  height: 12,
                  decoration:
                  const BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                    AppColors.primary,
                  ),
                ),
              )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}