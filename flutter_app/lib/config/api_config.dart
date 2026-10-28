import 'package:flutter/foundation.dart';

class ApiConfig {
  // Base URL configuration
  // Web: localhost
  // Android: local network IP
  static String get baseUrl {
    if (kIsWeb) {
      return "http://127.0.0.1:8000/api";
    }

    return "http://10.93.161.125:8000/api";
  }

  static String get baseStorageUrl {
    if (baseUrl.endsWith('/api')) {
      return baseUrl.substring(0, baseUrl.length - 4);
    }
    return baseUrl;
  }

  // Request timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // Authentication Endpoints
  static const String register = "/register";
  static const String login = "/login";
  static const String logout = "/logout";
  static const String profile = "/profile";
  static const String updateProfile = "/profile";
  static const String changePassword = "/change-password";

  // Book Endpoints
  static const String books = "/books";
  static const String popularBooks = "/books/popular";
  static const String latestBooks = "/books/latest";
  static const String recommendedBooks = "/books/recommended";
  static String bookDetails(int id) => "/books/$id";

  // Category Endpoints
  static const String categories = "/categories";
  static String categoryDetails(int id) => "/categories/$id";

  // Cart Endpoints
  static const String cart = "/cart";
  static const String addToCart = "/cart";
  static String updateCart(int id) => "/cart/$id";
  static String removeFromCart(int id) => "/cart/$id";
  static const String clearCart = "/cart/clear";

  // Wishlist Endpoints
  static const String wishlist = "/wishlist";
  static const String addToWishlist = "/wishlist";
  static String removeFromWishlist(int id) => "/wishlist/$id";
  static String checkWishlist(int bookId) => "/wishlist/check/$bookId";

  // Order Endpoints
  static const String orders = "/orders";
  static const String placeOrder = "/orders";
  static String orderDetails(int id) => "/orders/$id";
  static String cancelOrder(int id) => "/orders/$id/cancel";

  // Notification Endpoints
  static const String notifications = "/notifications";
  static String markNotificationAsRead(int id) =>
      "/notifications/$id/read";
  static const String markAllNotificationsAsRead =
      "/notifications/read-all";
  static String deleteNotification(int id) =>
      "/notifications/$id";

  // Review Endpoints
  static String bookReviews(int bookId) =>
      "/books/$bookId/reviews";
  static const String submitReview = "/reviews";

  // Helper for resolving image URLs
  static String resolveImageUrl(String? path) {
    if (path == null || path.isEmpty) {
      return '';
    }

    if (path.startsWith('http://') ||
        path.startsWith('https://')) {
      return path;
    }

    if (path.startsWith('/')) {
      return '$baseStorageUrl$path';
    }

    if (path.startsWith('storage/')) {
      return '$baseStorageUrl/$path';
    }

    return '$baseStorageUrl/storage/$path';
  }
}