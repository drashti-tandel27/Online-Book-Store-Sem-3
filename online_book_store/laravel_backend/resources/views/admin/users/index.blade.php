@extends('layouts.admin')

@section('title', 'Users Management - Admin')

@section('content')

<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

    <!-- Header -->
    <div class="flex items-center justify-between mb-6">

        <div>
            <a
                href="{{ route('admin.dashboard') }}"
                class="text-sm font-semibold text-blue-900 hover:text-blue-700"
            >
                ← Back to Dashboard
            </a>

            <h1 class="text-3xl font-extrabold text-slate-900 mt-4">
                👥 Users Management
            </h1>

            <p class="text-slate-500 mt-1">
                View and manage registered users.
            </p>
        </div>

    </div>


    <!-- Success Message -->
    @if(session('success'))
        <div class="mb-6 rounded-lg bg-green-50 border border-green-200 px-4 py-3 text-green-700">
            {{ session('success') }}
        </div>
    @endif


    <!-- Users Table -->
    <div class="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">

        @if($users->count() > 0)

            <div class="overflow-x-auto">

                <table class="w-full">

                    <thead class="bg-slate-50 border-b border-slate-200">

                        <tr>
                            <th class="px-6 py-4 text-left text-sm font-bold text-slate-700">
                                ID
                            </th>

                            <th class="px-6 py-4 text-left text-sm font-bold text-slate-700">
                                Name
                            </th>

                            <th class="px-6 py-4 text-left text-sm font-bold text-slate-700">
                                Email
                            </th>

                            <th class="px-6 py-4 text-left text-sm font-bold text-slate-700">
                                Registered
                            </th>

                            <th class="px-6 py-4 text-left text-sm font-bold text-slate-700">
                                Actions
                            </th>
                        </tr>

                    </thead>


                    <tbody class="divide-y divide-slate-200">

                        @foreach($users as $user)

                            <tr class="hover:bg-slate-50">

                                <td class="px-6 py-4 text-sm text-slate-600">
                                    #{{ $user->id }}
                                </td>

                                <td class="px-6 py-4">

                                    <div class="font-semibold text-slate-900">
                                        {{ $user->name }}
                                    </div>

                                </td>

                                <td class="px-6 py-4 text-sm text-slate-600">
                                    {{ $user->email }}
                                </td>

                                <td class="px-6 py-4 text-sm text-slate-600">

                                    {{ $user->created_at
                                        ? $user->created_at->format('d M Y')
                                        : '-' }}

                                </td>

                                <td class="px-6 py-4">

                                    <div class="flex items-center gap-2">

                                        <!-- View -->
                                        <a
                                            href="{{ route('admin.users.show', $user) }}"
                                            class="inline-flex items-center px-3 py-2 rounded-lg bg-blue-600 text-white text-sm font-semibold hover:bg-blue-700"
                                        >
                                            View
                                        </a>


                                        <!-- Delete -->
                                        <form
                                            action="{{ route('admin.users.destroy', $user) }}"
                                            method="POST"
                                            onsubmit="return confirm('Are you sure you want to delete this user?');"
                                        >

                                            @csrf
                                            @method('DELETE')

                                            <button
                                                type="submit"
                                                class="inline-flex items-center px-3 py-2 rounded-lg bg-red-600 text-white text-sm font-semibold hover:bg-red-700"
                                            >
                                                Delete
                                            </button>

                                        </form>

                                    </div>

                                </td>

                            </tr>

                        @endforeach

                    </tbody>

                </table>

            </div>


            <!-- Pagination -->
            <div class="px-6 py-4 border-t border-slate-200">
                {{ $users->links() }}
            </div>


        @else

            <div class="py-16 text-center">

                <div class="text-5xl mb-4">
                    👥
                </div>

                <h3 class="text-lg font-bold text-slate-800">
                    No Users Found
                </h3>

                <p class="text-sm text-slate-500 mt-1">
                    There are currently no registered users.
                </p>

            </div>

        @endif

    </div>

</div>

@endsection