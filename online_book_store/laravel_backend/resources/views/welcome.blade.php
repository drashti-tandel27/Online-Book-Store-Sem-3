@extends('layouts.app')

@section('title', 'Online Book Store - Buy Bestselling Books Online')

@section('content')
<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 space-y-14">
    <!-- Hero Section -->
    <div class="bg-gradient-to-r from-blue-950 via-blue-900 to-blue-800 rounded-3xl p-8 sm:p-14 text-white shadow-xl flex flex-col md:flex-row items-center justify-between gap-8">
        <div class="space-y-4 max-w-xl">
            <span class="bg-amber-500 text-white text-xs font-bold px-3 py-1 rounded-full uppercase tracking-wider">Summer Reading Festival</span>
            <h1 class="text-3xl sm:text-5xl font-extrabold tracking-tight">Discover Stories That Inspire & Transform</h1>
            <p class="text-blue-100 text-sm sm:text-base">Explore thousands of titles across Technology, Science, Fiction, Self-Help and Business. Available on Web and Android App.</p>
            <div class="pt-4 flex flex-wrap gap-4">
                <a href="{{ route('books.index') }}" class="bg-white text-blue-900 font-bold px-6 py-3 rounded-xl hover:bg-blue-50 transition shadow">Browse All Books</a>
            </div>
        </div>
        <div class="hidden lg:block">
            <svg class="w-64 h-64 text-blue-400 opacity-40" fill="currentColor" viewBox="0 0 24 24">
                <path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5" />
            </svg>
        </div>
    </div>

    <!-- Categories Grid -->
    <div>
        <h2 class="text-2xl font-bold text-slate-900 mb-6">Popular Genres & Categories</h2>
        <div class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-6 gap-4">
            @foreach($categories as $category)
            <div class="bg-white border border-slate-200 rounded-2xl p-4 text-center hover:border-blue-500 hover:shadow-md transition">
                <p class="font-bold text-sm text-slate-800">{{ $category->name }}</p>
                <span class="text-xs text-slate-500">{{ $category->books_count }} books</span>
            </div>
            @endforeach
        </div>
    </div>

    <!-- Featured Books -->
    <div>
        <div class="flex items-center justify-between mb-6">
            <h2 class="text-2xl font-bold text-slate-900">Featured Bestsellers</h2>
            <a href="{{ route('books.index') }}" class="text-sm font-bold text-blue-900 hover:underline">View All →</a>
        </div>
        <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
            @foreach($featuredBooks as $book)
            <div class="bg-white border border-slate-200 rounded-2xl overflow-hidden shadow-sm hover:shadow-lg transition flex flex-col justify-between">
                <div class="h-64 bg-slate-100 flex items-center justify-center p-4">
                    <img src="{{ $book->image }}" alt="{{ $book->title }}" class="h-full object-contain rounded shadow">
                </div>
                <div class="p-5 flex flex-col justify-between flex-grow">
                    <div>
                        <span class="text-xs font-semibold text-blue-800 uppercase tracking-wider">{{ $book->category->name ?? 'General' }}</span>
                        <h3 class="font-bold text-base text-slate-900 mt-1 line-clamp-1">{{ $book->title }}</h3>
                        <p class="text-xs text-slate-500 mb-3">by {{ $book->author }}</p>
                    </div>
                    <div class="flex items-center justify-between pt-4 border-t border-slate-100">
                        <div>
                            @if($book->discount_price)
                                <span class="font-extrabold text-lg text-blue-950">${{ number_format($book->discount_price, 2) }}</span>
                                <span class="text-xs text-slate-400 line-through">${{ number_format($book->price, 2) }}</span>
                            @else
                                <span class="font-extrabold text-lg text-blue-950">${{ number_format($book->price, 2) }}</span>
                            @endif
                        </div>
                        <span class="bg-amber-100 text-amber-800 text-xs font-bold px-2 py-1 rounded">★ {{ number_format($book->rating, 1) }}</span>
                    </div>
                </div>
            </div>
            @endforeach
        </div>
    </div>
</div>
@endsection
