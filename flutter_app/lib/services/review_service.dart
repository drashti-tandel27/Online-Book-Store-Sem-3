import '../config/api_config.dart';
import '../models/review.dart';
import 'api_service.dart';

class ReviewService {
  final ApiService _api = ApiService();

  // Get Reviews for a Book
  Future<List<Review>> getBookReviews(int bookId) async {
    final response = await _api.get(ApiConfig.bookReviews(bookId));
    List<dynamic> list = [];

    if (response is List) {
      list = response;
    } else if (response is Map<String, dynamic>) {
      if (response['reviews'] is List) {
        list = response['reviews'];
      } else if (response['data'] is List) {
        list = response['data'];
      }
    }

    return list.map((item) => Review.fromJson(item as Map<String, dynamic>)).toList();
  }

  // Submit a Review
  Future<Review> submitReview({
    required int bookId,
    required double rating,
    required String comment,
  }) async {
    final response = await _api.post(
      ApiConfig.submitReview,
      body: {
        'book_id': bookId,
        'rating': rating,
        'comment': comment.trim(),
        'review': comment.trim(),
      },
    );

    Map<String, dynamic> reviewData = {};
    if (response is Map<String, dynamic>) {
      if (response['review'] is Map<String, dynamic>) {
        reviewData = response['review'];
      } else if (response['data'] is Map<String, dynamic>) {
        reviewData = response['data'];
      } else {
        reviewData = response;
      }
    }

    return Review.fromJson(reviewData);
  }
}
