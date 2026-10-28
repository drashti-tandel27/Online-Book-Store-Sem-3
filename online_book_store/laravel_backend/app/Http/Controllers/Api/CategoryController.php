<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Category;
use Illuminate\Http\Request;

class CategoryController extends Controller
{
    public function index()
    {
        $categories = Category::withCount('books')->get();

        return response()->json([
            'status' => true,
            'data' => $categories,
        ]);
    }

    public function show($id)
    {
        $category = Category::withCount('books')->findOrFail($id);

        return response()->json([
            'status' => true,
            'data' => $category,
        ]);
    }
}
