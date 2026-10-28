@extends('layouts.app')

@section('title', 'Add New Book - Admin')

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
            Add New Book
        </h1>

        <p class="text-sm text-slate-500 mt-1">
            Add a new book to your online store catalog.
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


    <!-- Form -->
    <form
        action="{{ route('admin.books.store') }}"
        method="POST"
        enctype="multipart/form-data"
        class="bg-white border border-slate-200 rounded-2xl shadow-sm p-6 sm:p-8"
    >

        @csrf

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
                        value="{{ old('title') }}"
                        required
                        placeholder="Enter book title"
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
                        value="{{ old('author') }}"
                        required
                        placeholder="Enter author name"
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

                        <option value="">
                            Select Category
                        </option>

                        @foreach($categories as $category)

                            <option
                                value="{{ $category->id }}"
                                {{ old('category_id') == $category->id ? 'selected' : '' }}
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
                        value="{{ old('isbn') }}"
                        placeholder="978-XXXXXXXXXX"
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
                        value="{{ old('publisher') }}"
                        placeholder="Enter publisher"
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
                placeholder="Enter book description..."
                class="w-full rounded-xl border border-slate-300 px-4 py-3 focus:border-blue-600 focus:ring-2 focus:ring-blue-100 outline-none"
            >{{ old('description') }}</textarea>

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
                        value="{{ old('price') }}"
                        min="0"
                        step="0.01"
                        required
                        placeholder="0.00"
                        class="w-full rounded-xl border border-slate-300 px-4 py-3 focus:border-blue-600 focus:ring-2 focus:ring-blue-100 outline-none"
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
                        value="{{ old('discount_price') }}"
                        min="0"
                        step="0.01"
                        placeholder="0.00"
                        class="w-full rounded-xl border border-slate-300 px-4 py-3 focus:border-blue-600 focus:ring-2 focus:ring-blue-100 outline-none"
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
                        value="{{ old('stock', 0) }}"
                        min="0"
                        required
                        placeholder="0"
                        class="w-full rounded-xl border border-slate-300 px-4 py-3 focus:border-blue-600 focus:ring-2 focus:ring-blue-100 outline-none"
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

                <!-- Published Year -->
                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-2">
                        Published Year
                    </label>

                    <input
                        type="number"
                        name="published_year"
                        value="{{ old('published_year') }}"
                        min="1000"
                        max="2100"
                        placeholder="2026"
                        class="w-full rounded-xl border border-slate-300 px-4 py-3 focus:border-blue-600 focus:ring-2 focus:ring-blue-100 outline-none"
                    >
                </div>


                <!-- Page Count -->
                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-2">
                        Page Count
                    </label>

                    <input
                        type="number"
                        name="page_count"
                        value="{{ old('page_count') }}"
                        min="1"
                        placeholder="300"
                        class="w-full rounded-xl border border-slate-300 px-4 py-3 focus:border-blue-600 focus:ring-2 focus:ring-blue-100 outline-none"
                    >
                </div>


                <!-- Rating -->
                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-2">
                        Rating
                    </label>

                    <input
    type="file"
    name="image"
    id="image"
    accept=".jpg,.jpeg,.png,.webp"
    class="w-full rounded-xl border border-slate-300 px-4 py-3 bg-white"
>
                </div>

            </div>

        </div>


        <!-- Book Image -->
        <div class="mb-8">

            <h2 class="text-xl font-bold text-slate-900 mb-5">
                Book Cover
            </h2>

            <label class="block text-sm font-semibold text-slate-700 mb-2">
                Book Image
            </label>

            <input
                type="file"
                name="image"
                accept="image/jpeg,image/png,image/webp"
                class="w-full rounded-xl border border-slate-300 px-4 py-3 bg-white"
            >

            <p class="text-xs text-slate-500 mt-2">
                JPG, JPEG, PNG or WEBP. Maximum size: 2MB.
            </p>

        </div>


        <!-- Featured -->
        <div class="mb-8">

            <label class="flex items-center gap-3 cursor-pointer">

                <input
                    type="checkbox"
                    name="is_featured"
                    value="1"
                    {{ old('is_featured') ? 'checked' : '' }}
                    class="w-5 h-5 rounded border-slate-300 text-blue-900 focus:ring-blue-500"
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
                class="flex-1 text-center px-6 py-3 rounded-xl border border-slate-300 text-slate-700 font-semibold hover:bg-slate-50 transition"
            >
                Cancel
            </a>

            <button
                type="submit"
                class="flex-1 px-6 py-3 rounded-xl bg-blue-900 hover:bg-blue-800 text-white font-semibold transition"
            >
                Add Book
            </button>

        </div>

    </form>

</div>

@endsection