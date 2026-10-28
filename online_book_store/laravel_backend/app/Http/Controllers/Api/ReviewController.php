<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Book;
use App\Models\Review;
use Illuminate\Http\Request;

class ReviewController extends Controller
{
    // List reviews for a book
    public function index($bookId)
    {
        $reviews = Review::with('user:id,name,avatar')
            ->where('book_id', $bookId)
            ->latest()
            ->get();

        return response()->json([
            'status' => true,
            'data' => $reviews,
        ]);
    }

    // Submit a review
    public function store(Request $request)
    {
        $validated = $request->validate([
            'book_id' => 'required|exists:books,id',
            'rating' => 'required|numeric|min:1|max:5',
            'comment' => 'required|string|max:1000',
        ]);

        $user = $request->user();

        // Update or create review
        $review = Review::updateOrCreate(
            [
                'user_id' => $user->id,
                'book_id' => $validated['book_id'],
            ],
            [
                'rating' => $validated['rating'],
                'comment' => $validated['comment'],
            ]
        );

        // Recalculate book average rating and reviews count
        $book = Book::findOrFail($validated['book_id']);
        $avgRating = Review::where('book_id', $book->id)->avg('rating');
        $totalReviews = Review::where('book_id', $book->id)->count();

        $book->update([
            'rating' => round($avgRating, 1),
            'reviews_count' => $totalReviews,
        ]);

        $review->load('user:id,name,avatar');

        return response()->json([
            'status' => true,
            'message' => 'Review submitted successfully.',
            'data' => $review,
            'review' => $review,
        ], 201);
    }
}
