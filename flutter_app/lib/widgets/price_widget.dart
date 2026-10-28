import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../utils/helpers.dart';

class PriceWidget extends StatelessWidget {
  final double price;
  final double? discountPrice;
  final double fontSize;
  final bool showDiscountBadge;

  const PriceWidget({
    super.key,
    required this.price,
    this.discountPrice,
    this.fontSize = 16,
    this.showDiscountBadge = false,
  });

  bool get hasDiscount => discountPrice != null && discountPrice! > 0 && discountPrice! < price;

  @override
  Widget build(BuildContext context) {
    if (hasDiscount) {
      final discountPercent = (((price - discountPrice!) / price) * 100).round();

      return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 6,
        children: [
          Text(
            Helpers.formatPrice(discountPrice),
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          Text(
            Helpers.formatPrice(price),
            style: TextStyle(
              fontSize: fontSize * 0.8,
              fontWeight: FontWeight.w500,
              color: AppColors.textMuted,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          if (showDiscountBadge)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.errorBg,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '-$discountPercent%',
                style: TextStyle(
                  fontSize: fontSize * 0.65,
                  fontWeight: FontWeight.bold,
                  color: AppColors.error,
                ),
              ),
            ),
        ],
      );
    }

    return Text(
      Helpers.formatPrice(price),
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }
}
