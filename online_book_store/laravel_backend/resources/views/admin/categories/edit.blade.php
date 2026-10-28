<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Edit Category - Admin Panel</title>

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
            max-width: 850px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .header {
            margin-bottom: 25px;
        }

        .header h1 {
            font-size: 28px;
            margin-bottom: 8px;
        }

        .header p {
            color: #64748b;
        }

        .form-box {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            font-weight: bold;
            margin-bottom: 8px;
        }

        input,
        textarea {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid #dbe2ea;
            border-radius: 8px;
            font-size: 14px;
            outline: none;
        }

        input:focus,
        textarea:focus {
            border-color: #173b8f;
        }

        textarea {
            min-height: 120px;
            resize: vertical;
        }

        .error {
            color: #dc2626;
            font-size: 13px;
            margin-top: 6px;
        }

        .current-image {
            margin-top: 10px;
            width: 130px;
            height: 130px;
            object-fit: cover;
            border-radius: 10px;
            border: 1px solid #ddd;
        }

        .buttons {
            display: flex;
            gap: 12px;
            margin-top: 25px;
        }

        .btn {
            padding: 12px 22px;
            border-radius: 8px;
            border: none;
            text-decoration: none;
            cursor: pointer;
            font-weight: bold;
            font-size: 14px;
        }

        .save {
            background: #173b8f;
            color: white;
        }

        .save:hover {
            background: #2d66d5;
        }

        .cancel {
            background: #e5e7eb;
            color: #374151;
        }

        .cancel:hover {
            background: #d1d5db;
        }

        .required {
            color: #dc2626;
        }
    </style>
</head>

<body>

<div class="container">

    <div class="header">
        <h1>✏️ Edit Category</h1>
        <p>Update category information</p>
    </div>

    <div class="form-box">

        <form
            action="{{ route('admin.categories.update', $category) }}"
            method="POST"
            enctype="multipart/form-data"
        >

            @csrf
            @method('PUT')

            <!-- Category Name -->
            <div class="form-group">

                <label>
                    Category Name <span class="required">*</span>
                </label>

                <input
                    type="text"
                    name="name"
                    value="{{ old('name', $category->name) }}"
                    placeholder="Enter category name"
                    required
                >

                @error('name')
                    <div class="error">{{ $message }}</div>
                @enderror

            </div>


            <!-- Slug -->
            <div class="form-group">

                <label>Slug</label>

                <input
                    type="text"
                    name="slug"
                    value="{{ old('slug', $category->slug) }}"
                    placeholder="Example: fiction-books"
                >

                <small style="color:#64748b;">
                    Leave empty to generate automatically.
                </small>

                @error('slug')
                    <div class="error">{{ $message }}</div>
                @enderror

            </div>


            <!-- Description -->
            <div class="form-group">

                <label>Description</label>

                <textarea
                    name="description"
                    placeholder="Enter category description"
                >{{ old('description', $category->description) }}</textarea>

                @error('description')
                    <div class="error">{{ $message }}</div>
                @enderror

            </div>


            <!-- Current Image -->
            @if($category->image)

                <div class="form-group">

                    <label>Current Image</label>

                    @if(filter_var($category->image, FILTER_VALIDATE_URL))

                        <img
                            src="{{ $category->image }}"
                            class="current-image"
                        >

                    @else

                        <img
                            src="{{ asset('storage/' . $category->image) }}"
                            class="current-image"
                        >

                    @endif

                </div>

            @endif


            <!-- New Image -->
            <div class="form-group">

                <label>Replace Image</label>

                <input
                    type="file"
                    name="image"
                    accept="image/jpeg,image/png,image/webp"
                >

                <small style="display:block; margin-top:7px; color:#64748b;">
                    Leave empty if you don't want to change the image.
                </small>

                @error('image')
                    <div class="error">{{ $message }}</div>
                @enderror

            </div>


            <!-- Buttons -->
            <div class="buttons">

                <button
                    type="submit"
                    class="btn save"
                >
                    💾 Update Category
                </button>

                <a
                    href="{{ route('admin.categories.index') }}"
                    class="btn cancel"
                >
                    Cancel
                </a>

            </div>

        </form>

    </div>

</div>

</body>
</html>