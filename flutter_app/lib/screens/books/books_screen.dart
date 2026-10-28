import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_colors.dart';
import '../../providers/book_provider.dart';
import '../../widgets/book_card.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../utils/responsive.dart';
import 'search_screen.dart';

class BooksScreen extends StatefulWidget {
  final String title;
  final int? initialCategoryId;
  final String? categoryName;
  final String? sortBy;

  const BooksScreen({
    super.key,
    this.title = 'All Books',
    this.initialCategoryId,
    this.categoryName,
    this.sortBy,
  });

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  final ScrollController _scrollController =
  ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bookProvider =
      Provider.of<BookProvider>(
        context,
        listen: false,
      );

      if (widget.initialCategoryId != null) {
        bookProvider.setFilters(
          categoryId: widget.initialCategoryId,
          sortBy: widget.sortBy ?? 'created_at',
        );
      } else if (widget.sortBy != null) {
        bookProvider.setFilters(
          sortBy: widget.sortBy,
        );
      } else {
        bookProvider.fetchBooks(
          refresh: true,
        );
      }
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final bookProvider =
      Provider.of<BookProvider>(
        context,
        listen: false,
      );

      if (!bookProvider.isLoadingMore &&
          bookProvider.hasMoreBooks) {
        bookProvider.fetchBooks(
          refresh: false,
        );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ==============================================================
  // MOBILE / TABLET FILTER
  // ==============================================================

  void _showFilterBottomSheet() {
    final bookProvider =
    Provider.of<BookProvider>(
      context,
      listen: false,
    );

    int? selectedCategory =
        bookProvider.filterCategoryId;

    double? minRating =
        bookProvider.filterMinRating;

    String selectedSort =
        bookProvider.filterSortBy;

    RangeValues priceRange = RangeValues(
      bookProvider.filterMinPrice ?? 0,
      bookProvider.filterMaxPrice ?? 150,
    );

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
          builder: (
              context,
              setModalState,
              ) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom:
                  MediaQuery.of(context)
                      .viewInsets
                      .bottom +
                      24,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize:
                    MainAxisSize.min,
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                        children: [
                          const Text(
                            'Filter Books',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              bookProvider
                                  .clearFilters();
                              Navigator.pop(ctx);
                            },
                            child: const Text(
                              'Reset All',
                              style: TextStyle(
                                color:
                                AppColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const Divider(),

                      const SizedBox(
                        height: 12,
                      ),

                      // CATEGORY
                      const Text(
                        'Category',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          FilterChip(
                            label: const Text(
                              'All Categories',
                            ),
                            selected:
                            selectedCategory ==
                                null,
                            onSelected: (_) {
                              setModalState(() {
                                selectedCategory =
                                null;
                              });
                            },
                          ),

                          ...bookProvider
                              .categories
                              .map(
                                (cat) {
                              return FilterChip(
                                label:
                                Text(cat.name),
                                selected:
                                selectedCategory ==
                                    cat.id,
                                onSelected:
                                    (selected) {
                                  setModalState(() {
                                    selectedCategory =
                                    selected
                                        ? cat.id
                                        : null;
                                  });
                                },
                              );
                            },
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 18,
                      ),

                      // PRICE
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                        children: [
                          const Text(
                            'Price Range',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                          Text(
                            '\$${priceRange.start.round()} - \$${priceRange.end.round()}',
                            style:
                            const TextStyle(
                              fontWeight:
                              FontWeight.bold,
                              color:
                              AppColors.primary,
                            ),
                          ),
                        ],
                      ),

                      RangeSlider(
                        values: priceRange,
                        min: 0,
                        max: 200,
                        divisions: 20,
                        activeColor:
                        AppColors.primary,
                        onChanged: (vals) {
                          setModalState(() {
                            priceRange = vals;
                          });
                        },
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      // RATING
                      const Text(
                        'Minimum Rating',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      Wrap(
                        spacing: 8,
                        children:
                        [1, 2, 3, 4, 5]
                            .map(
                              (star) {
                            final isSelected =
                                minRating ==
                                    star.toDouble();

                            return ChoiceChip(
                              label: Row(
                                mainAxisSize:
                                MainAxisSize
                                    .min,
                                children: [
                                  const Icon(
                                    Icons
                                        .star_rounded,
                                    size: 16,
                                    color: AppColors
                                        .secondary,
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    '$star+',
                                  ),
                                ],
                              ),
                              selected:
                              isSelected,
                              onSelected:
                                  (selected) {
                                setModalState(() {
                                  minRating =
                                  selected
                                      ? star
                                      .toDouble()
                                      : null;
                                });
                              },
                            );
                          },
                        ).toList(),
                      ),

                      const SizedBox(
                        height: 18,
                      ),

                      // SORT
                      const Text(
                        'Sort By',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      DropdownButtonFormField<
                          String>(
                        initialValue:
                        selectedSort,
                        decoration:
                        const InputDecoration(
                          contentPadding:
                          EdgeInsets
                              .symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value:
                            'created_at',
                            child: Text(
                              'Newest Arrivals',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'rating',
                            child: Text(
                              'Highest Rated',
                            ),
                          ),
                          DropdownMenuItem(
                            value:
                            'price_asc',
                            child: Text(
                              'Price: Low to High',
                            ),
                          ),
                          DropdownMenuItem(
                            value:
                            'price_desc',
                            child: Text(
                              'Price: High to Low',
                            ),
                          ),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setModalState(() {
                              selectedSort =
                                  val;
                            });
                          }
                        },
                      ),

                      const SizedBox(
                        height: 24,
                      ),

                      // APPLY
                      SizedBox(
                        width:
                        double.infinity,
                        child:
                        ElevatedButton(
                          onPressed: () {
                            String sortBy =
                                selectedSort;

                            String sortOrder =
                                'desc';

                            if (selectedSort ==
                                'price_asc') {
                              sortBy = 'price';
                              sortOrder = 'asc';
                            } else if (
                            selectedSort ==
                                'price_desc') {
                              sortBy = 'price';
                              sortOrder = 'desc';
                            }

                            bookProvider
                                .setFilters(
                              categoryId:
                              selectedCategory,
                              minPrice:
                              priceRange.start >
                                  0
                                  ? priceRange
                                  .start
                                  : null,
                              maxPrice:
                              priceRange.end <
                                  200
                                  ? priceRange
                                  .end
                                  : null,
                              minRating:
                              minRating,
                              sortBy: sortBy,
                              sortOrder:
                              sortOrder,
                            );

                            Navigator.pop(ctx);
                          },
                          child: const Text(
                            'Apply Filters',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ==============================================================
  // BUILD
  // ==============================================================

  @override
  Widget build(BuildContext context) {
    final bookProvider =
    context.watch<BookProvider>();

    final displayTitle =
    widget.categoryName != null
        ? widget.categoryName!
        : widget.title;

    final isDesktop =
    Responsive.isDesktop(context);

    // ============================================================
    // DESKTOP
    // ============================================================

    if (isDesktop) {
      final desktopColumns =
      Responsive.gridColumns(
        context,
        mobile: 2,
        tablet: 3,
        desktop: 5,
      );

      return Scaffold(
        backgroundColor:
        AppColors.background,
        appBar: AppBar(
          title: Text(displayTitle),
          actions: [
            IconButton(
              tooltip: 'Search',
              icon: const Icon(
                Icons.search_rounded,
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(
                  MaterialPageRoute(
                    builder: (ctx) =>
                    const SearchScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        body: ResponsiveContainer(
          maxWidth: 1500,
          child: Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              // DESKTOP FILTER
              SizedBox(
                width: 290,
                child: SingleChildScrollView(
                  padding:
                  const EdgeInsets.all(20),
                  child:
                  _buildDesktopFilterCard(
                    bookProvider,
                  ),
                ),
              ),

              const VerticalDivider(
                width: 1,
                thickness: 1,
                color: AppColors.border,
              ),

              // DESKTOP GRID
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () =>
                      bookProvider
                          .fetchBooks(
                        refresh: true,
                      ),
                  color:
                  AppColors.primary,
                  child: _buildBody(
                    bookProvider,
                    columns:
                    desktopColumns,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // ============================================================
    // MOBILE / TABLET
    // ============================================================

    final columns =
    Responsive.gridColumns(
      context,
      mobile: 2,
      tablet: 3,
      desktop: 5,
    );

    return Scaffold(
      backgroundColor:
      AppColors.background,
      appBar: AppBar(
        title: Text(displayTitle),
        actions: [
          IconButton(
            tooltip: 'Search',
            icon: const Icon(
              Icons.search_rounded,
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (ctx) =>
                  const SearchScreen(),
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Filter',
            icon: const Icon(
              Icons.tune_rounded,
            ),
            onPressed:
            _showFilterBottomSheet,
          ),
        ],
      ),
      body: ResponsiveContainer(
        maxWidth: 1300,
        child: RefreshIndicator(
          onRefresh: () =>
              bookProvider.fetchBooks(
                refresh: true,
              ),
          color: AppColors.primary,
          child: _buildBody(
            bookProvider,
            columns: columns,
          ),
        ),
      ),
    );
  }

  // ==============================================================
  // DESKTOP FILTER CARD
  // ==============================================================

  Widget _buildDesktopFilterCard(
      BookProvider bookProvider,
      ) {
    int? selectedCategory =
        bookProvider.filterCategoryId;

    double? minRating =
        bookProvider.filterMinRating;

    String selectedSort =
        bookProvider.filterSortBy;

    RangeValues priceRange =
    RangeValues(
      bookProvider.filterMinPrice ?? 0,
      bookProvider.filterMaxPrice ?? 150,
    );

    return StatefulBuilder(
      builder: (
          context,
          setLocalState,
          ) {
        return Container(
          padding:
          const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.border,
            ),
            boxShadow: [
              BoxShadow(
                color:
                Colors.black.withValues(
                  alpha: 0.02,
                ),
                blurRadius: 8,
                offset:
                const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,
                children: [
                  const Text(
                    'Filters',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                      FontWeight.bold,
                      color: AppColors
                          .textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      bookProvider
                          .clearFilters();

                      setLocalState(() {});
                    },
                    style:
                    TextButton.styleFrom(
                      padding:
                      EdgeInsets.zero,
                      minimumSize:
                      const Size(
                        50,
                        30,
                      ),
                    ),
                    child: const Text(
                      'Reset',
                      style: TextStyle(
                        color:
                        AppColors.error,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),

              const Divider(
                height: 20,
              ),

              // CATEGORY
              const Text(
                'Category',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  FilterChip(
                    label: const Text(
                      'All',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    selected:
                    selectedCategory ==
                        null,
                    onSelected: (_) {
                      setLocalState(() {
                        selectedCategory =
                        null;
                      });
                    },
                  ),

                  ...bookProvider
                      .categories
                      .map(
                        (cat) {
                      return FilterChip(
                        label: Text(
                          cat.name,
                          style:
                          const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        selected:
                        selectedCategory ==
                            cat.id,
                        onSelected:
                            (selected) {
                          setLocalState(() {
                            selectedCategory =
                            selected
                                ? cat.id
                                : null;
                          });
                        },
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(
                height: 20,
              ),

              // PRICE
              Row(
                mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,
                children: [
                  const Text(
                    'Price Range',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                  Text(
                    '\$${priceRange.start.round()} - \$${priceRange.end.round()}',
                    style:
                    const TextStyle(
                      fontWeight:
                      FontWeight.bold,
                      fontSize: 12,
                      color:
                      AppColors.primary,
                    ),
                  ),
                ],
              ),

              RangeSlider(
                values: priceRange,
                min: 0,
                max: 200,
                divisions: 20,
                activeColor:
                AppColors.primary,
                inactiveColor:
                AppColors
                    .surfaceVariant,
                onChanged: (vals) {
                  setLocalState(() {
                    priceRange = vals;
                  });
                },
              ),

              const SizedBox(
                height: 14,
              ),

              // RATING
              const Text(
                'Minimum Rating',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              Wrap(
                spacing: 6,
                runSpacing: 6,
                children:
                [1, 2, 3, 4, 5]
                    .map(
                      (star) {
                    final isSelected =
                        minRating ==
                            star.toDouble();

                    return ChoiceChip(
                      label: Row(
                        mainAxisSize:
                        MainAxisSize
                            .min,
                        children: [
                          const Icon(
                            Icons
                                .star_rounded,
                            size: 15,
                            color: AppColors
                                .secondary,
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Text(
                            '$star+',
                            style:
                            const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      selected:
                      isSelected,
                      onSelected:
                          (selected) {
                        setLocalState(() {
                          minRating =
                          selected
                              ? star
                              .toDouble()
                              : null;
                        });
                      },
                    );
                  },
                ).toList(),
              ),

              const SizedBox(
                height: 18,
              ),

              // SORT
              const Text(
                'Sort By',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              DropdownButtonFormField<
                  String>(
                initialValue:
                selectedSort,
                decoration:
                const InputDecoration(
                  contentPadding:
                  EdgeInsets
                      .symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  isDense: true,
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'created_at',
                    child: Text(
                      'Newest Arrivals',
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'rating',
                    child: Text(
                      'Highest Rated',
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'price_asc',
                    child: Text(
                      'Price: Low to High',
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'price_desc',
                    child: Text(
                      'Price: High to Low',
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setLocalState(() {
                      selectedSort =
                          val;
                    });
                  }
                },
              ),

              const SizedBox(
                height: 20,
              ),

              // APPLY
              SizedBox(
                width:
                double.infinity,
                child:
                ElevatedButton(
                  onPressed: () {
                    String sortBy =
                        selectedSort;

                    String sortOrder =
                        'desc';

                    if (selectedSort ==
                        'price_asc') {
                      sortBy = 'price';
                      sortOrder = 'asc';
                    } else if (
                    selectedSort ==
                        'price_desc') {
                      sortBy = 'price';
                      sortOrder = 'desc';
                    }

                    bookProvider
                        .setFilters(
                      categoryId:
                      selectedCategory,
                      minPrice:
                      priceRange.start >
                          0
                          ? priceRange
                          .start
                          : null,
                      maxPrice:
                      priceRange.end <
                          200
                          ? priceRange
                          .end
                          : null,
                      minRating:
                      minRating,
                      sortBy: sortBy,
                      sortOrder:
                      sortOrder,
                    );
                  },
                  style:
                  ElevatedButton
                      .styleFrom(
                    minimumSize:
                    const Size(
                      double.infinity,
                      42,
                    ),
                  ),
                  child: const Text(
                    'Apply Filters',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ==============================================================
  // BOOK GRID
  // ==============================================================

  Widget _buildBody(
      BookProvider bookProvider, {
        required int columns,
      }) {
    if (bookProvider.isLoadingBooks &&
        bookProvider.books.isEmpty) {
      return const LoadingWidget(
        message:
        'Fetching catalog...',
      );
    }

    if (bookProvider.errorMessage !=
        null &&
        bookProvider.books.isEmpty) {
      return AppErrorWidget(
        message:
        bookProvider.errorMessage!,
        onRetry: () =>
            bookProvider.fetchBooks(
              refresh: true,
            ),
      );
    }

    if (bookProvider.books.isEmpty) {
      return EmptyStateWidget(
        title: 'No Books Found',
        message:
        'We couldn\'t find any books matching your selected filters.',
        buttonText:
        'Clear Filters',
        onButtonPressed: () =>
            bookProvider
                .clearFilters(),
      );
    }

    // IMPORTANT:
    // MediaQuery.sizeOf(context) returns Size.
    // We need only the width as double.
    final width =
        MediaQuery.sizeOf(context).width;

    final double cardAspectRatio;

    if (width <
        Responsive.mobileBreakpoint) {
      // Mobile < 600
      cardAspectRatio = 0.50;
    } else if (width < 900) {
      // Tablet 600 - 899
      cardAspectRatio = 0.54;
    } else if (width <
        Responsive.tabletBreakpoint) {
      // Tablet 900 - 1199
      cardAspectRatio = 0.56;
    } else if (width < 1600) {
      // Desktop 1200 - 1599
      cardAspectRatio = 0.58;
    } else {
      // Large Desktop >= 1600
      cardAspectRatio = 0.60;
    }

    return CustomScrollView(
      controller:
      _scrollController,
      physics:
      const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.all(
            Responsive.isMobile(
              context,
            )
                ? 16
                : 20,
          ),
          sliver: SliverGrid(
            gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
              columns,

              // Taller cards prevent
              // BookCard bottom overflow.
              childAspectRatio:
              cardAspectRatio,

              crossAxisSpacing:
              Responsive.isMobile(
                context,
              )
                  ? 12
                  : 16,

              mainAxisSpacing:
              Responsive.isMobile(
                context,
              )
                  ? 12
                  : 16,
            ),
            delegate:
            SliverChildBuilderDelegate(
                  (ctx, index) {
                return BookCard(
                  book: bookProvider
                      .books[index],
                );
              },
              childCount:
              bookProvider.books.length,
            ),
          ),
        ),

        if (bookProvider
            .isLoadingMore)
          const SliverToBoxAdapter(
            child: Padding(
              padding:
              EdgeInsets.symmetric(
                vertical: 20,
              ),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child:
                  CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color:
                    AppColors.primary,
                  ),
                ),
              ),
            ),
          ),

        const SliverToBoxAdapter(
          child: SizedBox(
            height: 30,
          ),
        ),
      ],
    );
  }
}