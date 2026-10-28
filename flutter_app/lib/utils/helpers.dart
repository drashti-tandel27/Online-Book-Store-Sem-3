import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/app_colors.dart';

class Helpers {
  static String formatPrice(num? price) {
    if (price == null) return '₹0.00';

    const double usdToInr = 84.0;
    final double inrPrice = price.toDouble() * usdToInr;

    return '₹${inrPrice.toStringAsFixed(2)}';
  }

  static String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    try {
      final DateTime dt = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(dt);
    } catch (_) {
      return dateString;
    }
  }

  static String formatDateTime(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    try {
      final DateTime dt = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy • hh:mm a').format(dt);
    } catch (_) {
      return dateString;
    }
  }

  static void showSnackBar(BuildContext context, String message, {bool isError = false, bool isSuccess = false}) {
    Color bgColor = AppColors.textPrimary;
    IconData icon = Icons.info_outline;

    if (isError) {
      bgColor = AppColors.error;
      icon = Icons.error_outline;
    } else if (isSuccess) {
      bgColor = AppColors.success;
      icon = Icons.check_circle_outline;
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: bgColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static Future<bool?> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String content,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        content: Text(content, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(cancelText, style: const TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isDestructive ? AppColors.error : AppColors.primary,
              minimumSize: const Size(80, 40),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }
}

class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({this.delay = const Duration(milliseconds: 400)});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
