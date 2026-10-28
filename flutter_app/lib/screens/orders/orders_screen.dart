import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../../utils/helpers.dart';
import '../../utils/responsive.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/order_status_widget.dart';
import '../auth/login_screen.dart';
import '../main_nav_screen.dart';
import 'order_details_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() =>
      _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AuthProvider>(
        context,
        listen: false,
      );

      if (auth.isAuthenticated) {
        Provider.of<OrderProvider>(
          context,
          listen: false,
        ).fetchOrders();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final orderProvider =
    context.watch<OrderProvider>();

    // -------------------------------------------------------------------------
    // NOT AUTHENTICATED
    // -------------------------------------------------------------------------

    if (!auth.isAuthenticated) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('My Orders'),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(
              Responsive.isMobile(context)
                  ? 20
                  : 32,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 600,
              ),
              child: EmptyStateWidget(
                title: 'Sign in to View Orders',
                message:
                'Log in to track your current purchases, review history, and view receipts.',
                icon:
                Icons.receipt_long_outlined,
                buttonText: 'Sign In Now',
                onButtonPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) =>
                      const LoginScreen(),
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
        title: const Text('My Orders'),
      ),
      body: _buildBody(
        context,
        orderProvider,
      ),
    );
  }

  // ===========================================================================
  // BODY
  // ===========================================================================

  Widget _buildBody(
      BuildContext context,
      OrderProvider orderProvider,
      ) {
    // -------------------------------------------------------------------------
    // LOADING
    // -------------------------------------------------------------------------

    if (orderProvider.isLoadingOrders &&
        orderProvider.orders.isEmpty) {
      return const LoadingWidget(
        message: 'Loading your orders...',
      );
    }

    // -------------------------------------------------------------------------
    // ERROR
    // -------------------------------------------------------------------------

    if (orderProvider.errorMessage != null &&
        orderProvider.orders.isEmpty) {
      return AppErrorWidget(
        message: orderProvider.errorMessage!,
        onRetry: () {
          orderProvider.fetchOrders();
        },
      );
    }

    // -------------------------------------------------------------------------
    // EMPTY
    // -------------------------------------------------------------------------

    if (orderProvider.orders.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(
            Responsive.isMobile(context)
                ? 20
                : 32,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 600,
            ),
            child: EmptyStateWidget(
              title: 'No Orders Yet',
              message:
              'You have not placed any orders yet. Discover our bestsellers and start reading today!',
              icon:
              Icons.receipt_long_outlined,
              buttonText: 'Start Shopping',
              onButtonPressed: () {
                Navigator.of(context)
                    .pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (ctx) =>
                    const MainNavScreen(),
                  ),
                      (route) => false,
                );
              },
            ),
          ),
        ),
      );
    }

    // -------------------------------------------------------------------------
    // ORDERS LIST
    // -------------------------------------------------------------------------

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final isMobile =
            width < Responsive.mobileBreakpoint;

        final isTablet =
            width >= Responsive.mobileBreakpoint &&
                width < Responsive.tabletBreakpoint;

        final horizontalPadding =
        isMobile
            ? 16.0
            : isTablet
            ? 24.0
            : 32.0;

        final maxWidth =
        isMobile
            ? double.infinity
            : isTablet
            ? 850.0
            : 1000.0;

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidth,
            ),
            child: RefreshIndicator(
              onRefresh:
              orderProvider.fetchOrders,
              color: AppColors.primary,

              child: ListView.separated(
                physics:
                const AlwaysScrollableScrollPhysics(),

                padding: EdgeInsets.symmetric(
                  horizontal:
                  horizontalPadding,
                  vertical:
                  isMobile ? 16 : 24,
                ),

                itemCount:
                orderProvider.orders.length,

                separatorBuilder:
                    (_, __) => SizedBox(
                  height: isMobile ? 10 : 14,
                ),

                itemBuilder: (ctx, index) {
                  final order =
                  orderProvider.orders[index];

                  return _OrderCard(
                    order: order,
                    isMobile: isMobile,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (c) =>
                              OrderDetailsScreen(
                                orderId: order.id,
                              ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

// =============================================================================
// ORDER CARD
// =============================================================================

class _OrderCard extends StatelessWidget {
  final dynamic order;
  final bool isMobile;
  final VoidCallback onTap;

  const _OrderCard({
    required this.order,
    required this.isMobile,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
              alpha: 0.02,
            ),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Material(
        color: Colors.transparent,
        borderRadius:
        BorderRadius.circular(16),

        child: InkWell(
          borderRadius:
          BorderRadius.circular(16),
          onTap: onTap,

          child: Padding(
            padding: EdgeInsets.all(
              isMobile ? 14 : 18,
            ),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                // ----------------------------------------------------------------
                // ORDER NUMBER + STATUS
                // ----------------------------------------------------------------

                LayoutBuilder(
                  builder:
                      (context, constraints) {
                    final compact =
                        constraints.maxWidth <
                            400;

                    if (compact) {
                      return Column(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                        children: [
                          _buildOrderNumber(),

                          const SizedBox(
                            height: 8,
                          ),

                          OrderStatusBadge(
                            status: order.status,
                          ),
                        ],
                      );
                    }

                    return Row(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .center,
                      children: [
                        Expanded(
                          child:
                          _buildOrderNumber(),
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        Flexible(
                          child:
                          OrderStatusBadge(
                            status:
                            order.status,
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 9),

                // ----------------------------------------------------------------
                // DATE
                // ----------------------------------------------------------------

                Row(
                  children: [
                    const Icon(
                      Icons
                          .calendar_today_outlined,
                      size: 14,
                      color:
                      AppColors.textMuted,
                    ),

                    const SizedBox(width: 6),

                    Expanded(
                      child: Text(
                        Helpers.formatDateTime(
                          order.createdAt,
                        ),
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors
                              .textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),

                const Divider(
                  height: 22,
                ),

                // ----------------------------------------------------------------
                // BOTTOM INFO
                // ----------------------------------------------------------------

                LayoutBuilder(
                  builder:
                      (context, constraints) {
                    final compact =
                        constraints.maxWidth <
                            440;

                    if (compact) {
                      return Column(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                        children: [
                          _buildItemsCount(),
                          const SizedBox(
                            height: 8,
                          ),
                          _buildTotal(
                            showArrow: true,
                          ),
                        ],
                      );
                    }

                    return Row(
                      children: [
                        Expanded(
                          child:
                          _buildItemsCount(),
                        ),

                        const SizedBox(
                          width: 12,
                        ),

                        Flexible(
                          child:
                          _buildTotal(
                            showArrow: true,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // ORDER NUMBER
  // ===========================================================================

  Widget _buildOrderNumber() {
    return Text(
      order.orderNumber,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
        color: AppColors.textPrimary,
      ),
    );
  }

  // ===========================================================================
  // ITEM COUNT
  // ===========================================================================

  Widget _buildItemsCount() {
    return Text(
      '${order.items.length} item(s)',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 13,
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // ===========================================================================
  // TOTAL
  // ===========================================================================

  Widget _buildTotal({
    required bool showArrow,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Total: ',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),

        Flexible(
          child: Text(
            Helpers.formatPrice(
              order.totalAmount,
            ),
            maxLines: 1,
            overflow:
            TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),

        if (showArrow) ...[
          const SizedBox(width: 6),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 12,
            color: AppColors.textMuted,
          ),
        ],
      ],
    );
  }
}