<?php

namespace App\Http\Controllers;

use App\Models\Product;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ProductsController extends Controller
{
    // GET /api/products
    public function index()
    {
        $business_id = request()->query("business_id");
        $search = request()->query("search"); // get search query
        $query = Product::query();

        // Filter by business_id if provided
        if ($business_id) {
            $query->where("business_id", $business_id);
        }

        // Filter by search query if provided
        if ($search) {
            $query->where(function ($q) use ($search) {
                $q->where("name", "like", "%{$search}%")->orWhere(
                    "description",
                    "like",
                    "%{$search}%",
                );
            });
        }

        // Paginate with 10 items per page
        $products = $query->paginate(10);

        return response()->json($products);
    }
    public function show($id)
    {
        $product = Product::with("images")->findOrFail($id);
        return response()->json($product);
    }
}
