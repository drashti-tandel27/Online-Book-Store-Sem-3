import 'book.dart';

class CartItem {
  final int id;
  final int? cartId;
  final int bookId;
  int quantity;
  final double price;
  final Book? book;

  CartItem({
    required this.id,
    this.cartId,
    required this.bookId,
    required this.quantity,
    required this.price,
    this.book,
  });

  double get subtotal => (book?.effectivePrice ?? price) * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    Book? parsedBook;
    if (json['book'] != null && json['book'] is Map<String, dynamic>) {
      parsedBook = Book.fromJson(json['book']);
    }

    return CartItem(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      cartId: json['cart_id'] is int
          ? json['cart_id']
          : int.tryParse(json['cart_id']?.toString() ?? ''),
      bookId: json['book_id'] is int
          ? json['book_id']
          : int.tryParse(json['book_id']?.toString() ?? '0') ?? 0,
      quantity: json['quantity'] is int
          ? json['quantity']
          : int.tryParse(json['quantity']?.toString() ?? '1') ?? 1,
      price: json['price'] is num
          ? (json['price'] as num).toDouble()
          : double.tryParse(json['price']?.toString() ?? '0.0') ?? 0.0,
      book: parsedBook,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cart_id': cartId,
      'book_id': bookId,
      'quantity': quantity,
      'price': price,
      if (book != null) 'book': book!.toJson(),
    };
  }

  CartItem copyWith({
    int? id,
    int? cartId,
    int? bookId,
    int? quantity,
    double? price,
    Book? book,
  }) {
    return CartItem(
      id: id ?? this.id,
      cartId: cartId ?? this.cartId,
      bookId: bookId ?? this.bookId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      book: book ?? this.book,
    );
  }
}
