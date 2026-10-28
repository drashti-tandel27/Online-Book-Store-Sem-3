<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>View Category - Admin Panel</title>

    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
        }

        body {
            background: #f5f7fb;
            color: #172554;
        }

        .container {
            max-width: 900px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .header h1 {
            font-size: 28px;
        }

        .card {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        }

        .category-top {
            display: flex;
            gap: 25px;
            align-items: center;
            padding-bottom: 25px;
            border-bottom: 1px solid #e5e7eb;
        }

        .category-image {
            width: 160px;
            height: 160px;
            object-fit: cover;
            border-radius: 12px;
        }

        .no-image {
            width: 160px;
            height: 160px;
            border-radius: 12px;
            background: #eef2ff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 50px;
        }

        .category-info h2 {
            font-size: 26px;
            margin-bottom: 10px;
        }

        .slug {
            color: #64748b;
            margin-bottom: 12px;
        }

        .books-count {
            display: inline-block;
            background: #e0e7ff;
            color: #3730a3;
            padding: 7px 12px;
            border-radius: 20px;
            font-size: 13px;
        }

        .details {
            padding-top: 25px;
        }

        .detail {
            margin-bottom: 20px;
        }

        .detail-title {
            color: #64748b;
            font-size: 13px;
            margin-bottom: 6px;
        }

        .detail-value {
            font-size: 15px;
            line-height: 1.6;
        }

        .buttons {
            display: flex;
            gap: 12px;
            margin-top: 25px;
        }

        .btn {
            padding: 12px 20px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: bold;
            font-size: 14px;
        }

        .edit {
            background: #173b8f;
            color: white;
        }

        .back {
            background: #e5e7eb;
            color: #374151;
        }

        @media(max-width: 600px) {
            .category-top {
                flex-direction: column;
                align-items: flex-start;
            }
        }
    </style>
</head>

<body>

<div class="container">

    <div class="header">
        <h1>📂 Category Details</h1>
    </div>

    <div class="card">

        <div class="category-top">

            @if($category->image)

                @if(filter_var($category->image, FILTER_VALIDATE_URL))

                    <img
                        src="{{ $category->image }}"
                        class="category-image"
                    >

                @else

                    <img
                        src="{{ asset('storage/' . $category->image) }}"
                        class="category-image"
                    >

                @endif

            @else

                <div class="no-image">
                    📂
                </div>

            @endif


            <div class="category-info">

                <h2>
                    {{ $category->name }}
                </h2>

                <div class="slug">
                    Slug: {{ $category->slug }}
                </div>

                <span class="books-count">
                    {{ $category->books_count }} Books
                </span>

            </div>

        </div>


        <div class="details">

            <div class="detail">

                <div class="detail-title">
                    Description
                </div>

                <div class="detail-value">

                    {{ $category->description ?: 'No description available.' }}

                </div>

            </div>


            <div class="detail">

                <div class="detail-title">
                    Created At
                </div>

                <div class="detail-value">

                    {{ $category->created_at->format('d M Y, h:i A') }}

                </div>

            </div>


            <div class="detail">

                <div class="detail-title">
                    Last Updated
                </div>

                <div class="detail-value">

                    {{ $category->updated_at->format('d M Y, h:i A') }}

                </div>

            </div>

        </div>


        <div class="buttons">

            <a
                href="{{ route('admin.categories.edit', $category) }}"
                class="btn edit"
            >
                ✏️ Edit Category
            </a>

            <a
                href="{{ route('admin.categories.index') }}"
                class="btn back"
            >
                ← Back to Categories
            </a>

        </div>

    </div>

</div>

</body>
</html>