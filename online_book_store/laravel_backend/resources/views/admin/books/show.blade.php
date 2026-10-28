@extends('layouts.app')

@section('title', 'Book Details - Admin')

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
            Book Details
        </h1>
    </div>

    <!-- Book Details Card -->
    <div class="bg-white border border-slate-200 rounded-2xl shadow-sm overflow-hidden">

        <div class="grid grid-cols-1 md:grid-cols-3 gap-8 p-6 sm:p-8">

            <!-- Book Image -->
            <div class="md:col-span-1">

                @if($book->image)

                    @if(filter_var($book->image, FILTER_VALIDATE_URL))

                        <img
                            src="{{ $book->image }}"
                            alt="{{ $book->title }}"
                            class="w-full max-w-xs mx-auto h-96 object-cover rounded-2xl border border-slate-200"
                        >

                    @else

                        <img
                            src="{{ asset('storage/' . $book->image) }}"
                            alt="{{ $book->title }}"
                            class="w-full max-w-xs mx-auto h-96 object-cover rounded-2xl border border-slate-200"
                        >

                    @endif

                @else

                    <div class="w-full max-w-xs mx-auto h-96 rounded-2xl bg-slate-100 flex items-center justify-center text-slate-400">
                        No Image Available
                    </div>

                @endif

            </div>

            <!-- Book Information -->
            <div class="md:col-span-2">

                <div class="flex items-start justify-between gap-4">

                    <div>
                        <h2 class="text-2xl font-extrabold text-slate-900">
                            {{ $book->title }}
                        </h2>

                        <p class="text-slate-500 mt-2">
                            by {{ $book->author }}
                        </p>
                    </div>

                    @if($book->is_featured)
                        <span class="shrink-0 bg-amber-100 text-amber-800 text-xs font-bold px-3 py-1.5 rounded-full">
                            Featured
                        </span>
                    @endif

                </div>

                <!-- Category -->
                <div class="mt-6">
                    <p class="text-xs font-bold text-slate-500 uppercase">
                        Category
                    </p>

                    <p class="text-slate-900 font-semibold mt-1">
                        {{ $book->category->name ?? 'Uncategorized' }}
                    </p>
                </div>

                <!-- Price -->
                <div class="mt-5">

                    <p class="text-xs font-bold text-slate-500 uppercase">
                        Price
                    </p>

                    <div class="flex items-center gap-3 mt-1">

                        @if($book->discount_price && $book->discount_price < $book->price)

                            <span class="text-2xl font-extrabold text-blue-900">
                                ₹{{ number_format($book->discount_price, 2) }}
                            </span>

                            <span class="text-sm text-slate-400 line-through">
                                ₹{{ number_format($book->price, 2) }}
                            </span>

                        @else

                            <span class="text-2xl font-extrabold text-blue-900">
                                ₹{{ number_format($book->price, 2) }}
                            </span>

                        @endif

                    </div>

                </div>

                <!-- Stock & Rating -->
                <div class="grid grid-cols-2 gap-5 mt-5">

                    <div>
                        <p class="text-xs font-bold text-slate-500 uppercase">
                            Stock
                        </p>

                        <p class="font-semibold text-slate-900 mt-1">
                            {{ $book->stock }}
                        </p>
                    </div>

                    <div>
                        <p class="text-xs font-bold text-slate-500 uppercase">
                            Rating
                        </p>

                        <p class="font-semibold text-slate-900 mt-1">
                            ⭐ {{ number_format($book->rating, 1) }}
                        </p>
                    </div>

                </div>

                <!-- ISBN -->
                @if($book->isbn)
                    <div class="mt-5">
                        <p class="text-xs font-bold text-slate-500 uppercase">
                            ISBN
                        </p>

                        <p class="font-semibold text-slate-900 mt-1">
                            {{ $book->isbn }}
                        </p>
                    </div>
                @endif

                <!-- Publisher -->
                @if($book->publisher)
                    <div class="mt-5">
                        <p class="text-xs font-bold text-slate-500 uppercase">
                            Publisher
                        </p>

                        <p class="font-semibold text-slate-900 mt-1">
                            {{ $book->publisher }}
                        </p>
                    </div>
                @endif

                <!-- Published Year -->
                @if($book->published_year)
                    <div class="mt-5">
                        <p class="text-xs font-bold text-slate-500 uppercase">
                            Published Year
                        </p>

                        <p class="font-semibold text-slate-900 mt-1">
                            {{ $book->published_year }}
                        </p>
                    </div>
                @endif

            </div>

        </div>

        <!-- Description -->
        @if($book->description)

            <div class="border-t border-slate-200 p-6 sm:p-8">

                <h3 class="text-lg font-bold text-slate-900 mb-3">
                    Description
                </h3>

                <p class="text-slate-600 leading-7">
                    {{ $book->description }}
                </p>

            </div>

        @endif

        <!-- Actions -->
        <div class="border-t border-slate-200 p-6 sm:p-8 flex flex-col sm:flex-row gap-3">

            <a
                href="{{ route('admin.books.edit', $book) }}"
                class="flex-1 text-center px-6 py-3 rounded-xl bg-blue-900 hover:bg-blue-800 text-white font-semibold transition"
            >
                Edit Book
            </a>

            <a
                href="{{ route('admin.books.index') }}"
                class="flex-1 text-center px-6 py-3 rounded-xl border border-slate-300 text-slate-700 font-semibold hover:bg-slate-50 transition"
            >
                Back to Books
            </a>

        </div>

    </div>

</div>

@endsection