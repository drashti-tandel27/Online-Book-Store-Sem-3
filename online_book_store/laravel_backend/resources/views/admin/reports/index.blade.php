<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta
        name="viewport"
        content="width=device-width, initial-scale=1.0"
    >

    <title>Reports - Admin Panel</title>

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
            margin-bottom: 30px;
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

        .cards {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 25px;
        }

        .card {
            background: white;
            padding: 24px;
            border-radius: 14px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }

        .icon {
            font-size: 28px;
            margin-bottom: 12px;
        }

        .label {
            color: #6b7280;
            font-size: 14px;
            margin-bottom: 8px;
        }

        .number {
            font-size: 28px;
            font-weight: bold;
        }

        .section {
            background: white;
            padding: 25px;
            border-radius: 14px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }

        .section h2 {
            margin-top: 0;
        }

        .status-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 15px;
        }

        .status-card {
            padding: 20px;
            border-radius: 10px;
            background: #f8fafc;
        }

        .status-card h3 {
            margin: 0 0 8px;
            font-size: 15px;
        }

        .status-card p {
            margin: 0;
            font-size: 24px;
            font-weight: bold;
        }

        @media (max-width: 900px) {

            .cards {
                grid-template-columns: repeat(2, 1fr);
            }

            .status-grid {
                grid-template-columns: repeat(2, 1fr);
            }

        }

        @media (max-width: 600px) {

            .container {
                padding: 20px;
            }

            .header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }

            .cards,
            .status-grid {
                grid-template-columns: 1fr;
            }

        }

    </style>

</head>


<body>

<div class="container">


    <div class="header">

        <h1>📈 Reports</h1>

        <a
            href="{{ route('admin.dashboard') }}"
            class="back-btn"
        >
            ← Dashboard
        </a>

    </div>


    {{-- Main Statistics --}}

    <div class="cards">


        <div class="card">

            <div class="icon">
                📚
            </div>

            <div class="label">
                Total Books
            </div>

            <div class="number">
                {{ $totalBooks }}
            </div>

        </div>


        <div class="card">

            <div class="icon">
                👥
            </div>

            <div class="label">
                Total Users
            </div>

            <div class="number">
                {{ $totalUsers }}
            </div>

        </div>


        <div class="card">

            <div class="icon">
                🛒
            </div>

            <div class="label">
                Total Orders
            </div>

            <div class="number">
                {{ $totalOrders }}
            </div>

        </div>


        <div class="card">

            <div class="icon">
                💰
            </div>

            <div class="label">
                Total Revenue
            </div>

            <div class="number">
                ₹{{ number_format($totalRevenue, 2) }}
            </div>

        </div>


    </div>


    {{-- Order Status --}}

    <div class="section">

        <h2>
            📊 Order Status
        </h2>


        <div class="status-grid">


            <div class="status-card">

                <h3>
                    Pending Orders
                </h3>

                <p>
                    {{ $pendingOrders }}
                </p>

            </div>


            <div class="status-card">

                <h3>
                    Processing Orders
                </h3>

                <p>
                    {{ $processingOrders }}
                </p>

            </div>


            <div class="status-card">

                <h3>
                    Delivered Orders
                </h3>

                <p>
                    {{ $deliveredOrders }}
                </p>

            </div>


            <div class="status-card">

                <h3>
                    Cancelled Orders
                </h3>

                <p>
                    {{ $cancelledOrders }}
                </p>

            </div>


        </div>

    </div>


</div>

</body>

</html>