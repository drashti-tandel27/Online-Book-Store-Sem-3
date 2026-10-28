<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Wishlist;
use Illuminate\Http\Request;

class WishlistController extends Controller
{
    // Get Wishlist
    public function index(Request $request)
    {
        $wishlist = Wishlist::with('book.category')
            ->where('user_id', $request->user()->id)
            ->latest()
            ->get();

        return response()->json([
            'status' => true,
            'data' => $wishlist,
        ]);
    }

    // Add to Wishlist
    public function store(Request $request)
    {
        $request->validate([
            'book_id' => 'required|exists:books,id',
        ]);

        $item = Wishlist::firstOrCreate([
            'user_id' => $request->user()->id,
            'book_id' => $request->book_id,
        ]);

        $item->load('book.category');

        return response()->json([
            'status' => true,
            'message' => 'Book added to wishlist.',
            'data' => $item,
        ], 201);
    }

    // Remove from Wishlist
    public function destroy(Request $request, $id)
    {
        $item = Wishlist::where('user_id', $request->user()->id)
            ->where(function ($q) use ($id) {
                $q->where('id', $id)->orWhere('book_id', $id);
            })
            ->first();

        if ($item) {
            $item->delete();
        }

        return response()->json([
            'status' => true,
            'message' => 'Removed from wishlist.',
        ]);
    }

    // Check if book in wishlist
    public function check(Request $request, $bookId)
    {
        $exists = Wishlist::where('user_id', $request->user()->id)
            ->where('book_id', $bookId)
            ->exists();

        return response()->json([
            'status' => true,
            'is_wishlisted' => $exists,
        ]);
    }
}
