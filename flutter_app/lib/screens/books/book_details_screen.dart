import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/api_config.dart';
import '../../config/app_colors.dart';
import '../../models/book.dart';
import '../../providers/auth_provider.dart';
import '../../providers/book_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../utils/helpers.dart';
import '../../utils/responsive.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/price_widget.dart';
import '../../widgets/rating_widget.dart';
import '../auth/login_screen.dart';

class BookDetailsScreen extends StatefulWidget {
  final int bookId;

  const BookDetailsScreen({
    super.key,
    required this.bookId,
  });

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  int _selectedQuantity = 1;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookProvider>(
        context,
        listen: false,
      ).fetchBookDetails(widget.bookId);
    });
  }

  // ===========================================================================
  // ADD REVIEW
  // ===========================================================================

  void _showAddReviewModal(
      BuildContext context,
      Book book,
      ) {
    final auth = Provider.of<AuthProvider>(
      context,
      listen: false,
    );

    if (!auth.isAuthenticated) {
      Helpers.showSnackBar(
        context,
        'Please login to leave a review',
      );

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => const LoginScreen(),
        ),
      );

      return;
    }

    double selectedRating = 5.0;
    final commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalContext, setModalState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 24,
                  bottom:
                  MediaQuery.of(modalContext).viewInsets.bottom +
                      24,
                ),
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 650,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Write a Review',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.close,
                              ),
                              onPressed: () =>
                                  Navigator.pop(ctx),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        const Text(
                          'How would you rate this book?',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Center(
                          child: InteractiveRatingBar(
                            rating: selectedRating,
                            size: 38,
                            onRatingChanged: (rating) {
                              setModalState(() {
                                selectedRating = rating;
                              });
                            },
                          ),
                        ),

                        const SizedBox(height: 16),

                        TextField(
                          controller: commentController,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            hintText:
                            'Share your thoughts on this book...',
                          ),
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            text: 'Submit Review',
                            onPressed: () async {
                              if (commentController.text
                                  .trim()
                                  .isEmpty) {
                                Helpers.showSnackBar(
                                  modalContext,
                                  'Please enter your review comment',
                                  isError: true,
                                );
                                return;
                              }

                              final comment =
                              commentController.text.trim();

                              Navigator.pop(ctx);

                              final bookProvider =
                              Provider.of<BookProvider>(
                                context,
                                listen: false,
                              );

                              final success =
                              await bookProvider.submitReview(
                                bookId: book.id,
                                rating: selectedRating,
                                comment: comment,
                              );

                              if (context.mounted) {
                                if (success) {
                                  Helpers.showSnackBar(
                                    context,
                                    'Thank you! Your review has been submitted.',
                                    isSuccess: true,
                                  );
                                } else {
                                  Helpers.showSnackBar(
                                    context,
                                    'Failed to submit review. Please try again.',
                                    isError: true,
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(
      commentController.dispose,
    );
  }

  // ===========================================================================
  // ADD TO CART
  // ===========================================================================

  void _addToCart(Book book) async {
    final auth = Provider.of<AuthProvider>(
      context,
      listen: false,
    );

    if (!auth.isAuthenticated) {
      Helpers.showSnackBar(
        context,
        'Please sign in to add items to your cart',
      );

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => const LoginScreen(),
        ),
      );

      return;
    }

    final cartProvider = Provider.of<CartProvider>(
      context,
      listen: false,
    );

    final success = await cartProvider.addToCart(
      book,
      quantity: _selectedQuantity,
    );

    if (mounted) {
      if (success) {
        Helpers.showSnackBar(
          context,
          'Added $_selectedQuantity item(s) to your cart',
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

  // ===========================================================================
  // WISHLIST
  // ===========================================================================

  void _toggleWishlist(Book book) async {
    final auth = Provider.of<AuthProvider>(
      context,
      listen: false,
    );

    if (!auth.isAuthenticated) {
      Helpers.showSnackBar(
        context,
        'Please login to save to wishlist',
      );

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => const LoginScreen(),
        ),
      );

      return;
    }

    final added = await Provider.of<WishlistProvider>(
      context,
      listen: false,
    ).toggleWishlist(book);

    if (mounted) {
      Helpers.showSnackBar(
        context,
        added
            ? 'Added to wishlist'
            : 'Removed from wishlist',
        isSuccess: added,
      );
    }
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final bookProvider = context.watch<BookProvider>();

    if (bookProvider.isLoadingBookDetails) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: LoadingWidget(
          message: 'Loading book details...',
        ),
      );
    }

    if (bookProvider.errorMessage != null ||
        bookProvider.activeBook == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(),
        body: AppErrorWidget(
          message: bookProvider.errorMessage ??
              'Book details could not be loaded.',
          onRetry: () {
            bookProvider.fetchBookDetails(
              widget.bookId,
            );
          },
        ),
      );
    }

    final book = bookProvider.activeBook!;

    final isWishlisted =
        context.watch<WishlistProvider>().isInWishlist(book.id) ||
            book.isWishlisted;

    // IMPORTANT:
    // Desktop only from 1200px.
    if (Responsive.isDesktop(context)) {
      return _buildDesktopLayout(
        context,
        book,
        isWishlisted,
        bookProvider,
      );
    }

    return _buildMobileTabletLayout(
      context,
      book,
      isWishlisted,
      bookProvider,
    );
  }

  // ===========================================================================
  // MOBILE + TABLET
  // ===========================================================================

  Widget _buildMobileTabletLayout(
      BuildContext context,
      Book book,
      bool isWishlisted,
      BookProvider bookProvider,
      ) {
    final isTablet = Responsive.isTablet(context);

    final expandedHeight = isTablet ? 430.0 : 380.0;
    final coverHeight = isTablet ? 320.0 : 280.0;
    final coverWidth = isTablet ? 215.0 : 190.0;

    final horizontalPadding = isTablet ? 32.0 : 20.0;

    return Scaffold(
      backgroundColor: AppColors.background,

      body: CustomScrollView(
        slivers: [
          // -------------------------------------------------------------------
          // COVER
          // -------------------------------------------------------------------

          SliverAppBar(
            expandedHeight: expandedHeight,
            pinned: true,
            backgroundColor: AppColors.primaryDark,

            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: Colors.black45,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),

            actions: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: CircleAvatar(
                  backgroundColor: Colors.black45,
                  child: IconButton(
                    icon: Icon(
                      isWishlisted
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: isWishlisted
                          ? AppColors.error
                          : Colors.white,
                      size: 20,
                    ),
                    onPressed: () {
                      _toggleWishlist(book);
                    },
                  ),
                ),
              ),
            ],

            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  const ColoredBox(
                    color: Color(0xFF0F172A),
                  ),

                  Center(
                    child: Hero(
                      tag: 'book_cover_${book.id}',
                      child: Container(
                        height: coverHeight,
                        width: coverWidth,
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(
                                alpha: 0.5,
                              ),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius:
                          BorderRadius.circular(16),
                          child: _buildBookImage(
                            book.imageUrl,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // -------------------------------------------------------------------
          // CONTENT
          // -------------------------------------------------------------------

          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 20,
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  // ------------------------------------------------------------
                  // CATEGORY + STOCK
                  // ------------------------------------------------------------

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment:
                    WrapCrossAlignment.center,
                    children: [
                      if (book.category != null)
                        Container(
                          constraints: BoxConstraints(
                            maxWidth:
                            MediaQuery.sizeOf(context)
                                .width *
                                0.55,
                          ),
                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary
                                .withValues(alpha: 0.08),
                            borderRadius:
                            BorderRadius.circular(8),
                          ),
                          child: Text(
                            book.category!.name,
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight:
                              FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),

                      _buildStockBadge(book),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // ------------------------------------------------------------
                  // TITLE
                  // ------------------------------------------------------------

                  Text(
                    book.title,
                    style: TextStyle(
                      fontSize: isTablet ? 26 : 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // ------------------------------------------------------------
                  // AUTHOR
                  // ------------------------------------------------------------

                  Text(
                    'by ${book.author}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ------------------------------------------------------------
                  // RATING + PRICE
                  // ------------------------------------------------------------

                  Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      RatingWidget(
                        rating: book.rating,
                        reviewsCount:
                        book.reviewsCount,
                        iconSize: 18,
                        showScore: true,
                      ),

                      const SizedBox(height: 8),

                      SingleChildScrollView(
                        scrollDirection:
                        Axis.horizontal,
                        child: PriceWidget(
                          price: book.price,
                          discountPrice:
                          book.discountPrice,
                          fontSize:
                          isTablet ? 24 : 22,
                          showDiscountBadge: true,
                        ),
                      ),
                    ],
                  ),

                  const Divider(
                    height: 32,
                  ),

                  // ------------------------------------------------------------
                  // META
                  // ------------------------------------------------------------

                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _buildMetaInfoCard(
                        icon:
                        Icons.auto_stories_outlined,
                        label: 'Pages',
                        value:
                        book.pageCount != null
                            ? '${book.pageCount}'
                            : '320',
                      ),
                      _buildMetaInfoCard(
                        icon:
                        Icons.calendar_today_outlined,
                        label: 'Published',
                        value:
                        book.publishedYear != null
                            ? '${book.publishedYear}'
                            : '2023',
                      ),
                      _buildMetaInfoCard(
                        icon:
                        Icons.business_outlined,
                        label: 'Publisher',
                        value:
                        book.publisher ??
                            'BookStore Press',
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ------------------------------------------------------------
                  // DESCRIPTION
                  // ------------------------------------------------------------

                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    book.description ??
                        'No description available for this book.',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),

                  const Divider(
                    height: 36,
                  ),

                  // ------------------------------------------------------------
                  // REVIEWS
                  // ------------------------------------------------------------

                  _buildReviewsSection(
                    context,
                    book,
                    bookProvider,
                    isDesktop: false,
                  ),

                  // Bottom sticky cart માટે જગ્યા
                  const SizedBox(height: 115),
                ],
              ),
            ),
          ),
        ],
      ),

      // -----------------------------------------------------------------------
      // MOBILE/TABLET STICKY CART
      // -----------------------------------------------------------------------

      bottomSheet: _buildBottomCartBar(
        context,
        book,
      ),
    );
  }

  // ===========================================================================
  // BOTTOM CART BAR
  // ===========================================================================

  Widget _buildBottomCartBar(
      BuildContext context,
      Book book,
      ) {
    final isTablet = Responsive.isTablet(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.08,
            ),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            isTablet ? 24 : 16,
            10,
            isTablet ? 24 : 16,
            10,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact =
                  constraints.maxWidth < 500;

              return Row(
                children: [
                  if (book.inStock) ...[
                    _buildQuantitySelector(
                      book,
                      compact: compact,
                    ),

                    const SizedBox(width: 10),
                  ],

                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: CustomButton(
                        text: book.inStock
                            ? compact
                            ? 'Add to Cart'
                            : 'Add to Cart • ${Helpers.formatPrice(book.effectivePrice * _selectedQuantity)}'
                            : 'Out of Stock',
                        icon: book.inStock
                            ? Icons
                            .shopping_bag_outlined
                            : null,
                        backgroundColor:
                        book.inStock
                            ? AppColors.primary
                            : AppColors.textMuted,
                        onPressed: book.inStock
                            ? () => _addToCart(book)
                            : null,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // QUANTITY SELECTOR
  // ===========================================================================

  Widget _buildQuantitySelector(
      Book book, {
        required bool compact,
      }) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 40,
              minHeight: 48,
            ),
            icon: const Icon(
              Icons.remove,
              size: 16,
            ),
            onPressed: _selectedQuantity > 1
                ? () {
              setState(() {
                _selectedQuantity--;
              });
            }
                : null,
          ),

          SizedBox(
            width: compact ? 20 : 24,
            child: Center(
              child: Text(
                '$_selectedQuantity',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),

          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 40,
              minHeight: 48,
            ),
            icon: const Icon(
              Icons.add,
              size: 16,
            ),
            onPressed:
            _selectedQuantity < book.stock
                ? () {
              setState(() {
                _selectedQuantity++;
              });
            }
                : null,
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // STOCK BADGE
  // ===========================================================================

  Widget _buildStockBadge(Book book) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: book.inStock
            ? AppColors.successBg
            : AppColors.errorBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            book.inStock
                ? Icons.check_circle_outline
                : Icons.cancel_outlined,
            size: 14,
            color: book.inStock
                ? AppColors.success
                : AppColors.error,
          ),

          const SizedBox(width: 4),

          Text(
            book.inStock
                ? 'In Stock (${book.stock})'
                : 'Out of Stock',
            style: TextStyle(
              color: book.inStock
                  ? AppColors.success
                  : AppColors.error,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // DESKTOP
  // ===========================================================================

  Widget _buildDesktopLayout(
      BuildContext context,
      Book book,
      bool isWishlisted,
      BookProvider bookProvider,
      ) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: Text(
          book.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: Icon(
              isWishlisted
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: isWishlisted
                  ? AppColors.error
                  : AppColors.textPrimary,
            ),
            tooltip: 'Wishlist',
            onPressed: () => _toggleWishlist(book),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: ResponsiveContainer(
          maxWidth: 1320,
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 28,
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              // ----------------------------------------------------------------
              // PRODUCT SECTION
              // ----------------------------------------------------------------

              LayoutBuilder(
                builder: (context, constraints) {
                  final coverWidth =
                  (constraints.maxWidth * 0.29)
                      .clamp(300.0, 370.0);

                  return Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      // --------------------------------------------------------
                      // BOOK COVER
                      // --------------------------------------------------------

                      SizedBox(
                        width: coverWidth,
                        child: AspectRatio(
                          aspectRatio: 0.71,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(16),
                              border: Border.all(
                                color:
                                AppColors.border,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withValues(
                                    alpha: 0.08,
                                  ),
                                  blurRadius: 20,
                                  offset:
                                  const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius:
                              BorderRadius.circular(16),
                              child: _buildBookImage(
                                book.imageUrl,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 36),

                      // --------------------------------------------------------
                      // DETAILS
                      // --------------------------------------------------------

                      Expanded(
                        child: _buildDesktopDetails(
                          context,
                          book,
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 40),

              const Divider(
                height: 1,
              ),

              const SizedBox(height: 28),

              // ----------------------------------------------------------------
              // REVIEWS
              // ----------------------------------------------------------------

              _buildReviewsSection(
                context,
                book,
                bookProvider,
                isDesktop: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // DESKTOP DETAILS
  // ===========================================================================

  Widget _buildDesktopDetails(
      BuildContext context,
      Book book,
      ) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        // ----------------------------------------------------------------------
        // CATEGORY + STOCK
        // ----------------------------------------------------------------------

        Wrap(
          spacing: 10,
          runSpacing: 8,
          children: [
            if (book.category != null)
              Container(
                constraints: const BoxConstraints(
                  maxWidth: 300,
                ),
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary
                      .withValues(alpha: 0.08),
                  borderRadius:
                  BorderRadius.circular(8),
                ),
                child: Text(
                  book.category!.name,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight:
                    FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),

            _buildStockBadge(book),
          ],
        ),

        const SizedBox(height: 16),

        // ----------------------------------------------------------------------
        // TITLE
        // ----------------------------------------------------------------------

        Text(
          book.title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),

        const SizedBox(height: 6),

        // ----------------------------------------------------------------------
        // AUTHOR
        // ----------------------------------------------------------------------

        Text(
          'by ${book.author}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),

        const SizedBox(height: 18),

        // ----------------------------------------------------------------------
        // RATING + PRICE
        // ----------------------------------------------------------------------

        Wrap(
          spacing: 20,
          runSpacing: 10,
          crossAxisAlignment:
          WrapCrossAlignment.center,
          children: [
            RatingWidget(
              rating: book.rating,
              reviewsCount:
              book.reviewsCount,
              iconSize: 20,
              showScore: true,
            ),

            PriceWidget(
              price: book.price,
              discountPrice:
              book.discountPrice,
              fontSize: 24,
              showDiscountBadge: true,
            ),
          ],
        ),

        const Divider(
          height: 32,
        ),

        // ----------------------------------------------------------------------
        // BUY BOX
        // ----------------------------------------------------------------------

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.border,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Wrap(
                spacing: 16,
                runSpacing: 12,
                crossAxisAlignment:
                WrapCrossAlignment.center,
                children: [
                  if (book.inStock)
                    _buildDesktopQuantityControl(
                      book,
                    ),

                  SizedBox(
                    width: constraints.maxWidth > 560
                        ? 380
                        : constraints.maxWidth,
                    height: 48,
                    child: CustomButton(
                      text: book.inStock
                          ? 'Add to Cart • ${Helpers.formatPrice(book.effectivePrice * _selectedQuantity)}'
                          : 'Out of Stock',
                      icon: book.inStock
                          ? Icons
                          .shopping_bag_outlined
                          : null,
                      backgroundColor:
                      book.inStock
                          ? AppColors.primary
                          : AppColors.textMuted,
                      onPressed: book.inStock
                          ? () => _addToCart(book)
                          : null,
                    ),
                  ),
                ],
              );
            },
          ),
        ),

        const SizedBox(height: 28),

        // ----------------------------------------------------------------------
        // DESCRIPTION
        // ----------------------------------------------------------------------

        const Text(
          'Description',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          book.description ??
              'No description available for this book.',
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),

        const SizedBox(height: 24),

        // ----------------------------------------------------------------------
        // METADATA
        // ----------------------------------------------------------------------

        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildMetaInfoCard(
              icon: Icons.auto_stories_outlined,
              label: 'Pages',
              value: book.pageCount != null
                  ? '${book.pageCount}'
                  : '320',
            ),
            _buildMetaInfoCard(
              icon:
              Icons.calendar_today_outlined,
              label: 'Published',
              value:
              book.publishedYear != null
                  ? '${book.publishedYear}'
                  : '2023',
            ),
            _buildMetaInfoCard(
              icon: Icons.business_outlined,
              label: 'Publisher',
              value: book.publisher ??
                  'BookStore Press',
            ),
          ],
        ),
      ],
    );
  }

  // ===========================================================================
  // DESKTOP QUANTITY
  // ===========================================================================

  Widget _buildDesktopQuantityControl(
      Book book,
      ) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius:
        BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(
              Icons.remove,
              size: 16,
            ),
            onPressed: _selectedQuantity > 1
                ? () {
              setState(() {
                _selectedQuantity--;
              });
            }
                : null,
          ),

          Padding(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Text(
              '$_selectedQuantity',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          IconButton(
            icon: const Icon(
              Icons.add,
              size: 16,
            ),
            onPressed:
            _selectedQuantity < book.stock
                ? () {
              setState(() {
                _selectedQuantity++;
              });
            }
                : null,
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // REVIEWS SECTION
  // ===========================================================================

  Widget _buildReviewsSection(
      BuildContext context,
      Book book,
      BookProvider bookProvider, {
        required bool isDesktop,
      }) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment:
          CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                'Customer Reviews (${bookProvider.activeBookReviews.length})',
                style: TextStyle(
                  fontSize:
                  isDesktop ? 20 : 17,
                  fontWeight:
                  FontWeight.bold,
                  color:
                  AppColors.textPrimary,
                ),
              ),
            ),

            TextButton.icon(
              onPressed: () {
                _showAddReviewModal(
                  context,
                  book,
                );
              },
              icon: const Icon(
                Icons.rate_review_outlined,
                size: 16,
              ),
              label: const Text(
                'Write Review',
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        if (bookProvider.isLoadingReviews)
          const Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          )
        else if (
        bookProvider.activeBookReviews.isEmpty
        )
          Container(
            width: double.infinity,
            padding:
            const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius:
              BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.border,
              ),
            ),
            child: const Center(
              child: Text(
                'No reviews yet. Be the first to review this book!',
                textAlign:
                TextAlign.center,
                style: TextStyle(
                  color:
                  AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics:
            const NeverScrollableScrollPhysics(),
            itemCount: bookProvider
                .activeBookReviews.length,
            separatorBuilder:
                (_, __) =>
            const SizedBox(height: 12),
            itemBuilder: (_, index) {
              return _buildReviewCard(
                bookProvider
                    .activeBookReviews[index],
              );
            },
          ),
      ],
    );
  }

  // ===========================================================================
  // META CARD
  // ===========================================================================

  Widget _buildMetaInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return SizedBox(
      width: 145,
      child: Container(
        padding:
        const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius:
          BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.border,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20,
              color: AppColors.primary,
            ),

            const SizedBox(height: 4),

            Text(
              label,
              maxLines: 1,
              overflow:
              TextOverflow.ellipsis,
              textAlign:
              TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                color:
                AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 2),

            Text(
              value,
              maxLines: 1,
              overflow:
              TextOverflow.ellipsis,
              textAlign:
              TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight:
                FontWeight.bold,
                color:
                AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // REVIEW CARD
  // ===========================================================================

  Widget _buildReviewCard(
      dynamic review,
      ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius:
        BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment:
            CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor:
                      AppColors.primaryLight,
                      child: Text(
                        review.userName
                            .isNotEmpty
                            ? review.userName[0]
                            .toUpperCase()
                            : 'U',
                        style:
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        review.userName,
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style:
                        const TextStyle(
                          fontWeight:
                          FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              RatingWidget(
                rating: review.rating,
                compact: true,
                iconSize: 11,
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            review.comment,
            style: const TextStyle(
              fontSize: 13,
              color:
              AppColors.textSecondary,
              height: 1.4,
            ),
          ),

          if (review.createdAt != null) ...[
            const SizedBox(height: 6),

            Text(
              Helpers.formatDate(
                review.createdAt,
              ),
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ===========================================================================
  // BOOK IMAGE
  // ===========================================================================

  Widget _buildBookImage(
      String? url,
      ) {
    final resolvedUrl =
    ApiConfig.resolveImageUrl(url);

    if (resolvedUrl.isEmpty) {
      return Container(
        color: AppColors.surfaceVariant,
        child: const Icon(
          Icons.menu_book_rounded,
          color: AppColors.textMuted,
          size: 60,
        ),
      );
    }

    return Image.network(
      resolvedUrl,
      fit: BoxFit.cover,
      errorBuilder:
          (context, error, stackTrace) {
        return Container(
          color: AppColors.surfaceVariant,
          child: const Icon(
            Icons.menu_book_rounded,
            color: AppColors.textMuted,
            size: 60,
          ),
        );
      },
    );
  }
}