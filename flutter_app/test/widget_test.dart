import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:online_book_store/models/category.dart';
import 'package:online_book_store/widgets/category_card.dart';
import 'package:online_book_store/widgets/custom_button.dart';
import 'package:online_book_store/widgets/price_widget.dart';
import 'package:online_book_store/widgets/rating_widget.dart';

void main() {
  group('Widget Component Tests', () {
    testWidgets('CustomButton renders text and triggers callback', (WidgetTester tester) async {
      bool pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Add to Cart',
              onPressed: () {
                pressed = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Add to Cart'), findsOneWidget);
      await tester.tap(find.text('Add to Cart'));
      expect(pressed, isTrue);
    });

    testWidgets('PriceWidget displays formatted price and discount percentage', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PriceWidget(
              price: 20.00,
              discountPrice: 15.00,
              showDiscountBadge: true,
            ),
          ),
        ),
      );

      expect(find.text('\$15.00'), findsOneWidget);
      expect(find.text('\$20.00'), findsOneWidget);
      expect(find.text('-25%'), findsOneWidget);
    });

    testWidgets('RatingWidget displays score and reviews count', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RatingWidget(
              rating: 4.8,
              reviewsCount: 120,
              showScore: true,
            ),
          ),
        ),
      );

      expect(find.text('4.8'), findsOneWidget);
      expect(find.text('(120)'), findsOneWidget);
    });

    testWidgets('CategoryCard displays name and count', (WidgetTester tester) async {
      final category = Category(
        id: 1,
        name: 'Science Fiction',
        booksCount: 35,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryCard(category: category),
          ),
        ),
      );

      expect(find.text('Science Fiction'), findsOneWidget);
      expect(find.text('35 books'), findsOneWidget);
    });
  });
}
