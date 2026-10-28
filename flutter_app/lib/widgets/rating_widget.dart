import 'package:flutter/material.dart';
import '../config/app_colors.dart';

class RatingWidget extends StatelessWidget {
  final double rating;
  final int? reviewsCount;
  final double iconSize;
  final bool showScore;
  final bool compact;

  const RatingWidget({
    super.key,
    required this.rating,
    this.reviewsCount,
    this.iconSize = 14,
    this.showScore = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.secondary.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star_rounded, size: iconSize, color: AppColors.secondaryDark),
            const SizedBox(width: 4),
            Text(
              rating.toStringAsFixed(1),
              style: TextStyle(
                fontSize: iconSize * 0.85,
                fontWeight: FontWeight.bold,
                color: AppColors.secondaryDark,
              ),
            ),
          ],
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            final starValue = index + 1;
            if (rating >= starValue) {
              return Icon(Icons.star_rounded, size: iconSize, color: AppColors.secondary);
            } else if (rating > index && rating < starValue) {
              return Icon(Icons.star_half_rounded, size: iconSize, color: AppColors.secondary);
            } else {
              return Icon(Icons.star_outline_rounded, size: iconSize, color: AppColors.textMuted);
            }
          }),
        ),
        if (showScore) ...[
          const SizedBox(width: 6),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
        if (reviewsCount != null && reviewsCount! > 0) ...[
          const SizedBox(width: 4),
          Text(
            '($reviewsCount)',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

class InteractiveRatingBar extends StatelessWidget {
  final double rating;
  final ValueChanged<double> onRatingChanged;
  final double size;

  const InteractiveRatingBar({
    super.key,
    required this.rating,
    required this.onRatingChanged,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        return IconButton(
          iconSize: size,
          padding: const EdgeInsets.symmetric(horizontal: 2),
          constraints: const BoxConstraints(),
          icon: Icon(
            rating >= starValue ? Icons.star_rounded : Icons.star_outline_rounded,
            color: rating >= starValue ? AppColors.secondary : AppColors.textMuted,
          ),
          onPressed: () => onRatingChanged(starValue.toDouble()),
        );
      }),
    );
  }
}
