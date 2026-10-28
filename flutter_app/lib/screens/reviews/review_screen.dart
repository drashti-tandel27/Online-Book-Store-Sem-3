import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../models/book.dart';
import '../../providers/auth_provider.dart';
import '../../providers/book_provider.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/rating_widget.dart';
import '../auth/login_screen.dart';

class ReviewScreen extends StatefulWidget {
  final Book book;

  const ReviewScreen({super.key, required this.book});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final _commentController = TextEditingController();
  double _rating = 5.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookProvider>(context, listen: false).fetchBookReviews(widget.book.id);
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitReview() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (!auth.isAuthenticated) {
      Helpers.showSnackBar(context, 'Please login to leave a review');
      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const LoginScreen()));
      return;
    }

    if (_commentController.text.trim().isEmpty) {
      Helpers.showSnackBar(context, 'Please enter your review text', isError: true);
      return;
    }

    final bookProvider = Provider.of<BookProvider>(context, listen: false);
    final success = await bookProvider.submitReview(
      bookId: widget.book.id,
      rating: _rating,
      comment: _commentController.text,
    );

    if (mounted) {
      if (success) {
        _commentController.clear();
        Helpers.showSnackBar(context, 'Review submitted successfully!', isSuccess: true);
      } else if (bookProvider.errorMessage != null) {
        Helpers.showSnackBar(context, bookProvider.errorMessage!, isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = context.watch<BookProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Reviews for ${widget.book.title}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rating input card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Leave your review',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: InteractiveRatingBar(
                      rating: _rating,
                      size: 36,
                      onRatingChanged: (r) => setState(() => _rating = r),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _commentController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'What did you like or dislike about this book?',
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'Post Review',
                    isLoading: bookProvider.isSubmittingReview,
                    onPressed: _submitReview,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Existing Reviews Header
            Text(
              'All Reviews (${bookProvider.activeBookReviews.length})',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),

            if (bookProvider.activeBookReviews.isEmpty)
              const EmptyStateWidget(
                title: 'No Reviews Yet',
                message: 'Be the first person to share your reading experience for this title!',
                icon: Icons.star_border_rounded,
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: bookProvider.activeBookReviews.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (ctx, index) {
                  final review = bookProvider.activeBookReviews[index];
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              review.userName,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            RatingWidget(rating: review.rating, compact: true, iconSize: 12),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          review.comment,
                          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
                        ),
                        if (review.createdAt != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            Helpers.formatDate(review.createdAt),
                            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
