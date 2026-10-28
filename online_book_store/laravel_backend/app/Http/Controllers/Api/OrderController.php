<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Book;
use App\Models\Cart;
use App\Models\CartItem;
use App\Models\Order;
use App\Models\OrderItem;
use App\Models\Notification;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

class OrderController extends Controller
{
    // List user orders
    public function index(Request $request)
    {
        $orders = Order::with('items.book')
            ->where('user_id', $request->user()->id)
            ->latest()
            ->get();

        return response()->json([
            'status' => true,
            'data' => $orders,
        ]);
    }

    // Order Details
    public function show(Request $request, $id)
    {
        $order = Order::with('items.book')
            ->where('user_id', $request->user()->id)
            ->findOrFail($id);

        return response()->json([
            'status' => true,
            'data' => $order,
        ]);
    }

    // Place Order
    public function store(Request $request)
    {
        $validated = $request->validate([
            'shipping_address' => 'required|string|max:500',
            'payment_method' => 'required|string|max:50',
            'recipient_name' => 'nullable|string|max:255',
            'recipient_phone' => 'nullable|string|max:20',
            'notes' => 'nullable|string|max:500',
            'items' => 'nullable|array',
            'items.*.book_id' => 'required_with:items|exists:books,id',
            'items.*.quantity' => 'required_with:items|integer|min:1',
        ]);

        $user = $request->user();

        return DB::transaction(function () use ($validated, $user) {
            $itemsData = [];
            $subtotal = 0.0;

            // If explicit items are passed, use them.
            // Otherwise use the user's cart.
            if (!empty($validated['items'])) {
                foreach ($validated['items'] as $item) {
                    $book = Book::lockForUpdate()->findOrFail($item['book_id']);
                    $qty = $item['quantity'];

                    if ($book->stock < $qty) {
                        throw ValidationException::withMessages([
                            'items' => [
                                "Insufficient stock for '{$book->title}'. Only {$book->stock} left."
                            ],
                        ]);
                    }

                    $unitPrice = $book->effective_price;
                    $subtotal += $unitPrice * $qty;

                    $itemsData[] = [
                        'book' => $book,
                        'quantity' => $qty,
                        'price' => $unitPrice,
                    ];
                }
            } else {
                $cart = Cart::where('user_id', $user->id)->first();

                if (!$cart || $cart->items()->count() === 0) {
                    throw ValidationException::withMessages([
                        'cart' => [
                            'Your cart is empty. Cannot place an order.'
                        ],
                    ]);
                }

                foreach ($cart->items as $cartItem) {
                    $book = Book::lockForUpdate()->findOrFail($cartItem->book_id);
                    $qty = $cartItem->quantity;

                    if ($book->stock < $qty) {
                        throw ValidationException::withMessages([
                            'items' => [
                                "Insufficient stock for '{$book->title}'. Only {$book->stock} left."
                            ],
                        ]);
                    }

                    $unitPrice = $book->effective_price;
                    $subtotal += $unitPrice * $qty;

                    $itemsData[] = [
                        'book' => $book,
                        'quantity' => $qty,
                        'price' => $unitPrice,
                    ];
                }
            }

            // Calculate fees
            $shippingFee = ($subtotal > 50.0 || empty($itemsData))
                ? 0.0
                : 4.99;

            $tax = round($subtotal * 0.05, 2);

            $totalAmount = round(
                $subtotal + $shippingFee + $tax,
                2
            );

            // Generate order number
            $orderNumber = 'ORD-' . strtoupper(uniqid());

            // Create order
            $order = Order::create([
                'order_number' => $orderNumber,
                'user_id' => $user->id,
                'subtotal' => $subtotal,
                'shipping_fee' => $shippingFee,
                'tax' => $tax,
                'total_amount' => $totalAmount,
                'status' => 'Pending',
                'payment_method' => $validated['payment_method'],
                'payment_status' =>
                    $validated['payment_method'] === 'Cash on Delivery'
                        ? 'Pending'
                        : 'Paid',
                'shipping_address' => $validated['shipping_address'],
                'recipient_name' =>
                    $validated['recipient_name'] ?? $user->name,
                'recipient_phone' =>
                    $validated['recipient_phone'] ?? $user->phone,
                'notes' => $validated['notes'] ?? null,
            ]);

            // Save order items and decrease stock
            foreach ($itemsData as $item) {
                OrderItem::create([
                    'order_id' => $order->id,
                    'book_id' => $item['book']->id,
                    'quantity' => $item['quantity'],
                    'price' => $item['price'],
                    'book_title' => $item['book']->title,
                    'book_image' => $item['book']->image,
                ]);

                $item['book']->decrement(
                    'stock',
                    $item['quantity']
                );
            }

            // Clear user's cart
            $cart = Cart::where('user_id', $user->id)->first();

            if ($cart) {
                CartItem::where(
                    'cart_id',
                    $cart->id
                )->delete();
            }

            // Create notification automatically
            Notification::create([
                'user_id' => $user->id,
                'order_id' => $order->id,
                'title' => 'Order Placed Successfully',
                'message' =>
                    'Your order ' .
                    $order->order_number .
                    ' has been placed successfully.',
                'type' => 'order',
                'is_read' => false,
            ]);

            // Load order items
            $order->load('items.book');

            return response()->json([
                'status' => true,
                'message' => 'Order placed successfully.',
                'order' => $order,
                'data' => $order,
            ], 201);
        });
    }

    // Cancel Order
    public function cancel(Request $request, $id)
    {
        $order = Order::where(
            'user_id',
            $request->user()->id
        )->findOrFail($id);

        if (!in_array(
            strtolower($order->status),
            ['pending', 'confirmed']
        )) {
            throw ValidationException::withMessages([
                'status' => [
                    "Order cannot be cancelled because it is already {$order->status}."
                ],
            ]);
        }

        DB::transaction(function () use ($order, $request) {
            $order->update([
                'status' => 'Cancelled',
                'notes' =>
                    ($order->notes
                        ? $order->notes . ' | '
                        : '') .
                    'Cancellation Reason: ' .
                    ($request->reason ?? 'User cancelled'),
            ]);

            // Restore book stock
            foreach ($order->items as $item) {
                Book::where(
                    'id',
                    $item->book_id
                )->increment(
                    'stock',
                    $item->quantity
                );
            }

            // Create cancellation notification
            Notification::create([
                'user_id' => $order->user_id,
                'order_id' => $order->id,
                'title' => 'Order Cancelled',
                'message' =>
                    'Your order ' .
                    $order->order_number .
                    ' has been cancelled successfully.',
                'type' => 'order_cancelled',
                'is_read' => false,
            ]);
        });

        $order->load('items.book');

        return response()->json([
            'status' => true,
            'message' => 'Order cancelled successfully.',
            'order' => $order,
            'data' => $order,
        ]);
    }
}