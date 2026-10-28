import 'package:flutter/material.dart';
import '../config/app_colors.dart';

class OrderStatusBadge extends StatelessWidget {
  final String status;
  final double fontSize;

  const OrderStatusBadge({
    super.key,
    required this.status,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.getStatusColor(status);
    final bgColor = AppColors.getStatusBgColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class OrderProgressStepper extends StatelessWidget {
  final String currentStatus;

  const OrderProgressStepper({super.key, required this.currentStatus});

  static const List<String> steps = [
    'Pending',
    'Confirmed',
    'Processing',
    'Shipped',
    'Delivered',
  ];

  int get currentStepIndex {
    switch (currentStatus.toLowerCase()) {
      case 'pending':
        return 0;
      case 'confirmed':
        return 1;
      case 'processing':
        return 2;
      case 'shipped':
        return 3;
      case 'delivered':
        return 4;
      case 'cancelled':
        return -1;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentStatus.toLowerCase() == 'cancelled') {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.errorBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          children: [
            Icon(Icons.cancel_outlined, color: AppColors.error, size: 24),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'This order has been cancelled.',
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final currentIndex = currentStepIndex;

    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isCompleted = index <= currentIndex;
        final isCurrent = index == currentIndex;
        final isLast = index == steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isCompleted ? AppColors.primary : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isCompleted ? AppColors.primary : AppColors.border,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : Text(
                            '${index + 1}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textMuted,
                            ),
                          ),
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 32,
                    color: index < currentIndex ? AppColors.primary : AppColors.border,
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
                        color: isCompleted ? AppColors.textPrimary : AppColors.textMuted,
                      ),
                    ),
                    if (isCurrent) ...[
                      const SizedBox(height: 2),
                      const Text(
                        'In progress',
                        style: TextStyle(fontSize: 12, color: AppColors.primaryLight),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
