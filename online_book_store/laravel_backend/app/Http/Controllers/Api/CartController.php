<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Book;
use App\Models\Cart;
use App\Models\CartItem;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;

class CartController extends Controller
{
    // Helper to get or create cart for user
    private function getUserCart($user)
    {
        return Cart::firstOrCreate(['user_id' => $user->id]);
    }

    // Get Cart
    public function index(Request $request)
    {
        $cart = $this->getUserCart($request->user());
        $cart->load(['items.book.category']);

        return response()->json([
            'status' => true,
            'data' => $cart,
        ]);
    }

    // Add item to cart
    public function store(Request $request)
    {
        $validated = $request->validate([
            'book_id' => 'required|exists:books,id',
            'quantity' => 'nullable|integer|min:1',
        ]);

        $book = Book::findOrFail($validated['book_id']);
        $quantity = $validated['quantity'] ?? 1;

        if ($book->stock < $quantity) {
            throw ValidationException::withMessages([
                'quantity' => ["Only {$book->stock} items available in stock."],
            ]);
        }

        $cart = $this->getUserCart($request->user());

        $item = CartItem::where('cart_id', $cart->id)
            ->where('book_id', $book->id)
            ->first();

        if ($item) {
            $newQuantity = $item->quantity + $quantity;
            if ($newQuantity > $book->stock) {
                throw ValidationException::withMessages([
                    'quantity' => ["Cannot add more. Reached stock limit of {$book->stock} items."],
                ]);
            }
            $item->update([
                'quantity' => $newQuantity,
                'price' => $book->effective_price,
            ]);
        } else {
            CartItem::create([
                'cart_id' => $cart->id,
                'book_id' => $book->id,
                'quantity' => $quantity,
                'price' => $book->effective_price,
            ]);
        }

        $cart->load(['items.book.category']);

        return response()->json([
            'status' => true,
            'message' => 'Item added to cart.',
            'data' => $cart,
        ]);
    }

    // Update item quantity
    public function update(Request $request, $id)
    {
        $validated = $request->validate([
            'quantity' => 'required|integer|min:1',
        ]);

        $cart = $this->getUserCart($request->user());
        $item = CartItem::where('cart_id', $cart->id)->where('id', $id)->firstOrFail();
        $book = $item->book;

        if ($validated['quantity'] > $book->stock) {
            throw ValidationException::withMessages([
                'quantity' => ["Available stock is {$book->stock}."],
            ]);
        }

        $item->update([
            'quantity' => $validated['quantity'],
        ]);

        $cart->load(['items.book.category']);

        return response()->json([
            'status' => true,
            'message' => 'Cart updated.',
            'data' => $cart,
        ]);
    }

    // Remove item from cart
    public function destroy(Request $request, $id)
    {
        $cart = $this->getUserCart($request->user());
        $item = CartItem::where('cart_id', $cart->id)->where('id', $id)->first();

        if ($item) {
            $item->delete();
        }

        $cart->load(['items.book.category']);

        return response()->json([
            'status' => true,
            'message' => 'Item removed from cart.',
            'data' => $cart,
        ]);
    }

    // Clear cart
    public function clear(Request $request)
    {
        $cart = $this->getUserCart($request->user());
        CartItem::where('cart_id', $cart->id)->delete();

        return response()->json([
            'status' => true,
            'message' => 'Cart cleared.',
        ]);
    }
}
