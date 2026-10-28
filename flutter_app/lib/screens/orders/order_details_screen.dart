import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/api_config.dart';
import '../../config/app_colors.dart';
import '../../models/order.dart';
import '../../providers/order_provider.dart';
import '../../utils/helpers.dart';
import '../../utils/responsive.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/order_status_widget.dart';
import '../books/book_details_screen.dart';

class OrderDetailsScreen extends StatefulWidget {
  final int orderId;

  const OrderDetailsScreen({
    super.key,
    required this.orderId,
  });

  @override
  State<OrderDetailsScreen> createState() =>
      _OrderDetailsScreenState();
}

class _OrderDetailsScreenState
    extends State<OrderDetailsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderProvider>(
        context,
        listen: false,
      ).fetchOrderDetails(widget.orderId);
    });
  }

  // ===========================================================================
  // CANCEL ORDER
  // ===========================================================================

  Future<void> _handleCancelOrder(Order order) async {
    final reasonController =
    TextEditingController();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Cancel Order',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 460,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  'Are you sure you want to cancel this order? This action cannot be undone.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: reasonController,
                  maxLines: 3,
                  textInputAction:
                  TextInputAction.done,
                  decoration:
                  const InputDecoration(
                    hintText:
                    'Reason for cancellation (optional)',
                    alignLabelWithHint: true,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(ctx, false),
            child: const Text('Keep Order'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              minimumSize:
              const Size(100, 38),
            ),
            onPressed: () =>
                Navigator.pop(ctx, true),
            child: const Text('Cancel Order'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      final orderProvider =
      Provider.of<OrderProvider>(
        context,
        listen: false,
      );

      final success =
      await orderProvider.cancelOrder(
        order.id,
        reason: reasonController.text.trim(),
      );

      reasonController.dispose();

      if (!mounted) return;

      if (success) {
        Helpers.showSnackBar(
          context,
          'Order #${order.orderNumber} cancelled.',
          isSuccess: true,
        );
      } else if (orderProvider.errorMessage != null) {
        Helpers.showSnackBar(
          context,
          orderProvider.errorMessage!,
          isError: true,
        );
      }
    } else {
      reasonController.dispose();
    }
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final orderProvider =
    context.watch<OrderProvider>();

    if (orderProvider.isLoadingDetails &&
        orderProvider.activeOrder?.id !=
            widget.orderId) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Order Details'),
        ),
        body: const LoadingWidget(
          message:
          'Loading order details...',
        ),
      );
    }

    final order = orderProvider.activeOrder;

    if (order == null ||
        order.id != widget.orderId) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Order Details'),
        ),
        body: AppErrorWidget(
          message: orderProvider.errorMessage ??
              'Order details not found.',
          onRetry: () {
            orderProvider.fetchOrderDetails(
              widget.orderId,
            );
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: Text(
          order.orderNumber,
          overflow: TextOverflow.ellipsis,
        ),
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          final isMobile =
              width < Responsive.mobileBreakpoint;

          final isTablet =
              width >= Responsive.mobileBreakpoint &&
                  width < Responsive.tabletBreakpoint;

          final maxWidth =
          isMobile
              ? double.infinity
              : isTablet
              ? 900.0
              : 1200.0;

          final horizontalPadding =
          isMobile
              ? 16.0
              : isTablet
              ? 24.0
              : 32.0;

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxWidth,
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal:
                  horizontalPadding,
                  vertical:
                  isMobile ? 16 : 24,
                ),
                child: isMobile
                    ? _buildMobileLayout(
                  context,
                  order,
                  orderProvider,
                )
                    : _buildWideLayout(
                  context,
                  order,
                  orderProvider,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ===========================================================================
  // MOBILE
  // ===========================================================================

  Widget _buildMobileLayout(
      BuildContext context,
      Order order,
      OrderProvider orderProvider,
      ) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.stretch,
      children: [
        _buildStatusCard(
          context,
          order,
          compact: true,
        ),

        const SizedBox(height: 16),

        _buildItemsCard(
          context,
          order,
          compact: true,
        ),

        const SizedBox(height: 16),

        _buildDeliveryCard(
          context,
          order,
        ),

        const SizedBox(height: 16),

        _buildPaymentCard(
          context,
          order,
        ),

        const SizedBox(height: 24),

        if (order.canCancel)
          _buildCancelButton(
            context,
            order,
            orderProvider,
            fullWidth: true,
          ),
      ],
    );
  }

  // ===========================================================================
  // TABLET / DESKTOP
  // ===========================================================================

  Widget _buildWideLayout(
      BuildContext context,
      Order order,
      OrderProvider orderProvider,
      ) {
    final isDesktop =
    Responsive.isDesktop(context);

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.stretch,
      children: [
        _buildStatusCard(
          context,
          order,
          compact: false,
        ),

        const SizedBox(height: 20),

        if (isDesktop)
          Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: _buildItemsCard(
                  context,
                  order,
                  compact: false,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    _buildDeliveryCard(
                      context,
                      order,
                    ),
                    const SizedBox(height: 20),
                    _buildPaymentCard(
                      context,
                      order,
                    ),
                  ],
                ),
              ),
            ],
          )
        else
          Column(
            children: [
              _buildItemsCard(
                context,
                order,
                compact: false,
              ),
              const SizedBox(height: 20),
              _buildDeliveryCard(
                context,
                order,
              ),
              const SizedBox(height: 20),
              _buildPaymentCard(
                context,
                order,
              ),
            ],
          ),

        const SizedBox(height: 28),

        if (order.canCancel)
          _buildCancelButton(
            context,
            order,
            orderProvider,
            fullWidth: false,
          ),
      ],
    );
  }

  // ===========================================================================
  // STATUS CARD
  // ===========================================================================

  Widget _buildStatusCard(
      BuildContext context,
      Order order, {
        required bool compact,
      }) {
    return _buildCard(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final narrow =
                  constraints.maxWidth < 430;

              if (narrow) {
                return Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    _buildStatusInfo(order),
                    const SizedBox(height: 12),
                    _buildPlacedDate(order),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(
                    child:
                    _buildStatusInfo(order),
                  ),
                  const SizedBox(width: 16),
                  _buildPlacedDate(order),
                ],
              );
            },
          ),

          const Divider(height: 28),

          const Text(
            'Tracking Timeline',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 16),

          OrderProgressStepper(
            currentStatus: order.status,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusInfo(Order order) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        const Text(
          'Order Status',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 5),
        OrderStatusBadge(
          status: order.status,
          fontSize: 13,
        ),
      ],
    );
  }

  Widget _buildPlacedDate(Order order) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.end,
      children: [
        const Text(
          'Placed on',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          Helpers.formatDate(
            order.createdAt,
          ),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // ORDER ITEMS
  // ===========================================================================

  Widget _buildItemsCard(
      BuildContext context,
      Order order, {
        required bool compact,
      }) {
    return _buildCard(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            'Order Items (${order.items.length})',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 14),

          ...order.items.map(
                (item) => _buildOrderItem(
              context,
              item,
              compact: compact,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(
      BuildContext context,
      dynamic item, {
        required bool compact,
      }) {
    final imageUrl =
        item.bookImage ??
            item.book?.imageUrl;

    final title =
        item.bookTitle ??
            item.book?.title ??
            'Book #${item.bookId}';

    return Padding(
      padding:
      const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius:
          BorderRadius.circular(10),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (c) =>
                    BookDetailsScreen(
                      bookId: item.bookId,
                    ),
              ),
            );
          },
          child: Padding(
            padding:
            const EdgeInsets.symmetric(
              vertical: 4,
            ),
            child: LayoutBuilder(
              builder:
                  (context, constraints) {
                final narrow =
                    constraints.maxWidth < 390;

                final imageWidth =
                narrow ? 52.0 : 58.0;
                final imageHeight =
                narrow ? 74.0 : 82.0;

                return Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius:
                      BorderRadius.circular(8),
                      child: Container(
                        width: imageWidth,
                        height: imageHeight,
                        color:
                        AppColors.surfaceVariant,
                        child:
                        _buildThumbnail(
                          imageUrl,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                        children: [
                          Text(
                            title,
                            maxLines: 2,
                            overflow:
                            TextOverflow
                                .ellipsis,
                            style:
                            const TextStyle(
                              fontWeight:
                              FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),

                          const SizedBox(
                            height: 5,
                          ),

                          Text(
                            'Qty: ${item.quantity} × ${Helpers.formatPrice(item.price)}',
                            maxLines: 2,
                            overflow:
                            TextOverflow
                                .ellipsis,
                            style:
                            const TextStyle(
                              fontSize: 12,
                              color: AppColors
                                  .textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    ConstrainedBox(
                      constraints:
                      const BoxConstraints(
                        maxWidth: 105,
                      ),
                      child: Text(
                        Helpers.formatPrice(
                          item.subtotal,
                        ),
                        maxLines: 1,
                        overflow:
                        TextOverflow
                            .ellipsis,
                        textAlign:
                        TextAlign.end,
                        style:
                        const TextStyle(
                          fontWeight:
                          FontWeight.bold,
                          fontSize: 14,
                          color:
                          AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // DELIVERY CARD
  // ===========================================================================

  Widget _buildDeliveryCard(
      BuildContext context,
      Order order,
      ) {
    return _buildCard(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Text(
            'Delivery & Payment',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 14),

          _buildDetailRow(
            Icons.person_outline_rounded,
            'Recipient',
            order.recipientName ??
                'Customer',
          ),

          const SizedBox(height: 10),

          if (order.recipientPhone != null &&
              order.recipientPhone!.isNotEmpty) ...[
            _buildDetailRow(
              Icons.phone_outlined,
              'Phone',
              order.recipientPhone!,
            ),
            const SizedBox(height: 10),
          ],

          _buildDetailRow(
            Icons.location_on_outlined,
            'Address',
            order.shippingAddress,
          ),

          const SizedBox(height: 10),

          _buildDetailRow(
            Icons.payment_outlined,
            'Payment',
            '${order.paymentMethod} (${order.paymentStatus ?? "Pending"})',
          ),

          if (order.notes != null &&
              order.notes!.isNotEmpty) ...[
            const SizedBox(height: 10),
            _buildDetailRow(
              Icons.note_outlined,
              'Notes',
              order.notes!,
            ),
          ],
        ],
      ),
    );
  }

  // ===========================================================================
  // PAYMENT CARD
  // ===========================================================================

  Widget _buildPaymentCard(
      BuildContext context,
      Order order,
      ) {
    return _buildCard(
      child: Column(
        children: [
          _buildPriceRow(
            'Subtotal',
            Helpers.formatPrice(
              order.subtotal,
            ),
          ),

          const SizedBox(height: 9),

          _buildPriceRow(
            'Shipping Fee',
            order.shippingFee == 0
                ? 'FREE'
                : Helpers.formatPrice(
              order.shippingFee,
            ),
          ),

          const SizedBox(height: 9),

          _buildPriceRow(
            'Tax',
            Helpers.formatPrice(
              order.tax,
            ),
          ),

          const Divider(height: 26),

          _buildPriceRow(
            'Total Paid',
            Helpers.formatPrice(
              order.totalAmount,
            ),
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
      String label,
      String value, {
        bool isTotal = false,
      }) {
    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: isTotal
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
              fontSize:
              isTotal ? 16 : 13,
              fontWeight: isTotal
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ),

        const SizedBox(width: 12),

        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow:
            TextOverflow.ellipsis,
            style: TextStyle(
              fontSize:
              isTotal ? 19 : 13,
              fontWeight: FontWeight.bold,
              color: isTotal
                  ? AppColors.primary
                  : AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // DETAIL ROW
  // ===========================================================================

  Widget _buildDetailRow(
      IconData icon,
      String label,
      String value,
      ) {
    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: AppColors.textSecondary,
        ),

        const SizedBox(width: 10),

        SizedBox(
          width: 70,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: Text(
            value,
            softWrap: true,
            style: const TextStyle(
              fontSize: 13,
              height: 1.4,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // CANCEL BUTTON
  // ===========================================================================

  Widget _buildCancelButton(
      BuildContext context,
      Order order,
      OrderProvider orderProvider, {
        required bool fullWidth,
      }) {
    return Align(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth:
          fullWidth ? double.infinity : 360,
        ),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: CustomButton(
            text: 'Cancel Order',
            isOutlined: true,
            backgroundColor:
            AppColors.error,
            textColor: AppColors.error,
            isLoading:
            orderProvider.isCancelling,
            onPressed: () =>
                _handleCancelOrder(order),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // CARD
  // ===========================================================================

  Widget _buildCard({
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
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
      child: child,
    );
  }

  // ===========================================================================
  // THUMBNAIL
  // ===========================================================================

  Widget _buildThumbnail(String? url) {
    final resolvedUrl =
    ApiConfig.resolveImageUrl(url);

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
      errorBuilder:
          (context, error, stackTrace) =>
      const Center(
        child: Icon(
          Icons.menu_book_rounded,
          color: AppColors.textMuted,
        ),
      ),
    );
  }
}