import 'package:flutter/material.dart';
import '../models/api_response.dart';
import '../models/book.dart';
import '../models/category.dart';
import '../models/review.dart';
import '../services/book_service.dart';
import '../services/review_service.dart';

class BookProvider extends ChangeNotifier {
  final BookService _bookService = BookService();
  final ReviewService _reviewService = ReviewService();

  // Home Screen lists
  List<Book> _popularBooks = [];
  List<Book> _latestBooks = [];
  List<Book> _recommendedBooks = [];
  List<Category> _categories = [];

  // Books catalog & filtering
  List<Book> _books = [];
  PaginationMeta? _booksMeta;
  bool _isLoadingMore = false;
  int _currentPage = 1;

  // Search
  List<Book> _searchResults = [];
  String _searchQuery = '';
  bool _isSearching = false;

  // Active book details & reviews
  Book? _activeBook;
  List<Review> _activeBookReviews = [];
  bool _isLoadingReviews = false;

  // Filters
  int? _filterCategoryId;
  double? _filterMinPrice;
  double? _filterMaxPrice;
  double? _filterMinRating;
  String _filterSortBy = 'created_at';
  String _filterSortOrder = 'desc';

  // Loading States
  bool _isLoadingHome = false;
  bool _isLoadingBooks = false;
  bool _isLoadingBookDetails = false;
  bool _isSubmittingReview = false;
  String? _errorMessage;

  // Getters
  List<Book> get popularBooks => _popularBooks;
  List<Book> get latestBooks => _latestBooks;
  List<Book> get recommendedBooks => _recommendedBooks;
  List<Category> get categories => _categories;
  List<Book> get books => _books;
  List<Book> get searchResults => _searchResults;
  String get searchQuery => _searchQuery;
  Book? get activeBook => _activeBook;
  List<Review> get activeBookReviews => _activeBookReviews;

  int? get filterCategoryId => _filterCategoryId;
  double? get filterMinPrice => _filterMinPrice;
  double? get filterMaxPrice => _filterMaxPrice;
  double? get filterMinRating => _filterMinRating;
  String get filterSortBy => _filterSortBy;
  String get filterSortOrder => _filterSortOrder;

  bool get isLoadingHome => _isLoadingHome;
  bool get isLoadingBooks => _isLoadingBooks;
  bool get isLoadingMore => _isLoadingMore;
  bool get isSearching => _isSearching;
  bool get isLoadingBookDetails => _isLoadingBookDetails;
  bool get isLoadingReviews => _isLoadingReviews;
  bool get isSubmittingReview => _isSubmittingReview;
  String? get errorMessage => _errorMessage;
  bool get hasMoreBooks => _booksMeta?.hasMore ?? false;

  // Fetch Home Screen Data (Popular, Latest, Recommended, Categories)
  Future<void> fetchHomeData() async {
    _isLoadingHome = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _bookService.getPopularBooks(),
        _bookService.getLatestBooks(),
        _bookService.getRecommendedBooks(),
        _bookService.getCategories(),
      ]);

      _popularBooks = results[0] as List<Book>;
      _latestBooks = results[1] as List<Book>;
      _recommendedBooks = results[2] as List<Book>;
      _categories = results[3] as List<Category>;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoadingHome = false;
      notifyListeners();
    }
  }

  // Fetch Catalog Books (with reset or pagination)
  Future<void> fetchBooks({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _books = [];
      _isLoadingBooks = true;
    } else {
      if (_isLoadingMore || !hasMoreBooks) return;
      _isLoadingMore = true;
    }

    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _bookService.getBooks(
        page: _currentPage,
        categoryId: _filterCategoryId,
        minPrice: _filterMinPrice,
        maxPrice: _filterMaxPrice,
        minRating: _filterMinRating,
        sortBy: _filterSortBy,
        sortOrder: _filterSortOrder,
      );

      if (response.data != null) {
        if (refresh || _currentPage == 1) {
          _books = response.data!;
        } else {
          _books.addAll(response.data!);
        }
        _booksMeta = response.meta;
        _currentPage++;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoadingBooks = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  // Set & Apply Filters
  void setFilters({
    int? categoryId,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    String? sortBy,
    String? sortOrder,
  }) {
    _filterCategoryId = categoryId;
    _filterMinPrice = minPrice;
    _filterMaxPrice = maxPrice;
    _filterMinRating = minRating;
    if (sortBy != null) _filterSortBy = sortBy;
    if (sortOrder != null) _filterSortOrder = sortOrder;
    fetchBooks(refresh: true);
  }

  void clearFilters() {
    _filterCategoryId = null;
    _filterMinPrice = null;
    _filterMaxPrice = null;
    _filterMinRating = null;
    _filterSortBy = 'created_at';
    _filterSortOrder = 'desc';
    fetchBooks(refresh: true);
  }

  // Search Books
  Future<void> search(String query) async {
    _searchQuery = query;
    if (query.trim().isEmpty) {
      _searchResults = [];
      _isSearching = false;
      notifyListeners();
      return;
    }

    _isSearching = true;
    notifyListeners();

    try {
      final response = await _bookService.getBooks(
        search: query.trim(),
        perPage: 30,
      );
      _searchResults = response.data ?? [];
    } catch (_) {
      _searchResults = [];
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  // Fetch Book Details & Reviews
  Future<void> fetchBookDetails(int id) async {
    _isLoadingBookDetails = true;
    _activeBook = null;
    _activeBookReviews = [];
    _errorMessage = null;
    notifyListeners();

    try {
      _activeBook = await _bookService.getBookDetails(id);
      _isLoadingBookDetails = false;
      notifyListeners();

      // Fetch reviews asynchronously
      fetchBookReviews(id);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoadingBookDetails = false;
      notifyListeners();
    }
  }

  Future<void> fetchBookReviews(int bookId) async {
    _isLoadingReviews = true;
    notifyListeners();

    try {
      _activeBookReviews = await _reviewService.getBookReviews(bookId);
    } catch (_) {
      _activeBookReviews = [];
    } finally {
      _isLoadingReviews = false;
      notifyListeners();
    }
  }

  // Submit Review
  Future<bool> submitReview({
    required int bookId,
    required double rating,
    required String comment,
  }) async {
    _isSubmittingReview = true;
    notifyListeners();

    try {
      final newReview = await _reviewService.submitReview(
        bookId: bookId,
        rating: rating,
        comment: comment,
      );
      _activeBookReviews.insert(0, newReview);
      _isSubmittingReview = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isSubmittingReview = false;
      notifyListeners();
      return false;
    }
  }
}
