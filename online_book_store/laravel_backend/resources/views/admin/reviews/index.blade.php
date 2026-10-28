<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Reviews - Admin Panel</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f5f7fb;
            color: #1f2937;
        }

        .container {
            padding: 30px;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .header h1 {
            margin: 0;
            font-size: 28px;
        }

        .back-btn {
            text-decoration: none;
            background: #2563eb;
            color: white;
            padding: 11px 18px;
            border-radius: 8px;
        }

        .success {
            background: #dcfce7;
            color: #166534;
            padding: 14px 18px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .table-box {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th,
        td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #e5e7eb;
        }

        th {
            background: #f8fafc;
            font-size: 14px;
        }

        td {
            font-size: 14px;
        }

        .rating {
            color: #f59e0b;
            font-weight: bold;
        }

        .comment {
            max-width: 350px;
        }

        .actions {
            display: flex;
            gap: 8px;
        }

        .btn {
            text-decoration: none;
            padding: 8px 12px;
            border-radius: 6px;
            color: white;
            border: none;
            cursor: pointer;
            font-size: 13px;
        }

        .view {
            background: #2563eb;
        }

        .delete {
            background: #dc2626;
        }

        .empty {
            text-align: center;
            padding: 30px;
            color: #6b7280;
        }

        .pagination {
            margin-top: 20px;
        }
    </style>
</head>

<body>

<div class="container">

    <div class="header">

        <h1>⭐ Reviews Management</h1>

        <a
            href="{{ route('admin.dashboard') }}"
            class="back-btn"
        >
            ← Dashboard
        </a>

    </div>


    @if(session('success'))

        <div class="success">
            {{ session('success') }}
        </div>

    @endif


    <div class="table-box">

        @if($reviews->count() > 0)

            <table>

                <thead>

                    <tr>
                        <th>ID</th>
                        <th>Customer</th>
                        <th>Book</th>
                        <th>Rating</th>
                        <th>Review</th>
                        <th>Date</th>
                        <th>Actions</th>
                    </tr>

                </thead>


                <tbody>

                    @foreach($reviews as $review)

                        <tr>

                            <td>
                                #{{ $review->id }}
                            </td>

                            <td>
                                {{ $review->user->name ?? 'Guest' }}
                            </td>

                            <td>
                                {{ $review->book->title ?? 'Book unavailable' }}
                            </td>

                            <td class="rating">

                                @for($i = 1; $i <= 5; $i++)

                                    {{ $i <= $review->rating ? '★' : '☆' }}

                                @endfor

                                <br>

                                {{ $review->rating }}/5

                            </td>

                            <td class="comment">
                                {{ \Illuminate\Support\Str::limit($review->comment, 80) }}
                            </td>

                            <td>
                                {{ $review->created_at->format('d M Y') }}
                            </td>

                            <td>

                                <div class="actions">

                                    <a
                                        href="{{ route('admin.reviews.show', $review) }}"
                                        class="btn view"
                                    >
                                        View
                                    </a>


                                    <form
                                        action="{{ route('admin.reviews.destroy', $review) }}"
                                        method="POST"
                                        onsubmit="return confirm('Are you sure you want to delete this review?');"
                                    >

                                        @csrf
                                        @method('DELETE')

                                        <button
                                            type="submit"
                                            class="btn delete"
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


            <div class="pagination">
                {{ $reviews->links() }}
            </div>

        @else

            <div class="empty">
                No reviews found.
            </div>

        @endif

    </div>

</div>

</body>

</html>