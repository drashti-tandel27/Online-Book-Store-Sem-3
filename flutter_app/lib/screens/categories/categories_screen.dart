import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../providers/book_provider.dart';
import '../../utils/responsive.dart';
import '../../widgets/category_card.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';
import '../books/books_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookProvider = context.watch<BookProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('All Categories'),
      ),
      body: ResponsiveContainer(
        maxWidth: 1200,
        child: _buildBody(context, bookProvider),
      ),
    );
  }

  Widget _buildBody(BuildContext context, BookProvider bookProvider) {
    if (bookProvider.isLoadingHome && bookProvider.categories.isEmpty) {
      return const LoadingWidget(message: 'Loading categories...');
    }

    if (bookProvider.categories.isEmpty) {
      if (bookProvider.errorMessage != null) {
        return AppErrorWidget(
          message: bookProvider.errorMessage!,
          onRetry: () => bookProvider.fetchHomeData(),
        );
      }
      return const EmptyStateWidget(
        title: 'No Categories',
        message: 'No book categories available at the moment.',
      );
    }

    final columns = Responsive.gridColumns(context, mobile: 2, tablet: 3, desktop: 5);

    return RefreshIndicator(
      onRefresh: () => bookProvider.fetchHomeData(),
      color: AppColors.primary,
      child: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          childAspectRatio: 1.6,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
        ),
        itemCount: bookProvider.categories.length,
        itemBuilder: (ctx, index) {
          final category = bookProvider.categories[index];
          return CategoryCard(
            category: category,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => BooksScreen(
                    initialCategoryId: category.id,
                    categoryName: category.name,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
