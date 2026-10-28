<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Book;
use Illuminate\Http\Request;

class BookController extends Controller
{
    // List all books with filtering and pagination
    public function index(Request $request)
    {
        $query = Book::with('category');

        // Search by title or author
        if ($request->filled('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('title', 'like', "%{$search}%")
                  ->orWhere('author', 'like', "%{$search}%")
                  ->orWhereHas('category', function ($cq) use ($search) {
                      $cq->where('name', 'like', "%{$search}%");
                  });
            });
        }

        // Category Filter
        if ($request->filled('category_id')) {
            $query->where('category_id', $request->category_id);
        }

        // Price Filter
        if ($request->filled('min_price')) {
            $query->where('price', '>=', $request->min_price);
        }
        if ($request->filled('max_price')) {
            $query->where('price', '<=', $request->max_price);
        }

        // Rating Filter
        if ($request->filled('min_rating')) {
            $query->where('rating', '>=', $request->min_rating);
        }

        // Sorting
        $sortBy = $request->get('sort_by', 'created_at');
        $sortOrder = $request->get('sort_order', 'desc');

        if (in_array($sortBy, ['created_at', 'price', 'rating', 'title'])) {
            $query->orderBy($sortBy, $sortOrder === 'asc' ? 'asc' : 'desc');
        } else {
            $query->latest();
        }

        $perPage = $request->get('per_page', 12);
        $books = $query->paginate($perPage);

        return response()->json([
            'status' => true,
            'data' => $books->items(),
            'meta' => [
                'current_page' => $books->currentPage(),
                'last_page' => $books->lastPage(),
                'per_page' => $books->perPage(),
                'total' => $books->total(),
            ],
        ]);
    }

    // Book Details
    public function show($id)
    {
        $book = Book::with(['category', 'reviews.user'])->findOrFail($id);

        return response()->json([
            'status' => true,
            'data' => $book,
        ]);
    }

    // Popular Books
    public function popular()
    {
        $books = Book::with('category')
            ->orderBy('rating', 'desc')
            ->orderBy('reviews_count', 'desc')
            ->take(8)
            ->get();

        return response()->json([
            'status' => true,
            'data' => $books,
        ]);
    }

    // Latest Books
    public function latest()
    {
        $books = Book::with('category')
            ->latest()
            ->take(8)
            ->get();

        return response()->json([
            'status' => true,
            'data' => $books,
        ]);
    }

    // Recommended Books
    public function recommended()
    {
        $books = Book::with('category')
            ->where('is_featured', true)
            ->orWhere('rating', '>=', 4.5)
            ->take(8)
            ->get();

        return response()->json([
            'status' => true,
            'data' => $books,
        ]);
    }
}
