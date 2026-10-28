import 'package:flutter_test/flutter_test.dart';
import 'package:online_book_store/models/book.dart';
import 'package:online_book_store/models/cart.dart';
import 'package:online_book_store/models/cart_item.dart';
import 'package:online_book_store/models/category.dart';
import 'package:online_book_store/models/order.dart';
import 'package:online_book_store/models/review.dart';
import 'package:online_book_store/models/user.dart';
import 'package:online_book_store/utils/helpers.dart';
import 'package:online_book_store/utils/validators.dart';

void main() {
  group('Validators Unit Tests', () {
    test('Email validator accepts valid emails and rejects invalid', () {
      expect(Validators.email('reader@example.com'), isNull);
      expect(Validators.email('invalid-email'), isNotNull);
      expect(Validators.email(''), isNotNull);
      expect(Validators.email(null), isNotNull);
    });

    test('Password validator checks minimum 6 characters', () {
      expect(Validators.password('password123'), isNull);
      expect(Validators.password('12345'), isNotNull);
      expect(Validators.password(''), isNotNull);
    });

    test('Confirm password validator matches passwords', () {
      expect(Validators.confirmPassword('secret123', 'secret123'), isNull);
      expect(Validators.confirmPassword('secret123', 'different'), isNotNull);
    });

    test('Name and phone validators', () {
      expect(Validators.name('John Doe'), isNull);
      expect(Validators.name('J'), isNotNull);
      expect(Validators.phone('+1 555-1234567'), isNull);
      expect(Validators.phone('123'), isNotNull);
    });
  });

  group('Models Serialization Tests', () {
    test('User model serialization and deserialization', () {
      final json = {
        'id': 1,
        'name': 'Alice Reader',
        'email': 'alice@example.com',
        'phone': '5551234567',
        'address': '123 Book Lane',
        'role': 'customer',
      };

      final user = User.fromJson(json, token: 'test-token-123');
      expect(user.id, 1);
      expect(user.name, 'Alice Reader');
      expect(user.email, 'alice@example.com');
      expect(user.token, 'test-token-123');
      expect(user.isAdmin, isFalse);

      final outJson = user.toJson();
      expect(outJson['name'], 'Alice Reader');
      expect(outJson['token'], 'test-token-123');
    });

    test('Book model discount and stock calculations', () {
      final json = {
        'id': 101,
        'title': 'The Great Gatsby',
        'author': 'F. Scott Fitzgerald',
        'price': 19.99,
        'discount_price': 14.99,
        'stock': 15,
        'rating': 4.7,
        'reviews_count': 42,
      };

      final book = Book.fromJson(json);
      expect(book.inStock, isTrue);
      expect(book.hasDiscount, isTrue);
      expect(book.effectivePrice, 14.99);
      expect(book.rating, 4.7);
    });

    test('Cart model subtotal, shipping, and total calculations', () {
      final item1 = CartItem(
        id: 1,
        bookId: 101,
        quantity: 2,
        price: 15.00,
      );
      final item2 = CartItem(
        id: 2,
        bookId: 102,
        quantity: 1,
        price: 30.00,
      );

      final cart = Cart(items: [item1, item2]);
      expect(cart.totalItemsCount, 3);
      expect(cart.subtotal, 60.00);
      expect(cart.shippingFee, 0.0); // Free shipping because subtotal > 50
      expect(cart.tax, 3.00); // 5% of 60
      expect(cart.totalAmount, 63.00);
    });

    test('Category and Review models', () {
      final category = Category.fromJson({
        'id': 5,
        'name': 'Science Fiction',
        'books_count': 28,
      });
      expect(category.name, 'Science Fiction');
      expect(category.booksCount, 28);

      final review = Review.fromJson({
        'id': 1,
        'book_id': 101,
        'user_name': 'BookLover',
        'rating': 5,
        'comment': 'An absolute masterpiece!',
      });
      expect(review.rating, 5.0);
      expect(review.userName, 'BookLover');
    });

    test('Order model progress step and status checks', () {
      final order = Order.fromJson({
        'id': 99,
        'order_number': 'ORD-2026-99',
        'status': 'Confirmed',
        'subtotal': 45.00,
        'total_amount': 52.24,
        'shipping_address': '77 Library Blvd',
        'payment_method': 'Cash on Delivery',
      });

      expect(order.canCancel, isTrue);
      expect(order.statusStepIndex, 1);
      expect(order.isDelivered, isFalse);
    });
  });

  group('Helpers Formatters Tests', () {
    test('Price formatter', () {
      expect(Helpers.formatPrice(19.99), '\$19.99');
      expect(Helpers.formatPrice(0), '\$0.00');
      expect(Helpers.formatPrice(null), '\$0.00');
    });
  });
}
