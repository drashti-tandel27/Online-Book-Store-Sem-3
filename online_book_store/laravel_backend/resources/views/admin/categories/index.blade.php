<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Categories - Admin Panel</title>

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
            padding: 35px;
        }

        /* Back to Dashboard */
        .back-section {
            margin-bottom: 20px;
        }

        .back-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 16px;
            background: #1e3a8a;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            transition: 0.2s;
        }

        .back-btn:hover {
            background: #2d66d5;
        }

        /* Header */
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .header h1 {
            font-size: 28px;
        }

        .header p {
            color: #64748b;
            margin-top: 6px;
        }

        /* Add Category Button */
        .add-btn {
            background: #173b8f;
            color: white;
            padding: 12px 20px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: bold;
        }

        .add-btn:hover {
            background: #2d66d5;
        }

        /* Alerts */
        .alert {
            padding: 14px;
            border-radius: 8px;
            margin-bottom: 20px;
            background: #dcfce7;
            color: #166534;
        }

        .error {
            background: #fee2e2;
            color: #991b1b;
        }

        /* Table */
        .table-box {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th,
        td {
            padding: 15px 12px;
            text-align: left;
            border-bottom: 1px solid #eef2f7;
        }

        th {
            color: #64748b;
            font-size: 13px;
        }

        td {
            font-size: 14px;
        }

        /* Category Image */
        .category-image {
            width: 55px;
            height: 55px;
            object-fit: cover;
            border-radius: 8px;
        }

        .no-image {
            width: 55px;
            height: 55px;
            border-radius: 8px;
            background: #eef2ff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
        }

        /* Books Count */
        .books-count {
            background: #e0e7ff;
            color: #3730a3;
            padding: 6px 10px;
            border-radius: 20px;
            font-size: 12px;
        }

        /* Actions */
        .actions {
            display: flex;
            gap: 8px;
            align-items: center;
        }

        .btn {
            padding: 7px 11px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 12px;
            font-weight: bold;
        }

        .view {
            background: #e0f2fe;
            color: #0369a1;
        }

        .view:hover {
            background: #bae6fd;
        }

        .edit {
            background: #fef3c7;
            color: #92400e;
        }

        .edit:hover {
            background: #fde68a;
        }

        .delete {
            background: #fee2e2;
            color: #b91c1c;
            border: none;
            cursor: pointer;
        }

        .delete:hover {
            background: #fecaca;
        }

        /* Pagination */
        .pagination {
            margin-top: 20px;
        }

        /* Responsive */
        @media (max-width: 768px) {

            .container {
                padding: 20px;
            }

            .header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }

            .add-btn {
                width: 100%;
                text-align: center;
            }

            .table-box {
                padding: 15px;
            }

            th,
            td {
                padding: 10px 8px;
            }
        }
    </style>
</head>

<body>

    <div class="container">

        <!-- Back to Dashboard -->
        <div class="back-section">

            <a href="{{ route('admin.dashboard') }}" class="back-btn">
                ← Back to Dashboard
            </a>

        </div>


        <!-- Header -->
        <div class="header">

            <div>

                <h1>📂 Categories</h1>

                <p>
                    Manage your book categories
                </p>

            </div>


            <a
                href="{{ route('admin.categories.create') }}"
                class="add-btn"
            >
                + Add Category
            </a>

        </div>


        <!-- Success Message -->
        @if(session('success'))

            <div class="alert">
                {{ session('success') }}
            </div>

        @endif


        <!-- Error Message -->
        @if(session('error'))

            <div class="alert error">
                {{ session('error') }}
            </div>

        @endif


        <!-- Categories Table -->
        <div class="table-box">

            <table>

                <thead>

                    <tr>

                        <th>
                            Image
                        </th>

                        <th>
                            Name
                        </th>

                        <th>
                            Slug
                        </th>

                        <th>
                            Books
                        </th>

                        <th>
                            Actions
                        </th>

                    </tr>

                </thead>


                <tbody>

                    @forelse($categories as $category)

                        <tr>

                            <!-- Image -->
                            <td>

                                @if($category->image)

                                    @if(filter_var($category->image, FILTER_VALIDATE_URL))

                                        <img
                                            src="{{ $category->image }}"
                                            class="category-image"
                                            alt="{{ $category->name }}"
                                        >

                                    @else

                                        <img
                                            src="{{ asset('storage/' . $category->image) }}"
                                            class="category-image"
                                            alt="{{ $category->name }}"
                                        >

                                    @endif

                                @else

                                    <div class="no-image">
                                        📂
                                    </div>

                                @endif

                            </td>


                            <!-- Name -->
                            <td>

                                <strong>
                                    {{ $category->name }}
                                </strong>

                            </td>


                            <!-- Slug -->
                            <td>

                                {{ $category->slug }}

                            </td>


                            <!-- Books Count -->
                            <td>

                                <span class="books-count">

                                    {{ $category->books_count }} Books

                                </span>

                            </td>


                            <!-- Actions -->
                            <td>

                                <div class="actions">

                                    <!-- View -->
                                    <a
                                        href="{{ route('admin.categories.show', $category) }}"
                                        class="btn view"
                                    >
                                        View
                                    </a>


                                    <!-- Edit -->
                                    <a
                                        href="{{ route('admin.categories.edit', $category) }}"
                                        class="btn edit"
                                    >
                                        Edit
                                    </a>


                                    <!-- Delete -->
                                    <form
                                        action="{{ route('admin.categories.destroy', $category) }}"
                                        method="POST"
                                        onsubmit="return confirm('Are you sure you want to delete this category?')"
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


                    @empty

                        <tr>

                            <td
                                colspan="5"
                                style="text-align:center; padding:30px;"
                            >
                                No categories found.
                            </td>

                        </tr>

                    @endforelse

                </tbody>

            </table>


            <!-- Pagination -->
            <div class="pagination">

                {{ $categories->links() }}

            </div>

        </div>

    </div>

</body>

</html>