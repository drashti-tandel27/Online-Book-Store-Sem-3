import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_colors.dart';
import '../../models/notification.dart';
import '../../providers/notification_provider.dart';
import '../../utils/responsive.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() =>
      _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      context
          .read<NotificationProvider>()
          .fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text('Notifications'),

        actions: [
          Consumer<NotificationProvider>(
            builder: (context, provider, child) {
              if (!provider.hasUnread) {
                return const SizedBox.shrink();
              }

              return Padding(
                padding: EdgeInsets.only(
                  right: Responsive.isMobile(context) ? 4 : 12,
                ),
                child: TextButton(
                  onPressed: () {
                    provider.markAllAsRead();
                  },
                  child: const Text('Read all'),
                ),
              );
            },
          ),
        ],
      ),

      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          // -------------------------------------------------------------------
          // LOADING
          // -------------------------------------------------------------------

          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // -------------------------------------------------------------------
          // ERROR
          // -------------------------------------------------------------------

          if (provider.errorMessage != null) {
            return _buildErrorState(
              context,
              provider,
            );
          }

          // -------------------------------------------------------------------
          // EMPTY
          // -------------------------------------------------------------------

          if (provider.notifications.isEmpty) {
            return _buildEmptyState(context);
          }

          // -------------------------------------------------------------------
          // LIST
          // -------------------------------------------------------------------

          return RefreshIndicator(
            onRefresh: provider.fetchNotifications,

            child: LayoutBuilder(
              builder: (context, constraints) {
                final isMobile =
                    constraints.maxWidth <
                        Responsive.mobileBreakpoint;

                final horizontalPadding =
                isMobile ? 16.0 : 24.0;

                final maxWidth =
                constraints.maxWidth >=
                    Responsive.tabletBreakpoint
                    ? 950.0
                    : 760.0;

                return ListView.separated(
                  physics:
                  const AlwaysScrollableScrollPhysics(),

                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: isMobile ? 16 : 24,
                  ),

                  itemCount:
                  provider.notifications.length,

                  separatorBuilder: (_, __) =>
                      SizedBox(
                        height: isMobile ? 10 : 12,
                      ),

                  itemBuilder: (context, index) {
                    final notification =
                    provider.notifications[index];

                    return Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: maxWidth,
                        ),
                        child: _NotificationCard(
                          notification: notification,

                          onTap: () {
                            if (!notification.isRead) {
                              provider.markAsRead(
                                notification.id,
                              );
                            }
                          },

                          onDelete: () {
                            provider.deleteNotification(
                              notification.id,
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  // ===========================================================================
  // ERROR STATE
  // ===========================================================================

  Widget _buildErrorState(
      BuildContext context,
      NotificationProvider provider,
      ) {
    final isMobile = Responsive.isMobile(context);

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(
          isMobile ? 24 : 40,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 520,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: isMobile ? 72 : 82,
                height: isMobile ? 72 : 82,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(
                    alpha: 0.08,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline,
                  size: isMobile ? 42 : 48,
                  color: AppColors.error,
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                'Something went wrong',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                provider.errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                height: 44,
                child: ElevatedButton.icon(
                  onPressed: () {
                    provider.fetchNotifications();
                  },
                  icon: const Icon(
                    Icons.refresh_rounded,
                    size: 18,
                  ),
                  label: const Text('Retry'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // EMPTY STATE
  // ===========================================================================

  Widget _buildEmptyState(
      BuildContext context,
      ) {
    final isMobile = Responsive.isMobile(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(
          isMobile ? 24 : 40,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 500,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: isMobile ? 90 : 105,
                height: isMobile ? 90 : 105,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(
                    alpha: 0.08,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_none_rounded,
                  size: isMobile ? 52 : 60,
                  color: AppColors.textMuted,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'No notifications',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 7),

              const Text(
                'You are all caught up!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// NOTIFICATION CARD
// =============================================================================

class _NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _NotificationCard({
    required this.notification,
    required this.onTap,
    required this.onDelete,
  });

  IconData _getIcon() {
    switch (notification.type) {
      case 'order':
        return Icons.shopping_bag_outlined;

      case 'offer':
        return Icons.local_offer_outlined;

      case 'wishlist':
        return Icons.favorite_border_rounded;

      default:
        return Icons.notifications_none_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact =
            constraints.maxWidth < 420;

        final cardPadding =
        isCompact ? 13.0 : 16.0;

        final iconSize =
        isCompact ? 42.0 : 46.0;

        return Dismissible(
          key: ValueKey(notification.id),

          direction:
          DismissDirection.endToStart,

          onDismissed: (_) {
            onDelete();
          },

          background: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(
              right: isCompact ? 16 : 20,
            ),
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius:
              BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.delete_outline,
              color: Colors.white,
            ),
          ),

          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius:
              BorderRadius.circular(16),

              child: Container(
                padding: EdgeInsets.all(
                  cardPadding,
                ),

                decoration: BoxDecoration(
                  color: notification.isRead
                      ? AppColors.cardBg
                      : AppColors.primary
                      .withValues(alpha: 0.06),

                  borderRadius:
                  BorderRadius.circular(16),

                  border: Border.all(
                    color: notification.isRead
                        ? AppColors.border
                        : AppColors.primary
                        .withValues(alpha: 0.3),
                  ),
                ),

                child: Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [
                    // ----------------------------------------------------------
                    // ICON
                    // ----------------------------------------------------------

                    Container(
                      width: iconSize,
                      height: iconSize,

                      decoration: BoxDecoration(
                        color: AppColors.primary
                            .withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),

                      child: Icon(
                        _getIcon(),
                        color: AppColors.primary,
                        size: isCompact ? 21 : 24,
                      ),
                    ),

                    SizedBox(
                      width: isCompact ? 11 : 14,
                    ),

                    // ----------------------------------------------------------
                    // CONTENT
                    // ----------------------------------------------------------

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          // ----------------------------------------------------
                          // TITLE + UNREAD DOT
                          // ----------------------------------------------------

                          Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  notification.title,
                                  maxLines: 2,
                                  overflow:
                                  TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize:
                                    isCompact
                                        ? 14
                                        : 15,
                                    fontWeight:
                                    FontWeight.bold,
                                    color: AppColors
                                        .textPrimary,
                                  ),
                                ),
                              ),

                              if (!notification.isRead) ...[
                                const SizedBox(width: 8),

                                Container(
                                  width: 8,
                                  height: 8,
                                  margin:
                                  const EdgeInsets
                                      .only(
                                    top: 5,
                                  ),
                                  decoration:
                                  const BoxDecoration(
                                    color:
                                    AppColors.primary,
                                    shape:
                                    BoxShape.circle,
                                  ),
                                ),
                              ],
                            ],
                          ),

                          const SizedBox(height: 5),

                          // ----------------------------------------------------
                          // MESSAGE
                          // ----------------------------------------------------

                          Text(
                            notification.message,
                            maxLines: isCompact ? 4 : 5,
                            overflow:
                            TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize:
                              isCompact ? 12.5 : 13,
                              height: 1.45,
                              color:
                              AppColors.textSecondary,
                            ),
                          ),

                          // ----------------------------------------------------
                          // DATE
                          // ----------------------------------------------------

                          if (notification.createdAt !=
                              null) ...[
                            const SizedBox(height: 8),

                            Text(
                              _formatDate(
                                notification.createdAt!,
                              ),
                              style: const TextStyle(
                                fontSize: 11,
                                color:
                                AppColors.textMuted,
                              ),
                            ),
                          ],
                        ],
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
  }

  // ===========================================================================
  // DATE
  // ===========================================================================

  String _formatDate(String value) {
    try {
      final date = DateTime.parse(value);

      return '${date.day.toString().padLeft(2, '0')}/'
          '${date.month.toString().padLeft(2, '0')}/'
          '${date.year}';
    } catch (_) {
      return value;
    }
  }
}