<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Orders - Admin Panel</title>

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
            white-space: nowrap;
        }

        th {
            background: #f8fafc;
            font-size: 14px;
        }

        td {
            font-size: 14px;
        }

        .status {
            display: inline-block;
            padding: 6px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .pending {
            background: #fef3c7;
            color: #92400e;
        }

        .processing {
            background: #dbeafe;
            color: #1e40af;
        }

        .shipped {
            background: #e0e7ff;
            color: #3730a3;
        }

        .delivered {
            background: #dcfce7;
            color: #166534;
        }

        .cancelled {
            background: #fee2e2;
            color: #991b1b;
        }

        .actions {
            display: flex;
            gap: 8px;
            align-items: center;
        }

        .view-btn {
            text-decoration: none;
            background: #2563eb;
            color: white;
            padding: 8px 12px;
            border-radius: 6px;
            font-size: 13px;
        }

        .status-form {
            display: flex;
            gap: 6px;
        }

        select {
            padding: 8px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
        }

        .update-btn {
            border: none;
            background: #16a34a;
            color: white;
            padding: 8px 12px;
            border-radius: 6px;
            cursor: pointer;
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

        <h1>🛒 Orders Management</h1>

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

        @if($orders->count() > 0)

            <table>

                <thead>
                    <tr>
                        <th>Order</th>
                        <th>Customer</th>
                        <th>Total</th>
                        <th>Status</th>
                        <th>Date</th>
                        <th>Actions</th>
                    </tr>
                </thead>

                <tbody>

                    @foreach($orders as $order)

                        @php
                            $statusClass = strtolower($order->status);
                        @endphp

                        <tr>

                            <td>
                                <strong>
                                    #{{ $order->order_number ?? $order->id }}
                                </strong>
                            </td>

                            <td>
                                {{ $order->user->name ?? 'Guest' }}
                            </td>

                            <td>
                                ₹{{ number_format($order->total_amount, 2) }}
                            </td>

                            <td>
                                <span class="status {{ $statusClass }}">
                                    {{ $order->status }}
                                </span>
                            </td>

                            <td>
                                {{ $order->created_at->format('d M Y') }}
                            </td>

                            <td>

                                <div class="actions">

                                    <a
                                        href="{{ route('admin.orders.show', $order) }}"
                                        class="view-btn"
                                    >
                                        View
                                    </a>

                                    <form
                                        action="{{ route('admin.orders.update', $order) }}"
                                        method="POST"
                                        class="status-form"
                                    >

                                        @csrf
                                        @method('PUT')

                                        <select name="status">

                                            <option
                                                value="Pending"
                                                {{ $order->status === 'Pending' ? 'selected' : '' }}
                                            >
                                                Pending
                                            </option>

                                            <option
                                                value="Processing"
                                                {{ $order->status === 'Processing' ? 'selected' : '' }}
                                            >
                                                Processing
                                            </option>

                                            <option
                                                value="Shipped"
                                                {{ $order->status === 'Shipped' ? 'selected' : '' }}
                                            >
                                                Shipped
                                            </option>

                                            <option
                                                value="Delivered"
                                                {{ $order->status === 'Delivered' ? 'selected' : '' }}
                                            >
                                                Delivered
                                            </option>

                                            <option
                                                value="Cancelled"
                                                {{ $order->status === 'Cancelled' ? 'selected' : '' }}
                                            >
                                                Cancelled
                                            </option>

                                        </select>

                                        <button
                                            type="submit"
                                            class="update-btn"
                                        >
                                            Update
                                        </button>

                                    </form>

                                </div>

                            </td>

                        </tr>

                    @endforeach

                </tbody>

            </table>

            <div class="pagination">
                {{ $orders->links() }}
            </div>

        @else

            <div class="empty">
                No orders found.
            </div>

        @endif

    </div>

</div>

</body>
</html>