<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Review;
use Illuminate\Http\Request;

class ReviewController extends Controller
{
    public function index()
    {
        $reviews = Review::with(['user', 'book'])
            ->latest()
            ->paginate(10);

        return view('admin.reviews.index', compact('reviews'));
    }

    public function create()
    {
        abort(404);
    }

    public function store(Request $request)
    {
        abort(404);
    }

    public function show(Review $review)
    {
        $review->load(['user', 'book']);

        return view('admin.reviews.show', compact('review'));
    }

    public function edit(Review $review)
    {
        abort(404);
    }

    public function update(Request $request, Review $review)
    {
        abort(404);
    }

    public function destroy(Review $review)
    {
        $review->delete();

        return redirect()
            ->route('admin.reviews.index')
            ->with('success', 'Review deleted successfully.');
    }
}