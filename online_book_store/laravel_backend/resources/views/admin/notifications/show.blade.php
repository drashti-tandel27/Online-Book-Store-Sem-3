<!DOCTYPE html>
<html lang="en">
<head>

    <meta charset="UTF-8">

    <meta
        name="viewport"
        content="width=device-width, initial-scale=1.0"
    >

    <title>Notification Details</title>

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

        .row {
            padding: 15px 0;
            border-bottom: 1px solid #eee;
        }

        .label {
            font-size: 13px;
            color: #6b7280;
            margin-bottom: 5px;
        }

        .value {
            font-size: 16px;
            font-weight: 600;
        }

        .message {
            font-weight: normal;
            line-height: 1.6;
        }

        .buttons {
            margin-top: 25px;
            display: flex;
            gap: 10px;
        }

        .btn {
            padding: 11px 18px;
            border-radius: 8px;
            border: none;
            text-decoration: none;
            cursor: pointer;
        }

        .back {
            background: #e5e7eb;
            color: #374151;
        }

        .delete {
            background: #dc2626;
            color: white;
        }

    </style>

</head>

<body>

<div class="container">

    <div class="card">

        <h1>🔔 Notification Details</h1>

        <div class="row">

            <div class="label">
                Title
            </div>

            <div class="value">
                {{ $notification->title }}
            </div>

        </div>


        <div class="row">

            <div class="label">
                User
            </div>

            <div class="value">

                @if($notification->user)

                    {{ $notification->user->name }}
                    -
                    {{ $notification->user->email }}

                @else

                    All Users

                @endif

            </div>

        </div>


        <div class="row">

            <div class="label">
                Type
            </div>

            <div class="value">
                {{ ucfirst($notification->type) }}
            </div>

        </div>


        <div class="row">

            <div class="label">
                Status
            </div>

            <div class="value">

                @if($notification->is_read)

                    ✓ Read

                @else

                    ● Unread

                @endif

            </div>

        </div>


        @if($notification->order)

            <div class="row">

                <div class="label">
                    Order
                </div>

                <div class="value">
                    #{{ $notification->order->order_number }}
                </div>

            </div>

        @endif


        <div class="row">

            <div class="label">
                Message
            </div>

            <div class="message">
                {{ $notification->message }}
            </div>

        </div>


        <div class="row">

            <div class="label">
                Created
            </div>

            <div class="value">
                {{ $notification->created_at->format('d M Y, h:i A') }}
            </div>

        </div>


        <div class="buttons">

            <a
                href="{{ route('admin.notifications.index') }}"
                class="btn back"
            >
                ← Back
            </a>

            <form
                method="POST"
                action="{{ route('admin.notifications.destroy', $notification) }}"
                onsubmit="return confirm('Delete this notification?')"
            >

                @csrf
                @method('DELETE')

                <button class="btn delete">
                    Delete
                </button>

            </form>

        </div>

    </div>

</div>

</body>
</html>