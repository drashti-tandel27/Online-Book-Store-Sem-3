import 'book.dart';

class WishlistItem {
  final int id;
  final int? userId;
  final int bookId;
  final Book? book;
  final String? createdAt;

  WishlistItem({
    required this.id,
    this.userId,
    required this.bookId,
    this.book,
    this.createdAt,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    Book? parsedBook;
    if (json['book'] != null && json['book'] is Map<String, dynamic>) {
      parsedBook = Book.fromJson(json['book']);
    }

    return WishlistItem(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      userId: json['user_id'] is int
          ? json['user_id']
          : int.tryParse(json['user_id']?.toString() ?? ''),
      bookId: json['book_id'] is int
          ? json['book_id']
          : int.tryParse(json['book_id']?.toString() ?? '0') ?? 0,
      book: parsedBook,
      createdAt: json['created_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'book_id': bookId,
      if (book != null) 'book': book!.toJson(),
      'created_at': createdAt,
    };
  }
}
