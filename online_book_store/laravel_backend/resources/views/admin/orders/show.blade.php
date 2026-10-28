<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Order Details - Admin Panel</title>

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
            max-width: 1000px;
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
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
        }

        .card h2 {
            margin-top: 0;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 18px;
        }

        .info-item {
            padding: 15px;
            background: #f8fafc;
            border-radius: 8px;
        }

        .label {
            color: #6b7280;
            font-size: 13px;
            margin-bottom: 5px;
        }

        .value {
            font-weight: 600;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th,
        td {
            padding: 14px;
            text-align: left;
            border-bottom: 1px solid #e5e7eb;
        }

        th {
            background: #f8fafc;
        }

        .book-image {
            width: 55px;
            height: 70px;
            object-fit: cover;
            border-radius: 6px;
        }

        .status-form {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }

        select {
            padding: 10px;
            border: 1px solid #d1d5db;
            border-radius: 7px;
        }

        .update-btn {
            border: none;
            background: #16a34a;
            color: white;
            padding: 10px 18px;
            border-radius: 7px;
            cursor: pointer;
        }

        .total {
            text-align: right;
            font-size: 20px;
            font-weight: bold;
            margin-top: 20px;
        }

        @media (max-width: 700px) {
            .info-grid {
                grid-template-columns: 1fr;
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

        <h1>🛒 Order Details</h1>

        <a
            href="{{ route('admin.orders.index') }}"
            class="back-btn"
        >
            ← Back to Orders
        </a>

    </div>


    {{-- Order Information --}}

    <div class="card">

        <h2>
            Order #{{ $order->order_number ?? $order->id }}
        </h2>

        <div class="info-grid">

            <div class="info-item">
                <div class="label">Customer</div>
                <div class="value">
                    {{ $order->user->name ?? 'Guest' }}
                </div>
            </div>

            <div class="info-item">
                <div class="label">Email</div>
                <div class="value">
                    {{ $order->user->email ?? 'N/A' }}
                </div>
            </div>

            <div class="info-item">
                <div class="label">Order Date</div>
                <div class="value">
                    {{ $order->created_at->format('d M Y, h:i A') }}
                </div>
            </div>

            <div class="info-item">
                <div class="label">Payment Method</div>
                <div class="value">
                    {{ $order->payment_method ?? 'N/A' }}
                </div>
            </div>

            <div class="info-item">
                <div class="label">Payment Status</div>
                <div class="value">
                    {{ $order->payment_status ?? 'N/A' }}
                </div>
            </div>

            <div class="info-item">
                <div class="label">Order Status</div>
                <div class="value">
                    {{ $order->status }}
                </div>
            </div>

        </div>


        {{-- Status Update --}}

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
                Update Status
            </button>

        </form>

    </div>


    {{-- Customer / Shipping Information --}}

    <div class="card">

        <h2>📍 Customer Information</h2>

        <div class="info-grid">

            <div class="info-item">
                <div class="label">Name</div>
                <div class="value">
                    {{ $order->user->name ?? 'Guest' }}
                </div>
            </div>

            <div class="info-item">
                <div class="label">Email</div>
                <div class="value">
                    {{ $order->user->email ?? 'N/A' }}
                </div>
            </div>

        </div>

    </div>


    {{-- Order Items --}}

    <div class="card">

        <h2>📚 Ordered Books</h2>

        @if($order->items && $order->items->count())

            <table>

                <thead>
                    <tr>
                        <th>Book</th>
                        <th>Price</th>
                        <th>Quantity</th>
                        <th>Subtotal</th>
                    </tr>
                </thead>

                <tbody>

                    @foreach($order->items as $item)

                        <tr>

                            <td>

                                @if($item->book)

                                    <div style="display:flex; align-items:center; gap:12px;">

                                        @if($item->book->image)

                                            @if(filter_var($item->book->image, FILTER_VALIDATE_URL))

                                                <img
                                                    src="{{ $item->book->image }}"
                                                    class="book-image"
                                                    alt="{{ $item->book->title }}"
                                                >

                                            @else

                                                <img
                                                    src="{{ asset('storage/' . $item->book->image) }}"
                                                    class="book-image"
                                                    alt="{{ $item->book->title }}"
                                                >

                                            @endif

                                        @endif

                                        <strong>
                                            {{ $item->book->title }}
                                        </strong>

                                    </div>

                                @else

                                    Book unavailable

                                @endif

                            </td>

                            <td>
                                ₹{{ number_format($item->price, 2) }}
                            </td>

                            <td>
                                {{ $item->quantity }}
                            </td>

                            <td>
                                ₹{{ number_format($item->price * $item->quantity, 2) }}
                            </td>

                        </tr>

                    @endforeach

                </tbody>

            </table>

            <div class="total">
                Total:
                ₹{{ number_format($order->total_amount, 2) }}
            </div>

        @else

            <p>No items found for this order.</p>

        @endif

    </div>

</div>

</body>
</html>