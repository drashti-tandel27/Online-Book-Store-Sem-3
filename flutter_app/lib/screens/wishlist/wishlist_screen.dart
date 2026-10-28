import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/api_config.dart';
import '../../config/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../utils/helpers.dart';
import '../../utils/responsive.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/price_widget.dart';
import '../auth/login_screen.dart';
import '../books/book_details_screen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AuthProvider>(context, listen: false);

      if (auth.isAuthenticated) {
        Provider.of<WishlistProvider>(
          context,
          listen: false,
        ).fetchWishlist();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final wishlist = context.watch<WishlistProvider>();

    if (!auth.isAuthenticated) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('My Wishlist'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: EmptyStateWidget(
              title: 'Login to View Wishlist',
              message:
              'Sign in to your account to view and manage your saved books.',
              icon: Icons.favorite_border_rounded,
              buttonText: 'Sign In Now',
              onButtonPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                );
              },
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('My Wishlist (${wishlist.itemCount})'),
      ),
      body: _buildWishlistContent(context, wishlist),
    );
  }

  Widget _buildWishlistContent(
      BuildContext context,
      WishlistProvider wishlist,
      ) {
    if (wishlist.isLoading && wishlist.items.isEmpty) {
      return const LoadingWidget(
        message: 'Loading your wishlist...',
      );
    }

    if (wishlist.errorMessage != null && wishlist.items.isEmpty) {
      return AppErrorWidget(
        message: wishlist.errorMessage!,
        onRetry: wishlist.fetchWishlist,
      );
    }

    if (wishlist.items.isEmpty) {
      return const EmptyStateWidget(
        title: 'Your Wishlist is Empty',
        message:
        'Tap the heart icon on books you love to add them to your wishlist.',
        icon: Icons.favorite_border_rounded,
      );
    }

    final isMobile = Responsive.isMobile(context);
    final isDesktop = Responsive.isDesktop(context);

    return ResponsiveContainer(
      maxWidth: 1400,
      padding: EdgeInsets.zero,
      child: RefreshIndicator(
        onRefresh: wishlist.fetchWishlist,
        color: AppColors.primary,
        child: isMobile
            ? ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: wishlist.items.length,
          itemBuilder: (context, index) {
            final item = wishlist.items[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildWishlistItem(
                context,
                item,
                item.book,
                wishlist,
                enableDismissible: true,
              ),
            );
          },
        )
            : GridView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 32 : 24,
            vertical: 24,
          ),
          gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isDesktop ? 3 : 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            // Card height is now controlled by the content.
            // This avoids the old bottom overflow.
            childAspectRatio: isDesktop ? 2.7 : 2.35,
          ),
          itemCount: wishlist.items.length,
          itemBuilder: (context, index) {
            final item = wishlist.items[index];

            return _buildWishlistItem(
              context,
              item,
              item.book,
              wishlist,
              enableDismissible: false,
            );
          },
        ),
      ),
    );
  }

  Widget _buildWishlistItem(
      BuildContext context,
      dynamic item,
      dynamic book,
      WishlistProvider wishlist, {
        required bool enableDismissible,
      }) {
    final card = Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 360;

          final imageWidth = isCompact ? 68.0 : 72.0;
          final imageHeight = isCompact ? 96.0 : 100.0;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -------------------------------------------------
              // BOOK IMAGE
              // -------------------------------------------------
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BookDetailsScreen(
                        bookId: item.bookId,
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: imageWidth,
                    height: imageHeight,
                    child: _buildThumbnail(
                      book?.imageUrl,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // -------------------------------------------------
              // DETAILS
              // -------------------------------------------------
              Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        book?.title ??
                            'Book #${item.bookId}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        book?.author ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),

                      const SizedBox(height: 6),

                      if (book != null)
                        PriceWidget(
                          price: book.price,
                          discountPrice:
                          book.discountPrice,
                          fontSize: 14,
                        ),

                      const SizedBox(height: 7),

                      if (book != null && book.inStock)
                        _buildAddToCartButton(
                          context,
                          book,
                        )
                      else if (book != null)
                        const Text(
                          'Out of Stock',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.error,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // -------------------------------------------------
              // DELETE
              // -------------------------------------------------
              const SizedBox(width: 2),

              SizedBox(
                width: 40,
                height: 40,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  tooltip: 'Remove from wishlist',
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.error,
                    size: 21,
                  ),
                  onPressed: () async {
                    final confirm =
                    await Helpers.showConfirmationDialog(
                      context,
                      title: 'Remove from Wishlist',
                      content:
                      'Are you sure you want to remove this book from your wishlist?',
                      confirmText: 'Remove',
                      isDestructive: true,
                    );

                    if (confirm == true) {
                      await wishlist.removeItem(
                        item.id,
                        item.bookId,
                      );

                      if (context.mounted) {
                        Helpers.showSnackBar(
                          context,
                          'Removed from wishlist',
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );

    if (!enableDismissible) {
      return card;
    }

    return Dismissible(
      key: ValueKey(
        'wishlist_${item.id}_${item.bookId}',
      ),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
      onDismissed: (_) async {
        await wishlist.removeItem(
          item.id,
          item.bookId,
        );

        if (context.mounted) {
          Helpers.showSnackBar(
            context,
            'Removed from wishlist',
          );
        }
      },
      child: card,
    );
  }

  Widget _buildAddToCartButton(
      BuildContext context,
      dynamic book,
      ) {
    return SizedBox(
      height: 34,
      child: ElevatedButton.icon(
        onPressed: () async {
          final cartProvider =
          Provider.of<CartProvider>(
            context,
            listen: false,
          );

          final success =
          await cartProvider.addToCart(book);

          if (!context.mounted) {
            return;
          }

          if (success) {
            Helpers.showSnackBar(
              context,
              'Added to cart!',
              isSuccess: true,
            );
          } else if (cartProvider.errorMessage != null) {
            Helpers.showSnackBar(
              context,
              cartProvider.errorMessage!,
              isError: true,
            );
          }
        },
        icon: const Icon(
          Icons.add_shopping_cart,
          size: 14,
        ),
        label: const Text(
          'Add to Cart',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
          ),
          minimumSize: const Size(0, 34),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  // =============================================================
  // BOOK IMAGE
  // =============================================================

  Widget _buildThumbnail(String? url) {
    final resolvedUrl =
    ApiConfig.resolveImageUrl(url);

    if (resolvedUrl.isEmpty) {
      return _placeholder();
    }

    return Image.network(
      resolvedUrl,
      fit: BoxFit.cover,
      loadingBuilder:
          (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }

        return const Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          ),
        );
      },
      errorBuilder:
          (context, error, stackTrace) {
        return _placeholder();
      },
    );
  }

  Widget _placeholder() {
    return Container(
      color: AppColors.surfaceVariant,
      child: const Center(
        child: Icon(
          Icons.menu_book_rounded,
          color: AppColors.textMuted,
          size: 30,
        ),
      ),
    );
  }
}