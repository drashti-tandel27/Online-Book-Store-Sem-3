import 'category.dart';

class Book {
  final int id;
  final String title;
  final String author;
  final String? isbn;
  final double price;
  final double? discountPrice;
  final int stock;
  final double rating;
  final int reviewsCount;
  final String? description;
  final String? imageUrl;
  final int? categoryId;
  final Category? category;
  final bool isFeatured;
  final String? publisher;
  final int? publishedYear;
  final int? pageCount;
  final bool isWishlisted;

  Book({
    required this.id,
    required this.title,
    required this.author,
    this.isbn,
    required this.price,
    this.discountPrice,
    required this.stock,
    this.rating = 0.0,
    this.reviewsCount = 0,
    this.description,
    this.imageUrl,
    this.categoryId,
    this.category,
    this.isFeatured = false,
    this.publisher,
    this.publishedYear,
    this.pageCount,
    this.isWishlisted = false,
  });

  bool get inStock => stock > 0;
  bool get hasDiscount => discountPrice != null && discountPrice! > 0 && discountPrice! < price;
  double get effectivePrice => hasDiscount ? discountPrice! : price;

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? '',
      author: json['author']?.toString() ?? '',
      isbn: json['isbn']?.toString(),
      price: json['price'] is num
          ? (json['price'] as num).toDouble()
          : double.tryParse(json['price']?.toString() ?? '0.0') ?? 0.0,
      discountPrice: json['discount_price'] != null
          ? (json['discount_price'] is num
              ? (json['discount_price'] as num).toDouble()
              : double.tryParse(json['discount_price']?.toString() ?? ''))
          : null,
      stock: json['stock'] is int ? json['stock'] : int.tryParse(json['stock']?.toString() ?? '0') ?? 0,
      rating: json['rating'] is num
          ? (json['rating'] as num).toDouble()
          : double.tryParse(json['rating']?.toString() ?? '0.0') ?? 0.0,
      reviewsCount: json['reviews_count'] is int
          ? json['reviews_count']
          : int.tryParse(json['reviews_count']?.toString() ?? '0') ?? 0,
      description: json['description']?.toString(),
      imageUrl: json['image']?.toString() ?? json['image_url']?.toString(),
      categoryId: json['category_id'] is int
          ? json['category_id']
          : int.tryParse(json['category_id']?.toString() ?? ''),
      category: json['category'] != null && json['category'] is Map<String, dynamic>
          ? Category.fromJson(json['category'])
          : null,
      isFeatured: json['is_featured'] == true || json['is_featured'] == 1 || json['is_featured'] == '1',
      publisher: json['publisher']?.toString(),
      publishedYear: json['published_year'] is int
          ? json['published_year']
          : int.tryParse(json['published_year']?.toString() ?? ''),
      pageCount: json['page_count'] is int
          ? json['page_count']
          : int.tryParse(json['page_count']?.toString() ?? ''),
      isWishlisted: json['is_wishlisted'] == true || json['is_wishlisted'] == 1 || json['is_wishlisted'] == '1',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'isbn': isbn,
      'price': price,
      'discount_price': discountPrice,
      'stock': stock,
      'rating': rating,
      'reviews_count': reviewsCount,
      'description': description,
      'image': imageUrl,
      'category_id': categoryId,
      if (category != null) 'category': category!.toJson(),
      'is_featured': isFeatured,
      'publisher': publisher,
      'published_year': publishedYear,
      'page_count': pageCount,
      'is_wishlisted': isWishlisted,
    };
  }

  Book copyWith({
    int? id,
    String? title,
    String? author,
    String? isbn,
    double? price,
    double? discountPrice,
    int? stock,
    double? rating,
    int? reviewsCount,
    String? description,
    String? imageUrl,
    int? categoryId,
    Category? category,
    bool? isFeatured,
    String? publisher,
    int? publishedYear,
    int? pageCount,
    bool? isWishlisted,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      isbn: isbn ?? this.isbn,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      stock: stock ?? this.stock,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      categoryId: categoryId ?? this.categoryId,
      category: category ?? this.category,
      isFeatured: isFeatured ?? this.isFeatured,
      publisher: publisher ?? this.publisher,
      publishedYear: publishedYear ?? this.publishedYear,
      pageCount: pageCount ?? this.pageCount,
      isWishlisted: isWishlisted ?? this.isWishlisted,
    );
  }
}
