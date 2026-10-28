@extends('layouts.admin')

@section('title', 'Manage Books - Admin')

@section('content')

<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">

    <!-- Back to Dashboard -->
    <div class="mb-6">
        <a
            href="{{ route('admin.dashboard') }}"
            class="inline-flex items-center gap-2 text-blue-900 hover:text-blue-700 font-semibold text-sm"
        >
            ← Back to Dashboard
        </a>
    </div>

    <!-- Header -->
    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-8">

        <div>
            <h1 class="text-3xl font-extrabold text-slate-900">
                Manage Books
            </h1>

            <p class="text-sm text-slate-500 mt-1">
                Add, edit and manage books in your online store.
            </p>
        </div>

        <a
            href="{{ route('admin.books.create') }}"
            class="inline-flex items-center justify-center bg-blue-900 hover:bg-blue-800 text-white font-semibold px-5 py-3 rounded-xl transition"
        >
            + Add New Book
        </a>

    </div>


    <!-- Success Message -->
    @if(session('success'))
        <div class="mb-6 bg-emerald-100 border border-emerald-200 text-emerald-800 px-4 py-3 rounded-xl">
            {{ session('success') }}
        </div>
    @endif


    <!-- Error Message -->
    @if(session('error'))
        <div class="mb-6 bg-rose-100 border border-rose-200 text-rose-800 px-4 py-3 rounded-xl">
            {{ session('error') }}
        </div>
    @endif


    <!-- Validation Errors -->
    @if($errors->any())
        <div class="mb-6 bg-rose-100 border border-rose-200 text-rose-800 px-4 py-3 rounded-xl">
            <ul class="list-disc list-inside text-sm">
                @foreach($errors->all() as $error)
                    <li>{{ $error }}</li>
                @endforeach
            </ul>
        </div>
    @endif


    <!-- Books Table -->
    <div class="bg-white border border-slate-200 rounded-2xl shadow-sm overflow-hidden">

        <div class="overflow-x-auto">

            <table class="w-full text-left text-sm">

                <thead>
                    <tr class="bg-slate-50 border-b border-slate-200 text-xs uppercase text-slate-600">

                        <th class="py-4 px-6">Book</th>
                        <th class="py-4 px-6">Category</th>
                        <th class="py-4 px-6">Author</th>
                        <th class="py-4 px-6">Price</th>
                        <th class="py-4 px-6">Stock</th>
                        <th class="py-4 px-6">Featured</th>
                        <th class="py-4 px-6 text-right">Actions</th>

                    </tr>
                </thead>


                <tbody class="divide-y divide-slate-100">

                    @forelse($books as $book)

                        <tr class="hover:bg-slate-50 transition">

                            <!-- Book -->
                            <td class="py-4 px-6">

                                <div class="flex items-center gap-3">

                                    @if($book->image)

                                        <img
                                            src="{{ asset('storage/' . $book->image) }}"
                                            alt="{{ $book->title }}"
                                            class="w-12 h-16 object-cover rounded-lg border border-slate-200"
                                        >

                                    @else

                                        <div class="w-12 h-16 bg-slate-100 rounded-lg flex items-center justify-center text-slate-400">
                                            📚
                                        </div>

                                    @endif


                                    <div>
                                        <p class="font-bold text-slate-900">
                                            {{ $book->title }}
                                        </p>

                                        <p class="text-xs text-slate-500">
                                            ISBN: {{ $book->isbn ?? 'N/A' }}
                                        </p>
                                    </div>

                                </div>

                            </td>


                            <!-- Category -->
                            <td class="py-4 px-6 text-slate-600">
                                {{ $book->category->name ?? 'Uncategorized' }}
                            </td>


                            <!-- Author -->
                            <td class="py-4 px-6 text-slate-600">
                                {{ $book->author }}
                            </td>


                            <!-- Price -->
                            <td class="py-4 px-6">

                                @if($book->discount_price)

                                    <p class="font-bold text-blue-900">
                                        ₹{{ number_format($book->discount_price, 2) }}
                                    </p>

                                    <p class="text-xs text-slate-400 line-through">
                                        ₹{{ number_format($book->price, 2) }}
                                    </p>

                                @else

                                    <p class="font-bold text-blue-900">
                                        ₹{{ number_format($book->price, 2) }}
                                    </p>

                                @endif

                            </td>


                            <!-- Stock -->
                            <td class="py-4 px-6">

                                @if($book->stock > 0)

                                    <span class="px-2.5 py-1 bg-emerald-100 text-emerald-800 text-xs font-bold rounded-full">
                                        {{ $book->stock }}
                                    </span>

                                @else

                                    <span class="px-2.5 py-1 bg-rose-100 text-rose-800 text-xs font-bold rounded-full">
                                        Out of Stock
                                    </span>

                                @endif

                            </td>


                            <!-- Featured -->
                            <td class="py-4 px-6">

                                @if($book->is_featured)

                                    <span class="px-2.5 py-1 bg-amber-100 text-amber-800 text-xs font-bold rounded-full">
                                        Featured
                                    </span>

                                @else

                                    <span class="text-xs text-slate-400">
                                        No
                                    </span>

                                @endif

                            </td>


                            <!-- Actions -->
                            <td class="py-4 px-6">

                                <div class="flex justify-end gap-2">

                                    <!-- View -->
                                    <a
                                        href="{{ route('admin.books.show', $book) }}"
                                        class="px-3 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-lg text-xs font-semibold"
                                    >
                                        View
                                    </a>


                                    <!-- Edit -->
                                    <a
                                        href="{{ route('admin.books.edit', $book) }}"
                                        class="px-3 py-2 bg-blue-100 hover:bg-blue-200 text-blue-800 rounded-lg text-xs font-semibold"
                                    >
                                        Edit
                                    </a>


                                    <!-- Delete -->
                                    <form
                                        action="{{ route('admin.books.destroy', $book) }}"
                                        method="POST"
                                        onsubmit="return confirm('Are you sure you want to delete this book?');"
                                    >

                                        @csrf
                                        @method('DELETE')

                                        <button
                                            type="submit"
                                            class="px-3 py-2 bg-rose-100 hover:bg-rose-200 text-rose-800 rounded-lg text-xs font-semibold"
                                        >
                                            Delete
                                        </button>

                                    </form>

                                </div>

                            </td>

                        </tr>


                    @empty

                        <tr>
                            <td
                                colspan="7"
                                class="py-12 text-center text-slate-400"
                            >
                                No books found.
                            </td>
                        </tr>

                    @endforelse

                </tbody>

            </table>

        </div>


        <!-- Pagination -->
        @if($books->hasPages())

            <div class="px-6 py-4 border-t border-slate-100">
                {{ $books->links() }}
            </div>

        @endif

    </div>

</div>

@endsection