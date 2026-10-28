<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>User Details - Admin Panel</title>

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
            max-width: 900px;
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
            font-size: 28px;
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

        .user-icon {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: #2563eb;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 36px;
            margin-bottom: 25px;
        }

        .row {
            display: grid;
            grid-template-columns: 180px 1fr;
            padding: 16px 0;
            border-bottom: 1px solid #e5e7eb;
        }

        .label {
            font-weight: bold;
            color: #6b7280;
        }

        .value {
            color: #111827;
        }

        .actions {
            margin-top: 25px;
            display: flex;
            gap: 10px;
        }

        .btn {
            text-decoration: none;
            padding: 11px 18px;
            border-radius: 8px;
            color: white;
            border: none;
            cursor: pointer;
            font-size: 14px;
        }

        .edit {
            background: #f59e0b;
        }

        .delete {
            background: #dc2626;
        }

        @media (max-width: 600px) {
            .row {
                grid-template-columns: 1fr;
                gap: 6px;
            }

            .header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
        }
    </style>
</head>

<body>

<div class="container">

    <div class="header">
        <h1>👤 User Details</h1>

        <a href="{{ route('admin.users.index') }}" class="back-btn">
            ← Back to Users
        </a>
    </div>

    <div class="card">

        <div class="user-icon">
            👤
        </div>

        <div class="row">
            <div class="label">User ID</div>
            <div class="value">#{{ $user->id }}</div>
        </div>

        <div class="row">
            <div class="label">Name</div>
            <div class="value">{{ $user->name }}</div>
        </div>

        <div class="row">
            <div class="label">Email</div>
            <div class="value">{{ $user->email }}</div>
        </div>

        <div class="row">
            <div class="label">Registered</div>
            <div class="value">
                {{ $user->created_at->format('d M Y, h:i A') }}
            </div>
        </div>

        <div class="row">
            <div class="label">Last Updated</div>
            <div class="value">
                {{ $user->updated_at->format('d M Y, h:i A') }}
            </div>
        </div>

        <div class="actions">

           
            <form
                action="{{ route('admin.users.destroy', $user) }}"
                method="POST"
                onsubmit="return confirm('Are you sure you want to delete this user?');"
            >

                @csrf
                @method('DELETE')

                <button type="submit" class="btn delete">
                    🗑 Delete User
                </button>

            </form>

        </div>

    </div>

</div>

</body>
</html>