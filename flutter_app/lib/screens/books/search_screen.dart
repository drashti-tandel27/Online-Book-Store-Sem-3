import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_colors.dart';
import '../../providers/book_provider.dart';
import '../../utils/helpers.dart';
import '../../utils/responsive.dart';
import '../../widgets/book_card.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/search_bar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController =
  TextEditingController();

  final Debouncer _debouncer = Debouncer(
    delay: const Duration(milliseconds: 350),
  );

  static const List<String> _suggestedTopics = [
    'Fiction',
    'Self-Help',
    'Technology',
    'Science',
    'Mystery',
    'Psychology',
    'History',
    'Finance',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debouncer.run(() {
      Provider.of<BookProvider>(
        context,
        listen: false,
      ).search(query);
    });
  }

  void _searchTopic(String topic) {
    _searchController.text = topic;

    Provider.of<BookProvider>(
      context,
      listen: false,
    ).search(topic);
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = context.watch<BookProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: BookstoreSearchBar(
            controller: _searchController,
            autofocus: true,
            hintText: 'Search title, author, category...',
            onChanged: _onSearchChanged,
          ),
        ),
      ),

      body: _buildContent(bookProvider),
    );
  }

  Widget _buildContent(BookProvider bookProvider) {
    if (bookProvider.isSearching) {
      return const LoadingWidget(
        message: 'Searching catalog...',
      );
    }

    // ============================================================
    // EMPTY SEARCH
    // ============================================================
    if (_searchController.text.trim().isEmpty) {
      return SingleChildScrollView(
        padding: Responsive.horizontalPadding(context).copyWith(
          top: 20,
          bottom: 30,
        ),
        child: ResponsiveContainer(
          maxWidth: 1200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Trending Topics',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 10,
                children: _suggestedTopics.map((topic) {
                  return ActionChip(
                    label: Text(topic),
                    avatar: const Icon(
                      Icons.trending_up,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    backgroundColor: AppColors.surface,
                    side: const BorderSide(
                      color: AppColors.border,
                    ),
                    labelStyle: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    onPressed: () => _searchTopic(topic),
                  );
                }).toList(),
              ),

              const SizedBox(height: 32),

              const Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.search_rounded,
                      size: 64,
                      color: AppColors.border,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Search over thousands of titles',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    // ============================================================
    // NO RESULTS
    // ============================================================
    if (bookProvider.searchResults.isEmpty) {
      return EmptyStateWidget(
        title: 'No Matching Books',
        message:
        'We could not find any books matching "${_searchController.text}". Try another query.',
        icon: Icons.search_off_rounded,
      );
    }

    // ============================================================
    // RESPONSIVE SEARCH RESULTS
    // ============================================================

    final columns = Responsive.gridColumns(
      context,
      mobile: 2,
      tablet: 3,
      desktop: 5,
    );

    return CustomScrollView(
      slivers: [
        // ----------------------------------------------------------
        // RESULT COUNT
        // ----------------------------------------------------------
        SliverToBoxAdapter(
          child: ResponsiveContainer(
            maxWidth: 1400,
            padding: EdgeInsets.fromLTRB(
              Responsive.isMobile(context) ? 16 : 24,
              16,
              Responsive.isMobile(context) ? 16 : 24,
              8,
            ),
            child: Text(
              'Found ${bookProvider.searchResults.length} result(s)',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),

        // ----------------------------------------------------------
        // RESPONSIVE GRID
        // ----------------------------------------------------------
        SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.isMobile(context) ? 16 : 24,
            vertical: 8,
          ),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,

              // IMPORTANT:
              // Old value = 0.58
              // New value = 0.72
              // This prevents very tall cards.
              childAspectRatio: 0.72,

              crossAxisSpacing:
              Responsive.isMobile(context) ? 12 : 16,

              mainAxisSpacing:
              Responsive.isMobile(context) ? 12 : 16,
            ),

            delegate: SliverChildBuilderDelegate(
                  (ctx, index) {
                return BookCard(
                  book: bookProvider.searchResults[index],
                );
              },
              childCount: bookProvider.searchResults.length,
            ),
          ),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(height: 30),
        ),
      ],
    );
  }
}