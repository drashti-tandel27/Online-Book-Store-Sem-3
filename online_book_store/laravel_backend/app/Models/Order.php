<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Order extends Model
{
    use HasFactory;

    protected $fillable = [
        'order_number',
        'user_id',
        'subtotal',
        'shipping_fee',
        'tax',
        'total_amount',
        'status',
        'payment_method',
        'payment_status',
        'shipping_address',
        'recipient_name',
        'recipient_phone',
        'notes',
    ];

    protected $casts = [
        'subtotal' => 'float',
        'shipping_fee' => 'float',
        'tax' => 'float',
        'total_amount' => 'float',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function items()
    {
        return $this->hasMany(OrderItem::class);
    }
}
