import 'book.dart';

class OrderItem {
  final int id;
  final int? orderId;
  final int bookId;
  final int quantity;
  final double price;
  final String? bookTitle;
  final String? bookImage;
  final Book? book;

  OrderItem({
    required this.id,
    this.orderId,
    required this.bookId,
    required this.quantity,
    required this.price,
    this.bookTitle,
    this.bookImage,
    this.book,
  });

  double get subtotal => price * quantity;

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    Book? parsedBook;
    if (json['book'] != null && json['book'] is Map<String, dynamic>) {
      parsedBook = Book.fromJson(json['book']);
    }

    return OrderItem(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      orderId: json['order_id'] is int
          ? json['order_id']
          : int.tryParse(json['order_id']?.toString() ?? ''),
      bookId: json['book_id'] is int
          ? json['book_id']
          : int.tryParse(json['book_id']?.toString() ?? '0') ?? 0,
      quantity: json['quantity'] is int
          ? json['quantity']
          : int.tryParse(json['quantity']?.toString() ?? '1') ?? 1,
      price: json['price'] is num
          ? (json['price'] as num).toDouble()
          : double.tryParse(json['price']?.toString() ?? '0.0') ?? 0.0,
      bookTitle: json['book_title']?.toString() ?? parsedBook?.title,
      bookImage: json['book_image']?.toString() ?? parsedBook?.imageUrl,
      book: parsedBook,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'book_id': bookId,
      'quantity': quantity,
      'price': price,
      'book_title': bookTitle,
      'book_image': bookImage,
      if (book != null) 'book': book!.toJson(),
    };
  }
}
