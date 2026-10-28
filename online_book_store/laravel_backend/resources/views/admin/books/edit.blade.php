@extends('layouts.app')

@section('title', 'Edit Book - Admin')

@section('content')

<div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-10">

    <!-- Header -->
    <div class="mb-8">
        <a
            href="{{ route('admin.books.index') }}"
            class="text-sm text-blue-900 font-semibold hover:underline"
        >
            ← Back to Books
        </a>

        <h1 class="text-3xl font-extrabold text-slate-900 mt-4">
            Edit Book
        </h1>

        <p class="text-sm text-slate-500 mt-1">
            Update book information in your store catalog.
        </p>
    </div>

    <!-- Validation Errors -->
    @if($errors->any())
        <div class="mb-6 bg-rose-50 border border-rose-200 text-rose-700 px-5 py-4 rounded-xl">
            <p class="font-bold mb-2">Please fix the following errors:</p>

            <ul class="list-disc list-inside text-sm space-y-1">
                @foreach($errors->all() as $error)
                    <li>{{ $error }}</li>
                @endforeach
            </ul>
        </div>
    @endif

    <!-- Success Message -->
    @if(session('success'))
        <div class="mb-6 bg-emerald-50 border border-emerald-200 text-emerald-700 px-5 py-4 rounded-xl">
            {{ session('success') }}
        </div>
    @endif

    <!-- Form -->
    <form
        action="{{ route('admin.books.update', $book) }}"
        method="POST"
        enctype="multipart/form-data"
        class="bg-white border border-slate-200 rounded-2xl shadow-sm p-6 sm:p-8"
    >

        @csrf
        @method('PUT')

        <!-- Basic Information -->
        <div class="mb-8">

            <h2 class="text-xl font-bold text-slate-900 mb-5">
                Basic Information
            </h2>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-5">

                <!-- Title -->
                <div class="md:col-span-2">
                    <label class="block text-sm font-semibold text-slate-700 mb-2">
                        Book Title *
                    </label>

                    <input
                        type="text"
                        name="title"
                        value="{{ old('title', $book->title) }}"
                        required
                        class="w-full rounded-xl border border-slate-300 px-4 py-3 focus:border-blue-600 focus:ring-2 focus:ring-blue-100 outline-none"
                    >
                </div>

                <!-- Author -->
                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-2">
                        Author *
                    </label>

                    <input
                        type="text"
                        name="author"
                        value="{{ old('author', $book->author) }}"
                        required
                        class="w-full rounded-xl border border-slate-300 px-4 py-3 focus:border-blue-600 focus:ring-2 focus:ring-blue-100 outline-none"
                    >
                </div>

                <!-- Category -->
                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-2">
                        Category
                    </label>

                    <select
                        name="category_id"
                        class="w-full rounded-xl border border-slate-300 px-4 py-3 bg-white focus:border-blue-600 focus:ring-2 focus:ring-blue-100 outline-none"
                    >
                        <option value="">Select Category</option>

                        @foreach($categories as $category)
                            <option
                                value="{{ $category->id }}"
                                {{ old('category_id', $book->category_id) == $category->id ? 'selected' : '' }}
                            >
                                {{ $category->name }}
                            </option>
                        @endforeach

                    </select>
                </div>

                <!-- ISBN -->
                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-2">
                        ISBN
                    </label>

                    <input
                        type="text"
                        name="isbn"
                        value="{{ old('isbn', $book->isbn) }}"
                        class="w-full rounded-xl border border-slate-300 px-4 py-3 focus:border-blue-600 focus:ring-2 focus:ring-blue-100 outline-none"
                    >
                </div>

                <!-- Publisher -->
                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-2">
                        Publisher
                    </label>

                    <input
                        type="text"
                        name="publisher"
                        value="{{ old('publisher', $book->publisher) }}"
                        class="w-full rounded-xl border border-slate-300 px-4 py-3 focus:border-blue-600 focus:ring-2 focus:ring-blue-100 outline-none"
                    >
                </div>

            </div>
        </div>

        <!-- Description -->
        <div class="mb-8">

            <h2 class="text-xl font-bold text-slate-900 mb-5">
                Description
            </h2>

            <textarea
                name="description"
                rows="5"
                class="w-full rounded-xl border border-slate-300 px-4 py-3 focus:border-blue-600 focus:ring-2 focus:ring-blue-100 outline-none"
            >{{ old('description', $book->description) }}</textarea>

        </div>

        <!-- Pricing & Stock -->
        <div class="mb-8">

            <h2 class="text-xl font-bold text-slate-900 mb-5">
                Pricing & Stock
            </h2>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-5">

                <!-- Price -->
                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-2">
                        Price (₹) *
                    </label>

                    <input
                        type="number"
                        name="price"
                        value="{{ old('price', $book->price) }}"
                        min="0"
                        step="0.01"
                        required
                        class="w-full rounded-xl border border-slate-300 px-4 py-3"
                    >
                </div>

                <!-- Discount Price -->
                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-2">
                        Discount Price (₹)
                    </label>

                    <input
                        type="number"
                        name="discount_price"
                        value="{{ old('discount_price', $book->discount_price) }}"
                        min="0"
                        step="0.01"
                        class="w-full rounded-xl border border-slate-300 px-4 py-3"
                    >
                </div>

                <!-- Stock -->
                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-2">
                        Stock *
                    </label>

                    <input
                        type="number"
                        name="stock"
                        value="{{ old('stock', $book->stock) }}"
                        min="0"
                        required
                        class="w-full rounded-xl border border-slate-300 px-4 py-3"
                    >
                </div>

            </div>
        </div>

        <!-- Additional Information -->
        <div class="mb-8">

            <h2 class="text-xl font-bold text-slate-900 mb-5">
                Additional Information
            </h2>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-5">

                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-2">
                        Published Year
                    </label>

                    <input
                        type="number"
                        name="published_year"
                        value="{{ old('published_year', $book->published_year) }}"
                        min="1000"
                        max="2100"
                        class="w-full rounded-xl border border-slate-300 px-4 py-3"
                    >
                </div>

                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-2">
                        Page Count
                    </label>

                    <input
                        type="number"
                        name="page_count"
                        value="{{ old('page_count', $book->page_count) }}"
                        min="1"
                        class="w-full rounded-xl border border-slate-300 px-4 py-3"
                    >
                </div>

                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-2">
                        Rating
                    </label>

                    <input
                        type="number"
                        name="rating"
                        value="{{ old('rating', $book->rating) }}"
                        min="0"
                        max="5"
                        step="0.01"
                        class="w-full rounded-xl border border-slate-300 px-4 py-3"
                    >
                </div>

            </div>
        </div>

        <!-- Book Image -->
        <div class="mb-8">

            <h2 class="text-xl font-bold text-slate-900 mb-5">
                Book Cover
            </h2>

            @if($book->image)

                <div class="mb-5">
                    <p class="text-sm font-semibold text-slate-700 mb-2">
                        Current Image
                    </p>

                    @if(filter_var($book->image, FILTER_VALIDATE_URL))

                        <img
                            src="{{ $book->image }}"
                            alt="{{ $book->title }}"
                            class="w-32 h-44 object-cover rounded-xl border border-slate-200"
                        >

                    @else

                        <img
                            src="{{ asset('storage/' . $book->image) }}"
                            alt="{{ $book->title }}"
                            class="w-32 h-44 object-cover rounded-xl border border-slate-200"
                        >

                    @endif
                </div>

            @endif

            <label class="block text-sm font-semibold text-slate-700 mb-2">
                Replace Image
            </label>

            <input
                type="file"
                name="image"
                accept=".jpg,.jpeg,.png,.webp"
                class="w-full rounded-xl border border-slate-300 px-4 py-3 bg-white"
            >

            <p class="text-xs text-slate-500 mt-2">
                Leave empty to keep the current image. JPG, JPEG, PNG or WEBP. Maximum size: 2MB.
            </p>

        </div>

        <!-- Featured -->
        <div class="mb-8">

            <label class="flex items-center gap-3 cursor-pointer">

                <input
                    type="checkbox"
                    name="is_featured"
                    value="1"
                    {{ old('is_featured', $book->is_featured) ? 'checked' : '' }}
                    class="w-5 h-5 rounded border-slate-300"
                >

                <span class="text-sm font-semibold text-slate-700">
                    Mark this book as Featured
                </span>

            </label>

        </div>

        <!-- Buttons -->
        <div class="flex flex-col sm:flex-row gap-3 pt-6 border-t border-slate-200">

            <a
                href="{{ route('admin.books.index') }}"
                class="flex-1 text-center px-6 py-3 rounded-xl border border-slate-300 text-slate-700 font-semibold"
            >
                Cancel
            </a>

            <button
                type="submit"
                class="flex-1 px-6 py-3 rounded-xl bg-blue-900 hover:bg-blue-800 text-white font-semibold"
            >
                Update Book
            </button>

        </div>

    </form>

</div>

@endsection