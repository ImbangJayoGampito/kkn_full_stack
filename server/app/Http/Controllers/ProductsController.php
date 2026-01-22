<?php

namespace App\Http\Controllers;

use App\Models\Product;
use Illuminate\Http\Request;

class ProductsController extends Controller
{
    // GET /api/products
    public function index()
    {
        $products = Product::all();

        // Return JSON response with key names matching your Dart model fields
        return response()->json(
            $products->map(function ($product) {
                return [
                    'id' => (string) $product->id,
                    'name' => $product->name,
                    'description' => $product->description,
                    'price' => (float) $product->price,
                    'imageUrl' => $product->imageUrl,
                ];
            })
        );
    }
}
