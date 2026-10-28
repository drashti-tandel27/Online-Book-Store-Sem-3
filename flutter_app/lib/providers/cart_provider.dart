import 'package:flutter/material.dart';
import '../models/book.dart';
import '../models/cart.dart';
import '../models/cart_item.dart';
import '../services/cart_service.dart';

class CartProvider extends ChangeNotifier {
  final CartService _cartService = CartService();

  Cart _cart = Cart(items: []);
  bool _isLoading = false;
  String? _errorMessage;

  Cart get cart => _cart;
  List<CartItem> get items => _cart.items;
  int get itemCount => _cart.totalItemsCount;
  double get subtotal => _cart.subtotal;
  double get shippingFee => _cart.shippingFee;
  double get tax => _cart.tax;
  double get totalAmount => _cart.totalAmount;
  bool get isEmpty => _cart.isEmpty;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool isItemInCart(int bookId) {
    return _cart.items.any((item) => item.bookId == bookId);
  }

  int getItemQuantity(int bookId) {
    try {
      return _cart.items.firstWhere((item) => item.bookId == bookId).quantity;
    } catch (_) {
      return 0;
    }
  }

  // Fetch Cart
  Future<void> fetchCart() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _cart = await _cartService.getCart();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add To Cart
  Future<bool> addToCart(Book book, {int quantity = 1}) async {
    if (!book.inStock) {
      _errorMessage = 'This book is out of stock.';
      notifyListeners();
      return false;
    }

    // Check existing item in local cart
    final existingIndex = _cart.items.indexWhere((item) => item.bookId == book.id);
    if (existingIndex >= 0) {
      final currentQty = _cart.items[existingIndex].quantity;
      if (currentQty + quantity > book.stock) {
        _errorMessage = 'Cannot add more. Available stock limit reached (${book.stock}).';
        notifyListeners();
        return false;
      }
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _cart = await _cartService.addToCart(book.id, quantity: quantity);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update Quantity
  Future<bool> updateQuantity(int cartItemId, int newQuantity, {int? maxStock}) async {
    if (newQuantity <= 0) {
      return removeItem(cartItemId);
    }

    if (maxStock != null && newQuantity > maxStock) {
      _errorMessage = 'Available stock limit reached ($maxStock).';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _cart = await _cartService.updateQuantity(cartItemId, newQuantity);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Remove Item
  Future<bool> removeItem(int cartItemId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _cart = await _cartService.removeFromCart(cartItemId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Clear Cart
  Future<void> clearCart() async {
    _cart = Cart(items: []);
    notifyListeners();

    try {
      await _cartService.clearCart();
    } catch (_) {}
  }
}
