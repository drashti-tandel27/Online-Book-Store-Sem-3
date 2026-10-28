import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../models/order.dart';
import '../../utils/helpers.dart';
import '../../utils/responsive.dart';
import '../../widgets/custom_button.dart';
import '../main_nav_screen.dart';
import 'order_details_screen.dart';
import 'orders_screen.dart';

class OrderSuccessScreen extends StatelessWidget {
  final Order order;

  const OrderSuccessScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ResponsiveContainer(
            maxWidth: 550,
            padding: EdgeInsets.zero,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success Badge
                Container(
                  width: 90,
                  height: 90,
                  decoration: const BoxDecoration(
                    color: AppColors.successBg,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check_rounded,
                      color: AppColors.success,
                      size: 54,
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Confirmation Heading
                const Text(
                  'Order Placed Successfully!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Thank you for your order. We are preparing your books for dispatch.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Order Summary Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Order Number', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                          Text(
                            order.orderNumber,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Payment Method', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                          Text(
                            order.paymentMethod,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Amount', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                          Text(
                            Helpers.formatPrice(order.totalAmount),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36),

                // Action Buttons
                CustomButton(
                  text: 'Track Order Details',
                  icon: Icons.local_shipping_outlined,
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (ctx) => OrderDetailsScreen(orderId: order.id),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                CustomButton(
                  text: 'View All Orders',
                  isOutlined: true,
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (ctx) => const OrdersScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (ctx) => const MainNavScreen()),
                      (route) => false,
                    );
                  },
                  child: const Text('Continue Shopping'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
}
