<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Product;

class ProdukController extends Controller
{
    public function index()
    {
        $produk = Product::all();
        return response()->json($produk, 200);
    }
}
