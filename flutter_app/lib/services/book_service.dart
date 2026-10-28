import '../config/api_config.dart';
import '../models/api_response.dart';
import '../models/book.dart';
import '../models/category.dart';
import 'api_service.dart';

class BookService {
  final ApiService _api = ApiService();

  // Get Books with pagination and multi-filters
  Future<ApiResponse<List<Book>>> getBooks({
    int page = 1,
    int perPage = 12,
    String? search,
    int? categoryId,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    String? sortBy,
    String? sortOrder,
  }) async {
    final Map<String, dynamic> queryParams = {
      'page': page,
      'per_page': perPage,
    };

    if (search != null && search.trim().isNotEmpty) {
      queryParams['search'] = search.trim();
    }
    if (categoryId != null && categoryId > 0) {
      queryParams['category_id'] = categoryId;
    }
    if (minPrice != null && minPrice > 0) {
      queryParams['min_price'] = minPrice;
    }
    if (maxPrice != null && maxPrice > 0) {
      queryParams['max_price'] = maxPrice;
    }
    if (minRating != null && minRating > 0) {
      queryParams['min_rating'] = minRating;
    }
    if (sortBy != null && sortBy.isNotEmpty) {
      queryParams['sort_by'] = sortBy;
    }
    if (sortOrder != null && sortOrder.isNotEmpty) {
      queryParams['sort_order'] = sortOrder;
    }

    final response = await _api.get(ApiConfig.books, queryParams: queryParams);

    return ApiResponse.fromJson(
      response is Map<String, dynamic> ? response : {'data': response},
      fromJsonT: (data) {
        if (data is List) {
          return data.map((item) => Book.fromJson(item as Map<String, dynamic>)).toList();
        }
        return <Book>[];
      },
    );
  }

  // Get Book Details
  Future<Book> getBookDetails(int id) async {
    final response = await _api.get(ApiConfig.bookDetails(id));
    Map<String, dynamic> bookData = {};

    if (response is Map<String, dynamic>) {
      if (response['book'] is Map<String, dynamic>) {
        bookData = response['book'];
      } else if (response['data'] is Map<String, dynamic>) {
        bookData = response['data'];
      } else {
        bookData = response;
      }
    }

    return Book.fromJson(bookData);
  }

  // Get Popular Books
  Future<List<Book>> getPopularBooks() async {
    final response = await _api.get(ApiConfig.popularBooks);
    List<dynamic> list = [];

    if (response is List) {
      list = response;
    } else if (response is Map<String, dynamic>) {
      if (response['data'] is List) {
        list = response['data'];
      } else if (response['books'] is List) {
        list = response['books'];
      }
    }

    return list.map((item) => Book.fromJson(item as Map<String, dynamic>)).toList();
  }

  // Get Latest Books
  Future<List<Book>> getLatestBooks() async {
    final response = await _api.get(ApiConfig.latestBooks);
    List<dynamic> list = [];

    if (response is List) {
      list = response;
    } else if (response is Map<String, dynamic>) {
      if (response['data'] is List) {
        list = response['data'];
      } else if (response['books'] is List) {
        list = response['books'];
      }
    }

    return list.map((item) => Book.fromJson(item as Map<String, dynamic>)).toList();
  }

  // Get Recommended Books
  Future<List<Book>> getRecommendedBooks() async {
    try {
      final response = await _api.get(ApiConfig.recommendedBooks);
      List<dynamic> list = [];

      if (response is List) {
        list = response;
      } else if (response is Map<String, dynamic>) {
        if (response['data'] is List) {
          list = response['data'];
        } else if (response['books'] is List) {
          list = response['books'];
        }
      }

      return list.map((item) => Book.fromJson(item as Map<String, dynamic>)).toList();
    } catch (_) {
      // If backend does not have recommendation endpoint yet, fallback to popular
      return getPopularBooks();
    }
  }

  // Get Categories
  Future<List<Category>> getCategories() async {
    final response = await _api.get(ApiConfig.categories);
    List<dynamic> list = [];

    if (response is List) {
      list = response;
    } else if (response is Map<String, dynamic>) {
      if (response['data'] is List) {
        list = response['data'];
      } else if (response['categories'] is List) {
        list = response['categories'];
      }
    }

    return list.map((item) => Category.fromJson(item as Map<String, dynamic>)).toList();
  }

  // Get Category Details
  Future<Category> getCategoryDetails(int id) async {
    final response = await _api.get(ApiConfig.categoryDetails(id));
    Map<String, dynamic> categoryData = {};

    if (response is Map<String, dynamic>) {
      if (response['category'] is Map<String, dynamic>) {
        categoryData = response['category'];
      } else if (response['data'] is Map<String, dynamic>) {
        categoryData = response['data'];
      } else {
        categoryData = response;
      }
    }

    return Category.fromJson(categoryData);
  }
}
