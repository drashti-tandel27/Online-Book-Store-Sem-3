<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Book;
use App\Models\Category;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class BookController extends Controller
{
    // Display all books
    public function index()
    {
        $books = Book::with('category')
            ->latest()
            ->paginate(10);

        return view('admin.books.index', compact('books'));
    }

    // Show Add Book form
    public function create()
    {
        $categories = Category::orderBy('name')->get();

        return view('admin.books.create', compact('categories'));
    }

    // Save new book
    public function store(Request $request)
    {
        $validated = $request->validate([
            'category_id' => 'nullable|exists:categories,id',
            'title' => 'required|string|max:255',
            'author' => 'required|string|max:255',
            'isbn' => 'nullable|string|max:255',
            'description' => 'nullable|string',
            'price' => 'required|numeric|min:0',
            'discount_price' => 'nullable|numeric|min:0|lte:price',
            'stock' => 'required|integer|min:0',
            'rating' => 'nullable|numeric|min:0|max:5',
            'publisher' => 'nullable|string|max:255',
            'published_year' => 'nullable|integer|min:1000|max:2100',
            'page_count' => 'nullable|integer|min:1',
            'is_featured' => 'nullable|boolean',
            'image' => 'nullable|image|mimes:jpg,jpeg,png,webp|max:2048',
        ]);

        if ($request->hasFile('image')) {
            $validated['image'] = $request
                ->file('image')
                ->store('books', 'public');
        }

        $validated['is_featured'] = $request->has('is_featured');

        Book::create($validated);

        return redirect()
            ->route('admin.books.index')
            ->with('success', 'Book added successfully.');
    }

    // Show single book
    public function show(Book $book)
    {
        $book->load('category');

        return view('admin.books.show', compact('book'));
    }

    // Show Edit Book form
    public function edit(Book $book)
    {
        $categories = Category::orderBy('name')->get();

        return view('admin.books.edit', compact('book', 'categories'));
    }

    // Update book
    public function update(Request $request, Book $book)
    {
        $validated = $request->validate([
            'category_id' => 'nullable|exists:categories,id',
            'title' => 'required|string|max:255',
            'author' => 'required|string|max:255',
            'isbn' => 'nullable|string|max:255',
            'description' => 'nullable|string',
            'price' => 'required|numeric|min:0',
            'discount_price' => 'nullable|numeric|min:0|lte:price',
            'stock' => 'required|integer|min:0',
            'rating' => 'nullable|numeric|min:0|max:5',
            'publisher' => 'nullable|string|max:255',
            'published_year' => 'nullable|integer|min:1000|max:2100',
            'page_count' => 'nullable|integer|min:1',
            'is_featured' => 'nullable|boolean',
            'image' => 'nullable|image|mimes:jpg,jpeg,png,webp|max:2048',
        ]);

        if ($request->hasFile('image')) {

            // Delete old image
            if ($book->image) {
                Storage::disk('public')->delete($book->image);
            }

            // Store new image
            $validated['image'] = $request
                ->file('image')
                ->store('books', 'public');
        }

        $validated['is_featured'] = $request->has('is_featured');

        $book->update($validated);

        return redirect()
            ->route('admin.books.index')
            ->with('success', 'Book updated successfully.');
    }

    // Delete book
    public function destroy(Book $book)
    {
        if ($book->image) {
            Storage::disk('public')->delete($book->image);
        }

        $book->delete();

        return redirect()
            ->route('admin.books.index')
            ->with('success', 'Book deleted successfully.');
    }
}