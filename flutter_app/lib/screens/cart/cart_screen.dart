import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/api_config.dart';
import '../../config/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../utils/helpers.dart';
import '../../utils/responsive.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/price_widget.dart';
import '../auth/login_screen.dart';
import '../checkout/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AuthProvider>(context, listen: false);

      if (auth.isAuthenticated) {
        Provider.of<CartProvider>(context, listen: false).fetchCart();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final cartProvider = context.watch<CartProvider>();

    if (!auth.isAuthenticated) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('My Cart'),
        ),
        body: Center(
          child: Padding(
            padding: Responsive.horizontalPadding(context),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: EmptyStateWidget(
                title: 'Login to View Cart',
                message:
                'Sign in to access your cart, apply discounts, and complete your order seamlessly.',
                icon: Icons.shopping_bag_outlined,
                buttonText: 'Sign In Now',
                onButtonPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => const LoginScreen(),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'My Shopping Cart (${cartProvider.itemCount})',
        ),
        actions: [
          if (cartProvider.items.isNotEmpty)
            IconButton(
              icon: const Icon(
                Icons.delete_sweep_outlined,
                color: AppColors.error,
              ),
              tooltip: 'Clear Cart',
              onPressed: () async {
                final confirm = await Helpers.showConfirmationDialog(
                  context,
                  title: 'Clear Cart',
                  content:
                  'Are you sure you want to remove all items from your cart?',
                  confirmText: 'Clear All',
                  isDestructive: true,
                );

                if (confirm == true) {
                  cartProvider.clearCart();
                }
              },
            ),
        ],
      ),
      body: _buildBody(context, cartProvider),
    );
  }

  Widget _buildBody(
      BuildContext context,
      CartProvider cartProvider,
      ) {
    if (cartProvider.isLoading && cartProvider.items.isEmpty) {
      return const LoadingWidget(
        message: 'Loading your cart...',
      );
    }

    if (cartProvider.errorMessage != null &&
        cartProvider.items.isEmpty) {
      return AppErrorWidget(
        message: cartProvider.errorMessage!,
        onRetry: () => cartProvider.fetchCart(),
      );
    }

    if (cartProvider.isEmpty) {
      return const EmptyStateWidget(
        title: 'Your Cart is Empty',
        message:
        'Looks like you have not added any books to your cart yet. Explore our collection!',
        icon: Icons.shopping_cart_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: () => cartProvider.fetchCart(),
      color: AppColors.primary,
      child: ResponsiveLayout(
        mobile: (context) => _buildMobileLayout(
          context,
          cartProvider,
        ),
        tablet: (context) => _buildTabletLayout(
          context,
          cartProvider,
        ),
        desktop: (context) => _buildDesktopLayout(
          context,
          cartProvider,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // MOBILE
  // ---------------------------------------------------------------------------

  Widget _buildMobileLayout(
      BuildContext context,
      CartProvider cartProvider,
      ) {
    return Column(
      children: [
        Expanded(
          child: _buildItemsList(
            context,
            cartProvider,
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              12,
            ),
          ),
        ),

        _buildMobileSummaryPanel(
          context,
          cartProvider,
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // TABLET
  // ---------------------------------------------------------------------------

  Widget _buildTabletLayout(
      BuildContext context,
      CartProvider cartProvider,
      ) {
    return ResponsiveContainer(
      maxWidth: 1100,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 20,
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 6,
                  child: _buildItemsList(
                    context,
                    cartProvider,
                    padding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 4,
                  child: SingleChildScrollView(
                    child: _buildSummaryCard(
                      context,
                      cartProvider,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DESKTOP
  // ---------------------------------------------------------------------------

  Widget _buildDesktopLayout(
      BuildContext context,
      CartProvider cartProvider,
      ) {
    return ResponsiveContainer(
      maxWidth: 1280,
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 24,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 7,
            child: _buildItemsList(
              context,
              cartProvider,
              padding: EdgeInsets.zero,
            ),
          ),

          const SizedBox(width: 28),

          ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 320,
              maxWidth: 380,
            ),
            child: SingleChildScrollView(
              child: _buildSummaryCard(
                context,
                cartProvider,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CART ITEMS LIST
  // ---------------------------------------------------------------------------

  Widget _buildItemsList(
      BuildContext context,
      CartProvider cartProvider, {
        required EdgeInsetsGeometry padding,
      }) {
    return ListView.separated(
      padding: padding,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: cartProvider.items.length,
      separatorBuilder: (context, index) {
        return const SizedBox(height: 14);
      },
      itemBuilder: (ctx, index) {
        return _buildCartItem(
          context,
          cartProvider.items[index],
          cartProvider,
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // CART ITEM
  // ---------------------------------------------------------------------------

  Widget _buildCartItem(
      BuildContext context,
      dynamic item,
      CartProvider cartProvider,
      ) {
    final book = item.book;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 400;

          final imageWidth = compact ? 58.0 : 68.0;
          final imageHeight = compact ? 82.0 : 94.0;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ---------------------------------------------------------------
              // IMAGE
              // ---------------------------------------------------------------

              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: imageWidth,
                  height: imageHeight,
                  child: ColoredBox(
                    color: AppColors.surfaceVariant,
                    child: _buildThumbnail(
                      book?.imageUrl,
                    ),
                  ),
                ),
              ),

              SizedBox(
                width: compact ? 10 : 14,
              ),

              // ---------------------------------------------------------------
              // DETAILS
              // ---------------------------------------------------------------

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book?.title ?? 'Book Item #${item.bookId}',
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

                    const SizedBox(height: 8),

                    PriceWidget(
                      price: item.price,
                      fontSize: 15,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // ---------------------------------------------------------------
              // QUANTITY + REMOVE
              // ---------------------------------------------------------------

              _buildQuantitySection(
                context,
                item,
                book,
                cartProvider,
                compact: compact,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildQuantitySection(
      BuildContext context,
      dynamic item,
      dynamic book,
      CartProvider cartProvider, {
        required bool compact,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: 36,
          height: 32,
          child: IconButton(
            icon: const Icon(
              Icons.close_rounded,
              size: 18,
              color: AppColors.textMuted,
            ),
            padding: EdgeInsets.zero,
            tooltip: 'Remove',
            onPressed: () async {
              final confirm =
              await Helpers.showConfirmationDialog(
                context,
                title: 'Remove Item',
                content:
                'Remove this book from your cart?',
                confirmText: 'Remove',
                isDestructive: true,
              );

              if (confirm == true) {
                cartProvider.removeItem(item.id);
              }
            },
          ),
        ),

        const SizedBox(height: 8),

        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  cartProvider.updateQuantity(
                    item.id,
                    item.quantity - 1,
                    maxStock: book?.stock,
                  );
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: compact ? 6 : 8,
                    vertical: 5,
                  ),
                  child: const Icon(
                    Icons.remove,
                    size: 14,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                ),
                child: Text(
                  '${item.quantity}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),

              InkWell(
                onTap: () {
                  cartProvider.updateQuantity(
                    item.id,
                    item.quantity + 1,
                    maxStock: book?.stock,
                  );
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: compact ? 6 : 8,
                    vertical: 5,
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // MOBILE SUMMARY
  // ---------------------------------------------------------------------------

  Widget _buildMobileSummaryPanel(
      BuildContext context,
      CartProvider cartProvider,
      ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        16,
        20,
        12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: _buildOrderSummary(
          context,
          cartProvider,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SUMMARY CARD
  // ---------------------------------------------------------------------------

  Widget _buildSummaryCard(
      BuildContext context,
      CartProvider cartProvider,
      ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),

          const Divider(height: 24),

          _buildOrderSummary(
            context,
            cartProvider,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ORDER SUMMARY
  // ---------------------------------------------------------------------------

  Widget _buildOrderSummary(
      BuildContext context,
      CartProvider cartProvider,
      ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildSummaryRow(
          label: 'Subtotal',
          value: Helpers.formatPrice(
            cartProvider.subtotal,
          ),
        ),

        const SizedBox(height: 8),

        _buildSummaryRow(
          label: 'Shipping Fee',
          value: cartProvider.shippingFee == 0
              ? 'FREE'
              : Helpers.formatPrice(
            cartProvider.shippingFee,
          ),
          valueColor: cartProvider.shippingFee == 0
              ? AppColors.success
              : AppColors.textPrimary,
        ),

        const SizedBox(height: 8),

        _buildSummaryRow(
          label: 'Estimated Tax (5%)',
          value: Helpers.formatPrice(
            cartProvider.tax,
          ),
        ),

        const Divider(height: 24),

        _buildSummaryRow(
          label: 'Total Amount',
          value: Helpers.formatPrice(
            cartProvider.totalAmount,
          ),
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          valueStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),

        const SizedBox(height: 16),

        SizedBox(
          width: double.infinity,
          child: CustomButton(
            text: 'Proceed to Checkout',
            icon: Icons.lock_outline_rounded,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const CheckoutScreen(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow({
    required String label,
    required String value,
    TextStyle? labelStyle,
    TextStyle? valueStyle,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: labelStyle ??
                const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
          ),
        ),

        const SizedBox(width: 12),

        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: valueStyle ??
                TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? AppColors.textPrimary,
                ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // THUMBNAIL
  // ---------------------------------------------------------------------------

  Widget _buildThumbnail(String? url) {
    final resolvedUrl = ApiConfig.resolveImageUrl(url);

    if (resolvedUrl.isEmpty) {
      return const Center(
        child: Icon(
          Icons.menu_book_rounded,
          color: AppColors.textMuted,
        ),
      );
    }

    return Image.network(
      resolvedUrl,
      fit: BoxFit.cover,
      errorBuilder: (
          context,
          error,
          stackTrace,
          ) {
        return const Center(
          child: Icon(
            Icons.menu_book_rounded,
            color: AppColors.textMuted,
          ),
        );
      },
    );
  }
}