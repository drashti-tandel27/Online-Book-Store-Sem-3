import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/book_provider.dart';
import '../../utils/responsive.dart';
import '../../widgets/book_card.dart';
import '../../widgets/category_card.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/search_bar.dart';
import '../books/books_screen.dart';
import '../categories/categories_screen.dart';
import '../notifications/notification_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bookProvider =
      Provider.of<BookProvider>(context, listen: false);

      if (bookProvider.popularBooks.isEmpty) {
        bookProvider.fetchHomeData();
      }
    });
  }

  Future<void> _refresh() async {
    await Provider.of<BookProvider>(
      context,
      listen: false,
    ).fetchHomeData();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final bookProvider = context.watch<BookProvider>();

    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    final isDesktop = Responsive.isDesktop(context);

    final screenWidth = MediaQuery.sizeOf(context).width;

    final columns = Responsive.gridColumns(
      context,
      mobile: 2,
      tablet: 3,
      desktop: 5,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          color: AppColors.primary,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // ===================================================
              // HEADER
              // ===================================================
              SliverToBoxAdapter(
                child: ResponsiveContainer(
                  maxWidth: 1400,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      isMobile
                          ? 16
                          : isTablet
                          ? 24
                          : 32,
                      isMobile
                          ? 14
                          : isTablet
                          ? 18
                          : 24,
                      isMobile
                          ? 16
                          : isTablet
                          ? 24
                          : 32,
                      10,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                auth.isAuthenticated
                                    ? 'Hello, ${auth.user?.name.split(' ').first ?? 'Reader'} 👋'
                                    : 'Welcome to BookStore 👋',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: isDesktop
                                      ? 24
                                      : isTablet
                                      ? 21
                                      : 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'What do you want to read today?',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: isDesktop ? 14 : 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        _buildNotificationButton(context),
                      ],
                    ),
                  ),
                ),
              ),

              // ===================================================
              // SEARCH
              // ===================================================
              SliverToBoxAdapter(
                child: ResponsiveContainer(
                  maxWidth: 900,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile
                          ? 16
                          : isTablet
                          ? 24
                          : 32,
                      vertical: 6,
                    ),
                    child: const BookstoreSearchBar(
                      readOnly: true,
                    ),
                  ),
                ),
              ),

              // ===================================================
              // LOADING / ERROR
              // ===================================================
              if (bookProvider.isLoadingHome &&
                  bookProvider.popularBooks.isEmpty)
                const SliverFillRemaining(
                  child: LoadingWidget(
                    message: 'Loading bookstore treasures...',
                  ),
                )
              else if (bookProvider.errorMessage != null &&
                  bookProvider.popularBooks.isEmpty)
                SliverFillRemaining(
                  child: AppErrorWidget(
                    message: bookProvider.errorMessage!,
                    onRetry: _refresh,
                  ),
                )
              else ...[
                  // =================================================
                  // PROMO BANNER
                  // =================================================
                  SliverToBoxAdapter(
                    child: ResponsiveContainer(
                      maxWidth: 1400,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          isMobile
                              ? 16
                              : isTablet
                              ? 24
                              : 32,
                          16,
                          isMobile
                              ? 16
                              : isTablet
                              ? 24
                              : 32,
                          10,
                        ),
                        child: _buildPromoBanner(context),
                      ),
                    ),
                  ),

                  // =================================================
                  // CATEGORIES
                  // =================================================
                  if (bookProvider.categories.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: _buildSectionHeader(
                        context,
                        title: 'Explore Categories',
                        onSeeAll: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                              const CategoriesScreen(),
                            ),
                          );
                        },
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: isMobile ? 58 : 68,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile
                                ? 16
                                : isTablet
                                ? 24
                                : 32,
                          ),
                          itemCount:
                          bookProvider.categories.length,
                          separatorBuilder: (_, __) =>
                          const SizedBox(width: 10),
                          itemBuilder: (ctx, index) {
                            return CategoryCard(
                              category:
                              bookProvider.categories[index],
                            );
                          },
                        ),
                      ),
                    ),
                  ],

                  // =================================================
                  // POPULAR BOOKS
                  // =================================================
                  if (bookProvider.popularBooks.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: _buildSectionHeader(
                        context,
                        title: 'Popular Books',
                        onSeeAll: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const BooksScreen(
                                title: 'Popular Books',
                                sortBy: 'rating',
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    _buildBookSection(
                      context,
                      books: bookProvider.popularBooks,
                      columns: columns,
                      isDesktop: isDesktop,
                    ),
                  ],

                  // =================================================
                  // LATEST ARRIVALS
                  // =================================================
                  if (bookProvider.latestBooks.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: _buildSectionHeader(
                        context,
                        title: 'Latest Arrivals',
                        onSeeAll: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const BooksScreen(
                                title: 'Latest Books',
                                sortBy: 'created_at',
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    _buildBookSection(
                      context,
                      books: bookProvider.latestBooks,
                      columns: columns,
                      isDesktop: isDesktop,
                    ),
                  ],

                  // =================================================
                  // RECOMMENDED
                  // =================================================
                  if (bookProvider.recommendedBooks.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: _buildSectionHeader(
                        context,
                        title: 'Recommended For You',
                        onSeeAll: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const BooksScreen(
                                title: 'Recommended Books',
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        isMobile
                            ? 16
                            : isTablet
                            ? 24
                            : 32,
                        6,
                        isMobile
                            ? 16
                            : isTablet
                            ? 24
                            : 32,
                        24,
                      ),
                      sliver: SliverGrid(
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing:
                          isMobile ? 12 : 16,
                          mainAxisSpacing:
                          isMobile ? 12 : 24,

                          // Responsive fixed height.
                          //
                          // Mobile  : 300
                          // Tablet  : 360
                          // Desktop : 480
                          // Wide    : 520
                          mainAxisExtent: isMobile
                              ? 300
                              : isTablet
                              ? 360
                              : screenWidth >= 1600
                              ? 520
                              : 480,
                        ),
                        delegate: SliverChildBuilderDelegate(
                              (ctx, index) {
                            return BookCard(
                              book: bookProvider
                                  .recommendedBooks[index],
                            );
                          },
                          childCount:
                          bookProvider.recommendedBooks.length >
                              columns * 2
                              ? columns * 2
                              : bookProvider
                              .recommendedBooks.length,
                        ),
                      ),
                    ),
                  ],

                  const SliverToBoxAdapter(
                    child: SizedBox(height: 40),
                  ),
                ],
            ],
          ),
        ),
      ),
    );
  }

  // =============================================================
  // NOTIFICATION BUTTON
  // =============================================================

  Widget _buildNotificationButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: IconButton(
        tooltip: 'Notifications',
        icon: const Icon(
          Icons.notifications_none_rounded,
          color: AppColors.textPrimary,
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const NotificationScreen(),
            ),
          );
        },
      ),
    );
  }

  // =============================================================
  // BOOK SECTION
  // =============================================================

  Widget _buildBookSection(
      BuildContext context, {
        required List books,
        required int columns,
        required bool isDesktop,
      }) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    final screenWidth = MediaQuery.sizeOf(context).width;

    // ===========================================================
    // MOBILE
    // ===========================================================

    if (isMobile) {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: 310,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              16,
              4,
              16,
              8,
            ),
            itemCount: books.length,
            separatorBuilder: (_, __) =>
            const SizedBox(width: 12),
            itemBuilder: (ctx, index) {
              return SizedBox(
                width: 155,
                child: BookCard(
                  book: books[index],
                  isHorizontal: true,
                ),
              );
            },
          ),
        ),
      );
    }

    // ===========================================================
    // TABLET
    // ===========================================================

    if (isTablet) {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: 325,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              24,
              4,
              24,
              8,
            ),
            itemCount: books.length,
            separatorBuilder: (_, __) =>
            const SizedBox(width: 14),
            itemBuilder: (ctx, index) {
              return SizedBox(
                width: 175,
                child: BookCard(
                  book: books[index],
                  isHorizontal: true,
                ),
              );
            },
          ),
        ),
      );
    }

    // ===========================================================
    // DESKTOP
    // ===========================================================

    final displayCount =
    books.length > columns ? columns : books.length;

    if (displayCount == 0) {
      return const SliverToBoxAdapter(
        child: SizedBox.shrink(),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        32,
        6,
        32,
        28,
      ),
      sliver: SliverGrid(
        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: displayCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 28,

          // =====================================================
          // RESPONSIVE DESKTOP CARD HEIGHT
          // =====================================================

          // 1200 - 1599 : 480
          // 1600+       : 520
          mainAxisExtent:
          screenWidth >= 1600 ? 520 : 480,
        ),
        delegate: SliverChildBuilderDelegate(
              (ctx, index) {
            return BookCard(
              book: books[index],
            );
          },
          childCount: displayCount,
        ),
      ),
    );
  }

  // =============================================================
  // PROMO BANNER
  // =============================================================

  Widget _buildPromoBanner(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    final isDesktop = Responsive.isDesktop(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
        isMobile
            ? 16
            : isTablet
            ? 20
            : 24,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primary,
            Color(0xFF1E40AF),
            Color(0xFF3B82F6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(
          isMobile ? 16 : 20,
        ),
        boxShadow: [
          BoxShadow(
            color:
            AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius:
                    BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'SPECIAL OFFER',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

                const SizedBox(height: 9),

                Text(
                  'Enjoy Up to 40% Off',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isDesktop
                        ? 24
                        : isTablet
                        ? 22
                        : 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'On top bestselling fiction & non-fiction',
                  maxLines: isMobile ? 2 : 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 13),

                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const BooksScreen(
                          title: 'Sale & Offers',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor:
                    AppColors.primary,
                    minimumSize:
                    const Size(120, 36),
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Explore Now',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          Icon(
            Icons.auto_stories_rounded,
            size: isMobile
                ? 58
                : isTablet
                ? 72
                : 90,
            color: Colors.white24,
          ),
        ],
      ),
    );
  }

  // =============================================================
  // SECTION HEADER
  // =============================================================

  Widget _buildSectionHeader(
      BuildContext context, {
        required String title,
        required VoidCallback onSeeAll,
      }) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        isMobile
            ? 16
            : isTablet
            ? 24
            : 32,
        20,
        isMobile
            ? 16
            : isTablet
            ? 24
            : 32,
        10,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: isMobile
                    ? 18
                    : isTablet
                    ? 19
                    : 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
          ),

          const SizedBox(width: 12),

          GestureDetector(
            onTap: onSeeAll,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}