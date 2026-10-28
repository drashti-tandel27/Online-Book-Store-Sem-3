import '../config/api_config.dart';
import '../models/wishlist.dart';
import 'api_service.dart';
import 'package:flutter/foundation.dart';
class WishlistService {
  final ApiService _api = ApiService();

  // Get Wishlist
Future<List<WishlistItem>> getWishlist() async {
  final response = await _api.get(ApiConfig.wishlist);

  debugPrint('❤️ WISHLIST API RESPONSE: $response');
  debugPrint('❤️ RESPONSE TYPE: ${response.runtimeType}');

  List<dynamic> list = [];

  if (response is List) {
    list = response;
  } else if (response is Map<String, dynamic>) {
    debugPrint('❤️ RESPONSE KEYS: ${response.keys}');

    if (response['data'] is List) {
      list = response['data'];
    } else if (response['wishlist'] is List) {
      list = response['wishlist'];
    }
  }

  debugPrint('❤️ WISHLIST LIST LENGTH: ${list.length}');
  debugPrint('❤️ WISHLIST LIST: $list');

  final items = list
      .whereType<Map<String, dynamic>>()
      .map((item) {
    debugPrint('❤️ PARSING ITEM: $item');
        return WishlistItem.fromJson(item);
      })
      .toList();

  debugPrint('❤️ FINAL WISHLIST ITEMS: ${items.length}');

  return items;
}

  // Add Book to Wishlist
  Future<WishlistItem> addToWishlist(int bookId) async {
    final response = await _api.post(
      ApiConfig.addToWishlist,
      body: {'book_id': bookId},
    );

    Map<String, dynamic> itemData = {};
    if (response is Map<String, dynamic>) {
      if (response['data'] is Map<String, dynamic>) {
        itemData = response['data'];
      } else if (response['wishlist_item'] is Map<String, dynamic>) {
        itemData = response['wishlist_item'];
      } else {
        itemData = response;
      }
    }

    // Fallback if item data is not structured:
    if (!itemData.containsKey('book_id')) {
      itemData['book_id'] = bookId;
      itemData['id'] = itemData['id'] ?? bookId;
    }

    return WishlistItem.fromJson(itemData);
  }

  // Remove from Wishlist
  Future<void> removeFromWishlist(int id) async {
    await _api.delete(ApiConfig.removeFromWishlist(id));
  }

  // Check if book is in wishlist
  Future<bool> checkWishlist(int bookId) async {
    try {
      final response = await _api.get(ApiConfig.checkWishlist(bookId));
      if (response is Map<String, dynamic>) {
        return response['is_wishlisted'] == true || response['in_wishlist'] == true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
