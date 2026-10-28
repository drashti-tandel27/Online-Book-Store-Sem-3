<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class OrderItem extends Model
{
    use HasFactory;

    protected $fillable = [
        'order_id',
        'book_id',
        'quantity',
        'price',
        'book_title',
        'book_image',
    ];

    protected $casts = [
        'quantity' => 'integer',
        'price' => 'float',
    ];

    public function order()
    {
        return $this->belongsTo(Order::class);
    }

    public function book()
    {
        return $this->belongsTo(Book::class);
    }

    public function getSubtotalAttribute()
    {
        return $this->price * $this->quantity;
    }
}
