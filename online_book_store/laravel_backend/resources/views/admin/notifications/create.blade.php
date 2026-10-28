<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Send Notification</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f5f7fb;
        }

        .container {
            max-width: 800px;
            margin: 40px auto;
            padding: 25px;
        }

        .card {
            background: white;
            padding: 30px;
            border-radius: 14px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06);
        }

        h1 {
            margin-top: 0;
        }

        label {
            display: block;
            margin-bottom: 7px;
            font-weight: 600;
        }

        input,
        select,
        textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #d1d5db;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 15px;
        }

        textarea {
            min-height: 130px;
            resize: vertical;
        }

        .error {
            color: #dc2626;
            font-size: 13px;
            margin-top: -15px;
            margin-bottom: 15px;
        }

        .buttons {
            display: flex;
            gap: 10px;
        }

        .btn {
            padding: 12px 20px;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            text-decoration: none;
            font-size: 15px;
        }

        .primary {
            background: #2563eb;
            color: white;
        }

        .secondary {
            background: #e5e7eb;
            color: #374151;
        }
    </style>
</head>

<body>

<div class="container">

    <div class="card">

        <h1>🔔 Send Notification</h1>

        <p>
            Send a notification to a specific customer or all users.
        </p>

        <form
            method="POST"
            action="{{ route('admin.notifications.store') }}"
        >

            @csrf

            <label>User</label>

            <select name="user_id" required>
               <option value="">
    Select User
</option>
                @foreach($users as $user)

                    <option
                        value="{{ $user->id }}"
                        {{ old('user_id') == $user->id ? 'selected' : '' }}
                    >
                        {{ $user->name }} - {{ $user->email }}
                    </option>

                @endforeach

            </select>

            @error('user_id')
                <div class="error">{{ $message }}</div>
            @enderror


            <label>Title</label>

            <input
                type="text"
                name="title"
                value="{{ old('title') }}"
                placeholder="Enter notification title"
                required
            >

            @error('title')
                <div class="error">{{ $message }}</div>
            @enderror


            <label>Message</label>

            <textarea
                name="message"
                placeholder="Enter notification message"
                required
            >{{ old('message') }}</textarea>

            @error('message')
                <div class="error">{{ $message }}</div>
            @enderror


            <label>Type</label>

            <select name="type" required>

                <option value="info">
                    Information
                </option>

                <option value="success">
                    Success
                </option>

                <option value="warning">
                    Warning
                </option>

                <option value="error">
                    Error
                </option>

                <option value="order">
                    Order
                </option>

            </select>

            @error('type')
                <div class="error">{{ $message }}</div>
            @enderror


            <div class="buttons">

    <button
        type="submit"
        class="btn primary"
    >
        Send Notification
    </button>

    <a
        href="{{ route('admin.notifications.index') }}"
        class="btn secondary"
    >
        ← Back to Notifications
    </a>

    <a
        href="{{ route('admin.dashboard') }}"
        class="btn secondary"
    >
        ← Back to Dashboard
    </a>

</div>

        </form>

    </div>

</div>

</body>
</html>