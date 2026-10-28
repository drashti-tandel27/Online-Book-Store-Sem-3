<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Review Details - Admin Panel</title>

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
            max-width: 800px;
            margin: 40px auto;
            padding: 20px;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .header h1 {
            margin: 0;
        }

        .back-btn {
            text-decoration: none;
            background: #2563eb;
            color: white;
            padding: 11px 18px;
            border-radius: 8px;
        }

        .card {
            background: white;
            border-radius: 14px;
            padding: 30px;
            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06);
        }

        .row {
            padding: 17px 0;
            border-bottom: 1px solid #e5e7eb;
        }

        .label {
            color: #6b7280;
            font-size: 13px;
            margin-bottom: 6px;
        }

        .value {
            font-size: 16px;
            font-weight: 600;
        }

        .stars {
            color: #f59e0b;
            font-size: 25px;
        }

        .review-text {
            margin-top: 10px;
            padding: 18px;
            background: #f8fafc;
            border-radius: 8px;
            line-height: 1.6;
            font-weight: normal;
        }

        .actions {
            display: flex;
            gap: 10px;
            margin-top: 25px;
        }

        .delete {
            background: #dc2626;
            color: white;
            padding: 11px 18px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
        }
    </style>
</head>

<body>

<div class="container">

    <div class="header">

        <h1>⭐ Review Details</h1>

        <a
            href="{{ route('admin.reviews.index') }}"
            class="back-btn"
        >
            ← Back to Reviews
        </a>

    </div>


    <div class="card">

        <div class="row">

            <div class="label">
                Review ID
            </div>

            <div class="value">
                #{{ $review->id }}
            </div>

        </div>


        <div class="row">

            <div class="label">
                Customer
            </div>

            <div class="value">
                {{ $review->user->name ?? 'Guest' }}
            </div>

        </div>


        <div class="row">

            <div class="label">
                Email
            </div>

            <div class="value">
                {{ $review->user->email ?? 'N/A' }}
            </div>

        </div>


        <div class="row">

            <div class="label">
                Book
            </div>

            <div class="value">
                {{ $review->book->title ?? 'Book unavailable' }}
            </div>

        </div>


        <div class="row">

            <div class="label">
                Rating
            </div>

            <div class="stars">

                @for($i = 1; $i <= 5; $i++)

                    {{ $i <= $review->rating ? '★' : '☆' }}

                @endfor

                <span style="font-size:15px; color:#374151;">
                    ({{ $review->rating }}/5)
                </span>

            </div>

        </div>


        <div class="row">

            <div class="label">
                Review
            </div>

            <div class="review-text">
                {{ $review->comment }}
            </div>

        </div>


        <div class="row">

            <div class="label">
                Submitted On
            </div>

            <div class="value">
                {{ $review->created_at->format('d M Y, h:i A') }}
            </div>

        </div>


        <div class="actions">

            <form
                action="{{ route('admin.reviews.destroy', $review) }}"
                method="POST"
                onsubmit="return confirm('Are you sure you want to delete this review?');"
            >

                @csrf
                @method('DELETE')

                <button
                    type="submit"
                    class="delete"
                >
                    🗑 Delete Review
                </button>

            </form>

        </div>

    </div>

</div>

</body>

</html>