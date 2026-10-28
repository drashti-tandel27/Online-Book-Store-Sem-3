import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../screens/books/search_screen.dart';
import '../utils/responsive.dart';

class BookstoreSearchBar extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onFilterTap;
  final bool readOnly;
  final bool autofocus;

  const BookstoreSearchBar({
    super.key,
    this.controller,
    this.hintText = "Search by title, author, category...",
    this.onChanged,
    this.onSubmitted,
    this.onFilterTap,
    this.readOnly = false,
    this.autofocus = false,
  });

  @override
  State<BookstoreSearchBar> createState() => _BookstoreSearchBarState();
}

class _BookstoreSearchBarState extends State<BookstoreSearchBar> {
  late final TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? TextEditingController();
    _hasText = _controller.text.isNotEmpty;

    _controller.addListener(_handleTextChange);
  }

  void _handleTextChange() {
    final hasText = _controller.text.isNotEmpty;

    if (hasText != _hasText && mounted) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_handleTextChange);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    final isDesktop = Responsive.isDesktop(context);

    final height = Responsive.value<double>(
      context,
      mobile: 48,
      tablet: 50,
      desktop: 52,
    );

    final horizontalPadding = Responsive.value<double>(
      context,
      mobile: 14,
      tablet: 16,
      desktop: 18,
    );

    final iconSize = Responsive.value<double>(
      context,
      mobile: 21,
      tablet: 22,
      desktop: 23,
    );

    Widget searchBar = Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 12 : 14,
        ),
        border: Border.all(
          color: AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: isDesktop ? 8 : 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: widget.readOnly
          ? _buildReadOnlyContent(
        context,
        horizontalPadding,
        iconSize,
        isMobile,
      )
          : _buildTextField(
        context,
        horizontalPadding,
        iconSize,
        isMobile,
        isTablet,
      ),
    );

    // Desktop પર search bar ને unnecessarily આખી width
    // લેવા દેતા નથી.
    if (isDesktop) {
      return ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 720,
        ),
        child: searchBar,
      );
    }

    return searchBar;
  }

  Widget _buildReadOnlyContent(
      BuildContext context,
      double horizontalPadding,
      double iconSize,
      bool isMobile,
      ) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => const SearchScreen(),
          ),
        );
      },
      borderRadius: BorderRadius.circular(
        isMobile ? 12 : 14,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
        ),
        child: Row(
          children: [
            Icon(
              Icons.search_rounded,
              color: AppColors.primary,
              size: iconSize,
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                widget.hintText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: isMobile ? 13 : 14,
                ),
              ),
            ),

            const SizedBox(width: 8),

            if (widget.onFilterTap != null)
              _buildFilterButton(
                onTap: widget.onFilterTap!,
                isMobile: isMobile,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      BuildContext context,
      double horizontalPadding,
      double iconSize,
      bool isMobile,
      bool isTablet,
      ) {
    return TextField(
      controller: _controller,
      autofocus: widget.autofocus,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      textInputAction: TextInputAction.search,
      maxLines: 1,
      style: TextStyle(
        color: AppColors.textPrimary,
        fontSize: isMobile ? 14 : 15,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: AppColors.textMuted,
          fontSize: isMobile ? 13 : 14,
        ),
        filled: false,

        contentPadding: EdgeInsets.symmetric(
          vertical: isMobile ? 11 : 12,
        ),

        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,

        prefixIcon: Padding(
          padding: EdgeInsets.only(
            left: horizontalPadding,
            right: 8,
          ),
          child: Icon(
            Icons.search_rounded,
            color: AppColors.primary,
            size: iconSize,
          ),
        ),

        prefixIconConstraints: const BoxConstraints(
          minWidth: 0,
          minHeight: 0,
        ),

        suffixIconConstraints: const BoxConstraints(
          minWidth: 0,
          minHeight: 0,
        ),

        suffixIcon: _buildSuffixActions(
          isMobile: isMobile,
          isTablet: isTablet,
        ),
      ),
    );
  }

  Widget _buildSuffixActions({
    required bool isMobile,
    required bool isTablet,
  }) {
    final hasFilter = widget.onFilterTap != null;

    if (!_hasText && !hasFilter) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_hasText)
            IconButton(
              tooltip: 'Clear',
              splashRadius: 20,
              icon: const Icon(
                Icons.clear_rounded,
                color: AppColors.textMuted,
                size: 18,
              ),
              onPressed: () {
                _controller.clear();
                widget.onChanged?.call('');
              },
            ),

          if (hasFilter)
            _buildFilterButton(
              onTap: widget.onFilterTap!,
              isMobile: isMobile,
            ),
        ],
      ),
    );
  }

  Widget _buildFilterButton({
    required VoidCallback onTap,
    required bool isMobile,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.all(
            isMobile ? 5 : 6,
          ),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.tune_rounded,
            color: AppColors.primary,
            size: isMobile ? 18 : 19,
          ),
        ),
      ),
    );
  }
}