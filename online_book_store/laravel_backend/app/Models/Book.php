<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Book extends Model
{
    use HasFactory;

    protected $fillable = [
        'category_id',
        'title',
        'author',
        'isbn',
        'description',
        'price',
        'discount_price',
        'stock',
        'rating',
        'reviews_count',
        'image',
        'publisher',
        'published_year',
        'page_count',
        'is_featured',
    ];

    protected $casts = [
        'price' => 'float',
        'discount_price' => 'float',
        'rating' => 'float',
        'reviews_count' => 'integer',
        'stock' => 'integer',
        'is_featured' => 'boolean',
    ];

    public function category()
    {
        return $this->belongsTo(Category::class);
    }

    public function reviews()
    {
        return $this->hasMany(Review::class);
    }

    public function orderItems()
    {
        return $this->hasMany(OrderItem::class);
    }

    public function cartItems()
    {
        return $this->hasMany(CartItem::class);
    }

    public function wishlists()
    {
        return $this->hasMany(Wishlist::class);
    }

    public function getEffectivePriceAttribute()
    {
        return ($this->discount_price && $this->discount_price > 0 && $this->discount_price < $this->price)
            ? $this->discount_price
            : $this->price;
    }
}
