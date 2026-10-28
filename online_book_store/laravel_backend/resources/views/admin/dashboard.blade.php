<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Admin Dashboard - Online Book Store</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            background: #f5f7fb;
            color: #172554;
        }

        .layout {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar */
        .sidebar {
            width: 240px;
            background: #173b8f;
            color: white;
            padding: 25px 15px;
            position: fixed;
            left: 0;
            top: 0;
            bottom: 0;
        }

        .logo {
            font-size: 21px;
            font-weight: bold;
            padding: 10px 15px 30px;
        }

        .menu {
            list-style: none;
        }

        .menu li {
            margin-bottom: 8px;
        }

        .menu a {
            display: block;
            padding: 13px 15px;
            color: white;
            text-decoration: none;
            border-radius: 10px;
            font-size: 15px;
        }

        .menu a:hover,
        .menu .active {
            background: #2d66d5;
        }

        .logout {
            margin-top: 30px;
            border-top: 1px solid rgba(255,255,255,0.3);
            padding-top: 20px;
        }

        /* Main */
        .main {
            margin-left: 240px;
            width: calc(100% - 240px);
        }

        .topbar {
            height: 70px;
            background: white;
            display: flex;
            justify-content: flex-end;
            align-items: center;
            padding: 0 35px;
            border-bottom: 1px solid #e5e7eb;
        }

        .admin {
            font-weight: bold;
        }

        .content {
            padding: 35px;
        }

        .welcome {
            margin-bottom: 30px;
        }

        .welcome h1 {
            font-size: 30px;
            margin-bottom: 8px;
        }

        .welcome p {
            color: #64748b;
        }

        /* Cards */
        .cards {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }

        .card {
            background: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        }

        .card-title {
            color: #64748b;
            font-size: 14px;
            margin-bottom: 12px;
        }

        .card-number {
            font-size: 30px;
            font-weight: bold;
            color: #173b8f;
        }

        /* Recent Orders */
        .section {
            background: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .section-header h2 {
            font-size: 20px;
        }

        .view-all {
            color: #2563eb;
            text-decoration: none;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th,
        td {
            text-align: left;
            padding: 15px 10px;
            border-bottom: 1px solid #eef2f7;
        }

        th {
            color: #64748b;
            font-size: 13px;
        }

        td {
            font-size: 14px;
        }

        .status {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            background: #dcfce7;
            color: #15803d;
        }

        @media(max-width: 900px) {
            .cards {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media(max-width: 650px) {
            .sidebar {
                width: 190px;
            }

            .main {
                margin-left: 190px;
                width: calc(100% - 190px);
            }

            .content {
                padding: 20px;
            }

            .cards {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body>

<div class="layout">

    <!-- Sidebar -->
    <aside class="sidebar">

        <div class="logo">
            📖 Online Book Store
        </div>

        <ul class="menu">

            <li>
                <a href="{{ route('admin.dashboard') }}" class="active">
                    📊 Dashboard
                </a>
            </li>

            <li>
                <a href="{{ route('admin.books.index') }}">
                    📚 Books
                </a>
            </li>

            <li>
              <a href="{{ route('admin.categories.index') }}">
    📂 Categories
</a>
            </li>

            <li>
               <a href="{{ route('admin.users.index') }}">
    👥 Users
</a>
            </li>

            <li>
               <a href="{{ route('admin.orders.index') }}">
    🛒 Orders
</a>
            </li>

            <li>
                <a href="{{ route('admin.reviews.index') }}">
    ⭐ Reviews
</a>
            </li>

            <li>
                <a href="{{ route('admin.reports.index') }}">
    📈 Reports
</a>
            </li>

            <li>
               <a href="{{ route('admin.notifications.index') }}">
    🔔 Notifications
</a>
            </li>

            <li>
               <a href="{{ route('admin.settings.index') }}">
    ⚙️ Settings
</a>
            </li>

        </ul>

        <div class="logout">
     <form method="POST" action="{{ route('admin.logout') }}" style="margin: 0;">
    @csrf

    <button
        type="submit"
        style="
            background: none;
            border: none;
            padding: 0;
            margin: 0;
            color: white;
            font-size: 16px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 12px;
            width: 100%;
            text-align: left;
        "
    >
        <span>🚪</span>
        <span>Logout</span>
    </button>
</form>
        </div>

    </aside>


    <!-- Main Content -->
    <main class="main">

        <!-- Top Bar -->
        <div class="topbar">
            <div class="admin">
                👤 Admin
            </div>
        </div>


        <!-- Dashboard Content -->
        <div class="content">

            <div class="welcome">
                <h1>Welcome back, Admin! 👋</h1>
                <p>Here's what's happening with your online book store today.</p>
            </div>


            <!-- Statistics -->
            <div class="cards">

                <div class="card">
                    <div class="card-title">📚 Total Books</div>
                    <div class="card-number">
                        {{ $totalBooks }}
                    </div>
                </div>

                <div class="card">
                    <div class="card-title">👥 Total Users</div>
                    <div class="card-number">
                        {{ $totalUsers }}
                    </div>
                </div>

                <div class="card">
                    <div class="card-title">🛒 Total Orders</div>
                    <div class="card-number">
                        {{ $totalOrders }}
                    </div>
                </div>

                <div class="card">
                    <div class="card-title">💰 Total Sales</div>
                    <div class="card-number">
                        ₹{{ number_format($totalRevenue, 2) }}
                    </div>
                </div>

            </div>


            <!-- Recent Orders -->
            <div class="section">

                <div class="section-header">

                    <h2>Recent Orders</h2>

                    <a href="#" class="view-all">
                        View All Orders →
                    </a>

                </div>


                <table>

                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>Customer</th>
                            <th>Amount</th>
                            <th>Status</th>
                            <th>Date</th>
                        </tr>
                    </thead>

                    <tbody>

                        @forelse($recentOrders as $order)

                            <tr>

                                <td>
                                    #{{ $order->order_number }}
                                </td>

                                <td>
                                    {{ $order->user->name ?? 'Guest' }}
                                </td>

                                <td>
                                    ₹{{ number_format($order->total_amount, 2) }}
                                </td>

                                <td>
                                    <span class="status">
                                        {{ $order->status }}
                                    </span>
                                </td>

                                <td>
                                    {{ $order->created_at->format('d M Y') }}
                                </td>

                            </tr>

                        @empty

                            <tr>
                                <td colspan="5">
                                    No orders found.
                                </td>
                            </tr>

                        @endforelse

                    </tbody>

                </table>

            </div>

        </div>

    </main>

</div>

</body>
</html>