<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Notifications - Admin</title>

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

        h1 {
            margin: 0;
            font-size: 28px;
        }

        .btn {
            display: inline-block;
            padding: 11px 18px;
            background: #2563eb;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            border: none;
            cursor: pointer;
        }

        .btn:hover {
            background: #1d4ed8;
        }

        .success {
            background: #dcfce7;
            color: #166534;
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .table-box {
            background: white;
            border-radius: 12px;
            overflow-x: auto;
            box-shadow: 0 2px 10px rgba(0,0,0,0.06);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 800px;
        }

        th,
        td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        th {
            background: #f8fafc;
            font-size: 14px;
        }

        .title {
            font-weight: 600;
        }

        .message {
            max-width: 280px;
            color: #6b7280;
        }

        .badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: capitalize;
        }

        .info {
            background: #dbeafe;
            color: #1d4ed8;
        }

        .success-badge {
            background: #dcfce7;
            color: #15803d;
        }

        .warning {
            background: #fef3c7;
            color: #b45309;
        }

        .error {
            background: #fee2e2;
            color: #b91c1c;
        }

        .order {
            background: #ede9fe;
            color: #6d28d9;
        }

        .read {
            color: #16a34a;
            font-weight: 600;
        }

        .unread {
            color: #dc2626;
            font-weight: 600;
        }

        .actions {
            display: flex;
            gap: 8px;
            align-items: center;
        }

        .view-btn {
            padding: 7px 12px;
            background: #eff6ff;
            color: #2563eb;
            text-decoration: none;
            border-radius: 6px;
            font-size: 13px;
        }

        .read-btn {
            padding: 7px 12px;
            background: #f0fdf4;
            color: #15803d;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }

        .delete-btn {
            padding: 7px 12px;
            background: #fef2f2;
            color: #dc2626;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }

        .pagination {
            margin-top: 20px;
        }
    </style>
</head>

<body>

<div class="container">

   <div class="header">
    <div>
        <h1>🔔 Notifications</h1>
        <p>Manage customer notifications and alerts.</p>
    </div>

    <div style="display: flex; gap: 10px;">

        <a
            href="{{ route('admin.dashboard') }}"
            class="btn"
            style="background: #6b7280;"
        >
            ← Back to Dashboard
        </a>

        <a
            href="{{ route('admin.notifications.create') }}"
            class="btn"
        >
            + Send Notification
        </a>

    </div>
</div>

    @if(session('success'))
        <div class="success">
            {{ session('success') }}
        </div>
    @endif

    <div class="table-box">

        <table>

            <thead>
                <tr>
                    <th>Title</th>
                    <th>User</th>
                    <th>Message</th>
                    <th>Type</th>
                    <th>Status</th>
                    <th>Date</th>
                    <th>Actions</th>
                </tr>
            </thead>

            <tbody>

            @forelse($notifications as $notification)

                <tr>

                    <td class="title">
                        {{ $notification->title }}
                    </td>

                    <td>
                        {{ $notification->user->name ?? 'All Users' }}
                    </td>

                    <td class="message">
                        {{ \Illuminate\Support\Str::limit($notification->message, 50) }}
                    </td>

                    <td>
                        @php
                            $typeClass = match($notification->type) {
                                'success' => 'success-badge',
                                'warning' => 'warning',
                                'error' => 'error',
                                'order' => 'order',
                                default => 'info',
                            };
                        @endphp

                        <span class="badge {{ $typeClass }}">
                            {{ $notification->type }}
                        </span>
                    </td>

                    <td>
                        @if($notification->is_read)
                            <span class="read">✓ Read</span>
                        @else
                            <span class="unread">● Unread</span>
                        @endif
                    </td>

                    <td>
                        {{ $notification->created_at->format('d M Y') }}
                    </td>

                    <td>

                        <div class="actions">

                            <a
                                href="{{ route('admin.notifications.show', $notification) }}"
                                class="view-btn"
                            >
                                View
                            </a>

                            @if(!$notification->is_read)

                                <form
                                    method="POST"
                                    action="{{ route('admin.notifications.read', $notification) }}"
                                >
                                    @csrf
                                    @method('PUT')

                                    <button class="read-btn">
                                        Read
                                    </button>
                                </form>

                            @endif

                            <form
                                method="POST"
                                action="{{ route('admin.notifications.destroy', $notification) }}"
                                onsubmit="return confirm('Delete this notification?')"
                            >
                                @csrf
                                @method('DELETE')

                                <button class="delete-btn">
                                    Delete
                                </button>
                            </form>

                        </div>

                    </td>

                </tr>

            @empty

                <tr>
                    <td colspan="7" style="text-align:center; padding:40px;">
                        No notifications found.
                    </td>
                </tr>

            @endforelse

            </tbody>

        </table>

    </div>

    <div class="pagination">
        {{ $notifications->links() }}
    </div>

</div>

</body>
</html>