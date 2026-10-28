import '../config/api_config.dart';
import '../models/cart.dart';
import 'api_service.dart';

class CartService {
  final ApiService _api = ApiService();

  // Get Cart
  Future<Cart> getCart() async {
    final response = await _api.get(ApiConfig.cart);
    Map<String, dynamic> cartData = {};

    if (response is Map<String, dynamic>) {
      if (response['cart'] is Map<String, dynamic>) {
        cartData = response['cart'];
      } else if (response['data'] is Map<String, dynamic>) {
        cartData = response['data'];
      } else {
        cartData = response;
      }
    } else if (response is List) {
      cartData = {'items': response};
    }

    return Cart.fromJson(cartData);
  }

  // Add Book to Cart
  Future<Cart> addToCart(int bookId, {int quantity = 1}) async {
    final response = await _api.post(
      ApiConfig.addToCart,
      body: {
        'book_id': bookId,
        'quantity': quantity,
      },
    );

    Map<String, dynamic> cartData = {};
    if (response is Map<String, dynamic>) {
      if (response['cart'] is Map<String, dynamic>) {
        cartData = response['cart'];
      } else if (response['data'] is Map<String, dynamic>) {
        cartData = response['data'];
      } else {
        cartData = response;
      }
    }

    // If API returns newly updated cart directly:
    if (cartData.containsKey('items') || cartData.containsKey('cart_items')) {
      return Cart.fromJson(cartData);
    }

    // Otherwise re-fetch full cart
    return getCart();
  }

  // Update Cart Item Quantity
  Future<Cart> updateQuantity(int cartItemId, int quantity) async {
    final response = await _api.put(
      ApiConfig.updateCart(cartItemId),
      body: {
        'quantity': quantity,
      },
    );

    Map<String, dynamic> cartData = {};
    if (response is Map<String, dynamic>) {
      if (response['cart'] is Map<String, dynamic>) {
        cartData = response['cart'];
      } else if (response['data'] is Map<String, dynamic>) {
        cartData = response['data'];
      } else {
        cartData = response;
      }
    }

    if (cartData.containsKey('items') || cartData.containsKey('cart_items')) {
      return Cart.fromJson(cartData);
    }

    return getCart();
  }

  // Remove Item from Cart
  Future<Cart> removeFromCart(int cartItemId) async {
    await _api.delete(ApiConfig.removeFromCart(cartItemId));
    return getCart();
  }

  // Clear Cart
  Future<void> clearCart() async {
    try {
      await _api.post(ApiConfig.clearCart);
    } catch (_) {
      // If POST clear is not supported, attempt delete /cart
      try {
        await _api.delete(ApiConfig.cart);
      } catch (_) {}
    }
  }
}
