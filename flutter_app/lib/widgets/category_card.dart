import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../models/category.dart';
import '../screens/books/books_screen.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.category,
    this.isSelected = false,
    this.onTap,
  });

  IconData _getCategoryIcon(String name) {
    final lower = name.toLowerCase();

    if (lower.contains('fiction')) {
      return Icons.auto_stories_rounded;
    }
    if (lower.contains('tech') || lower.contains('computer')) {
      return Icons.computer_rounded;
    }
    if (lower.contains('science')) {
      return Icons.science_rounded;
    }
    if (lower.contains('history')) {
      return Icons.history_edu_rounded;
    }
    if (lower.contains('business') || lower.contains('finance')) {
      return Icons.trending_up_rounded;
    }
    if (lower.contains('biography') || lower.contains('memoir')) {
      return Icons.person_rounded;
    }
    if (lower.contains('art') || lower.contains('design')) {
      return Icons.palette_rounded;
    }
    if (lower.contains('mystery') || lower.contains('thriller')) {
      return Icons.psychology_rounded;
    }
    if (lower.contains('romance')) {
      return Icons.favorite_rounded;
    }
    if (lower.contains('kid') || lower.contains('children')) {
      return Icons.child_care_rounded;
    }

    return Icons.menu_book_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap ??
                  () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => BooksScreen(
                      initialCategoryId: category.id,
                      categoryName: category.name,
                    ),
                  ),
                );
              },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Category Icon
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.2)
                        : AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getCategoryIcon(category.name),
                    color: isSelected
                        ? Colors.white
                        : AppColors.primary,
                    size: 20,
                  ),
                ),

                const SizedBox(width: 10),

                // Category Name + Books Count
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        category.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.1,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textPrimary,
                        ),
                      ),

                      if (category.booksCount > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 1),
                          child: Text(
                            '${category.booksCount} books',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              height: 1.1,
                              color: isSelected
                                  ? Colors.white.withValues(alpha: 0.8)
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}