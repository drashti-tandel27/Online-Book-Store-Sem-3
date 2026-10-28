import 'package:flutter/material.dart';
import '../models/book.dart';
import '../models/wishlist.dart';
import '../services/wishlist_service.dart';

class WishlistProvider extends ChangeNotifier {
  final WishlistService _wishlistService = WishlistService();

  List<WishlistItem> _items = [];
  final Set<int> _wishlistedBookIds = {};
  bool _isLoading = false;
  String? _errorMessage;

  List<WishlistItem> get items => _items;
  Set<int> get wishlistedBookIds => _wishlistedBookIds;
  int get itemCount => _items.length;
  bool get isEmpty => _items.isEmpty;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool isInWishlist(int bookId) {
    return _wishlistedBookIds.contains(bookId);
  }

  // Fetch Wishlist
  Future<void> fetchWishlist() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _items = await _wishlistService.getWishlist();
      _wishlistedBookIds.clear();
      for (final item in _items) {
        _wishlistedBookIds.add(item.bookId);
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Toggle Wishlist Status
  Future<bool> toggleWishlist(Book book) async {
    final isCurrentlyWishlisted = isInWishlist(book.id);

    if (isCurrentlyWishlisted) {
      // Find item
      final item = _items.firstWhere(
        (i) => i.bookId == book.id,
        orElse: () => WishlistItem(id: book.id, bookId: book.id),
      );
      _wishlistedBookIds.remove(book.id);
      _items.removeWhere((i) => i.bookId == book.id);
      notifyListeners();

      try {
        await _wishlistService.removeFromWishlist(item.id);
        return false; // Removed
      } catch (e) {
        // Rollback
        _wishlistedBookIds.add(book.id);
        _items.add(item);
        notifyListeners();
        return true;
      }
    } else {
      // Add
      _wishlistedBookIds.add(book.id);
      final tempItem = WishlistItem(id: DateTime.now().millisecondsSinceEpoch, bookId: book.id, book: book);
      _items.insert(0, tempItem);
      notifyListeners();

      try {
        final serverItem = await _wishlistService.addToWishlist(book.id);
        final index = _items.indexWhere((i) => i.bookId == book.id);
        if (index >= 0) {
          _items[index] = serverItem;
        }
        notifyListeners();
        return true; // Added
      } catch (e) {
        // Rollback
        _wishlistedBookIds.remove(book.id);
        _items.removeWhere((i) => i.bookId == book.id);
        notifyListeners();
        return false;
      }
    }
  }

  // Remove by ID
  Future<void> removeItem(int wishlistItemId, int bookId) async {
    _items.removeWhere((i) => i.id == wishlistItemId || i.bookId == bookId);
    _wishlistedBookIds.remove(bookId);
    notifyListeners();

    try {
      await _wishlistService.removeFromWishlist(wishlistItemId);
    } catch (_) {}
  }
}
