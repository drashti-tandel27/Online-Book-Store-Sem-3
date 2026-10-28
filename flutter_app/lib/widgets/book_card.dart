import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/api_config.dart';
import '../config/app_colors.dart';
import '../models/book.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/books/book_details_screen.dart';
import '../utils/helpers.dart';
import 'price_widget.dart';
import 'rating_widget.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final bool isHorizontal;
  final VoidCallback? onTap;

  const BookCard({
    super.key,
    required this.book,
    this.isHorizontal = false,
    this.onTap,
  });

  void _handleTap(BuildContext context) {
    if (onTap != null) {
      onTap!();
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => BookDetailsScreen(
            bookId: book.id,
          ),
        ),
      );
    }
  }

  void _toggleWishlist(BuildContext context) async {
    final auth = Provider.of<AuthProvider>(
      context,
      listen: false,
    );

    if (!auth.isAuthenticated) {
      Helpers.showSnackBar(
        context,
        'Please login to add to wishlist',
      );

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => const LoginScreen(),
        ),
      );
      return;
    }

    final wishlistProvider =
    Provider.of<WishlistProvider>(
      context,
      listen: false,
    );

    final added =
    await wishlistProvider.toggleWishlist(book);

    if (context.mounted) {
      Helpers.showSnackBar(
        context,
        added
            ? 'Added to wishlist'
            : 'Removed from wishlist',
        isSuccess: added,
      );
    }
  }

  void _addToCart(BuildContext context) async {
    final auth = Provider.of<AuthProvider>(
      context,
      listen: false,
    );

    if (!auth.isAuthenticated) {
      Helpers.showSnackBar(
        context,
        'Please login to add to cart',
      );

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => const LoginScreen(),
        ),
      );
      return;
    }

    final cartProvider =
    Provider.of<CartProvider>(
      context,
      listen: false,
    );

    final success =
    await cartProvider.addToCart(book);

    if (context.mounted) {
      if (success) {
        Helpers.showSnackBar(
          context,
          'Book added to cart',
          isSuccess: true,
        );
      } else if (cartProvider.errorMessage != null) {
        Helpers.showSnackBar(
          context,
          cartProvider.errorMessage!,
          isError: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWishlisted =
        context.watch<WishlistProvider>().isInWishlist(
          book.id,
        ) ||
            book.isWishlisted;

    if (isHorizontal) {
      return _buildHorizontalCard(
        context,
        isWishlisted,
      );
    }

    return _buildGridCard(
      context,
      isWishlisted,
    );
  }

  // ==============================================================
  // HORIZONTAL CARD
  // ==============================================================

  Widget _buildHorizontalCard(
      BuildContext context,
      bool isWishlisted,
      ) {
    return SizedBox(
      width: 155,
      child: InkWell(
        onTap: () => _handleTap(context),
        borderRadius: BorderRadius.circular(14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 175,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius:
                    BorderRadius.circular(14),
                    child:
                    _buildBookImage(
                      book.imageUrl,
                    ),
                  ),

                  // WISHLIST
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Material(
                      color: Colors.white.withValues(
                        alpha: 0.92,
                      ),
                      shape:
                      const CircleBorder(),
                      child: InkWell(
                        customBorder:
                        const CircleBorder(),
                        onTap: () =>
                            _toggleWishlist(
                              context,
                            ),
                        child: Padding(
                          padding:
                          const EdgeInsets.all(
                            6,
                          ),
                          child: Icon(
                            isWishlisted
                                ? Icons
                                .favorite_rounded
                                : Icons
                                .favorite_border_rounded,
                            color: isWishlisted
                                ? AppColors.error
                                : AppColors.textMuted,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // OUT OF STOCK
                  if (!book.inStock)
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child:
                      _buildStockBadge(),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 7),

            SizedBox(
              height: 17,
              child: RatingWidget(
                rating: book.rating,
                compact: true,
                iconSize: 12,
              ),
            ),

            const SizedBox(height: 3),

            Text(
              book.title,
              maxLines: 2,
              overflow:
              TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight:
                FontWeight.w700,
                fontSize: 13,
                height: 1.15,
                color:
                AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 2),

            Text(
              book.author,
              maxLines: 1,
              overflow:
              TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                height: 1.1,
                color:
                AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 4),

            SizedBox(
              height: 20,
              child: PriceWidget(
                price: book.price,
                discountPrice:
                book.discountPrice,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==============================================================
  // GRID CARD
  // ==============================================================

  Widget _buildGridCard(
      BuildContext context,
      bool isWishlisted,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius:
        BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.03,
            ),
            blurRadius: 8,
            offset:
            const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius:
        BorderRadius.circular(16),
        child: InkWell(
          onTap: () =>
              _handleTap(context),
          borderRadius:
          BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              // ==================================================
              // BOOK IMAGE
              // ==================================================

              AspectRatio(
                // FIX:
                // 0.92 was causing a small bottom overflow.
                // 1.0 makes the image slightly shorter.
                aspectRatio: 1.0,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius:
                      const BorderRadius.vertical(
                        top: Radius.circular(15),
                      ),
                      child:
                      _buildBookImage(
                        book.imageUrl,
                      ),
                    ),

                    // WISHLIST BUTTON
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Material(
                        color:
                        Colors.white.withValues(
                          alpha: 0.92,
                        ),
                        shape:
                        const CircleBorder(),
                        child: InkWell(
                          customBorder:
                          const CircleBorder(),
                          onTap: () =>
                              _toggleWishlist(
                                context,
                              ),
                          child: Padding(
                            padding:
                            const EdgeInsets.all(
                              7,
                            ),
                            child: Icon(
                              isWishlisted
                                  ? Icons
                                  .favorite_rounded
                                  : Icons
                                  .favorite_border_rounded,
                              color: isWishlisted
                                  ? AppColors.error
                                  : AppColors.textMuted,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // OUT OF STOCK
                    if (!book.inStock)
                      Positioned(
                        top: 8,
                        left: 8,
                        child:
                        _buildStockBadge(),
                      ),
                  ],
                ),
              ),

              // ==================================================
              // CARD DETAILS
              // ==================================================

              Padding(
                padding:
                const EdgeInsets.fromLTRB(
                  10,
                  7,
                  10,
                  8,
                ),
                child: Column(
                  mainAxisSize:
                  MainAxisSize.min,
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    // RATING + DISCOUNT
                    SizedBox(
                      height: 18,
                      child: Row(
                        children: [
                          Expanded(
                            child:
                            RatingWidget(
                              rating:
                              book.rating,
                              compact: true,
                              iconSize: 11,
                            ),
                          ),

                          if (book.hasDiscount)
                            Container(
                              padding:
                              const EdgeInsets
                                  .symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              decoration:
                              BoxDecoration(
                                color:
                                AppColors.errorBg,
                                borderRadius:
                                BorderRadius
                                    .circular(
                                  4,
                                ),
                              ),
                              child: Text(
                                '-${(((book.price - book.discountPrice!) / book.price) * 100).round()}%',
                                style:
                                const TextStyle(
                                  fontSize: 8,
                                  fontWeight:
                                  FontWeight
                                      .bold,
                                  color:
                                  AppColors.error,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 4),

                    // TITLE
                    Text(
                      book.title,
                      maxLines: 2,
                      overflow:
                      TextOverflow.ellipsis,
                      style:
                      const TextStyle(
                        fontWeight:
                        FontWeight.bold,
                        fontSize: 13,
                        height: 1.15,
                        color:
                        AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 2),

                    // AUTHOR
                    Text(
                      book.author,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style:
                      const TextStyle(
                        fontSize: 11,
                        height: 1.1,
                        color:
                        AppColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 5),

                    // PRICE + CART
                    SizedBox(
                      height: 30,
                      child: Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child:
                            PriceWidget(
                              price:
                              book.price,
                              discountPrice:
                              book.discountPrice,
                              fontSize: 14,
                            ),
                          ),

                          const SizedBox(
                            width: 5,
                          ),

                          SizedBox(
                            width: 30,
                            height: 30,
                            child: Material(
                              color: book.inStock
                                  ? AppColors.primary
                                  : AppColors.textMuted,
                              borderRadius:
                              BorderRadius
                                  .circular(
                                8,
                              ),
                              child: InkWell(
                                borderRadius:
                                BorderRadius
                                    .circular(
                                  8,
                                ),
                                onTap: book.inStock
                                    ? () =>
                                    _addToCart(
                                      context,
                                    )
                                    : null,
                                child:
                                const Icon(
                                  Icons
                                      .add_shopping_cart_rounded,
                                  size: 16,
                                  color:
                                  Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==============================================================
  // STOCK BADGE
  // ==============================================================

  Widget _buildStockBadge() {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius:
        BorderRadius.circular(6),
      ),
      child: const Text(
        'Out of Stock',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight:
          FontWeight.bold,
        ),
      ),
    );
  }

  // ==============================================================
  // BOOK IMAGE
  // ==============================================================

  Widget _buildBookImage(String? url) {
    final resolvedUrl =
    ApiConfig.resolveImageUrl(url);

    if (resolvedUrl.isEmpty) {
      return _buildPlaceholder();
    }

    return Image.network(
      resolvedUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder:
          (context, error, stackTrace) {
        return _buildPlaceholder();
      },
      loadingBuilder:
          (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }

        return const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child:
            CircularProgressIndicator(
              strokeWidth: 2,
              color:
              AppColors.primary,
            ),
          ),
        );
      },
    );
  }

  // ==============================================================
  // PLACEHOLDER
  // ==============================================================

  Widget _buildPlaceholder() {
    return Container(
      color:
      AppColors.surfaceVariant,
      child: const Center(
        child: Icon(
          Icons.menu_book_rounded,
          color:
          AppColors.textMuted,
          size: 36,
        ),
      ),
    );
  }
}