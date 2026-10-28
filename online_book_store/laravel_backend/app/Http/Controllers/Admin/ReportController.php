<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Book;
use App\Models\Order;
use App\Models\User;

class ReportController extends Controller
{
    public function index()
    {
        $totalBooks = Book::count();

        $totalUsers = User::count();

        $totalOrders = Order::count();

        $totalRevenue = Order::where(
            'status',
            '!=',
            'Cancelled'
        )->sum('total_amount');

        $deliveredOrders = Order::where(
            'status',
            'Delivered'
        )->count();

        $cancelledOrders = Order::where(
            'status',
            'Cancelled'
        )->count();

        $pendingOrders = Order::where(
            'status',
            'Pending'
        )->count();

        $processingOrders = Order::where(
            'status',
            'Processing'
        )->count();

        return view(
            'admin.reports.index',
            compact(
                'totalBooks',
                'totalUsers',
                'totalOrders',
                'totalRevenue',
                'deliveredOrders',
                'cancelledOrders',
                'pendingOrders',
                'processingOrders'
            )
        );
    }
}