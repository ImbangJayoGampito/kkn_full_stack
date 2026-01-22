<?php
namespace Database\Seeders;
use Illuminate\Database\Seeder;
use App\Models\Product;

class ProductSeeder extends Seeder
{
    public function run()
    {
        $products = [
            [
                'name' => 'Apple iPhone 15',
                'description' => 'Latest iPhone model with amazing features.',
                'price' => 999.99,
                'imageUrl' => 'https://example.com/images/iphone15.jpg',
            ],
            [
                'name' => 'Samsung Galaxy S23',
                'description' => 'High-end Android smartphone from Samsung.',
                'price' => 899.99,
                'imageUrl' => 'https://example.com/images/galaxys23.jpg',
            ],
            [
                'name' => 'Sony WH-1000XM5',
                'description' => 'Noise-canceling wireless headphones.',
                'price' => 349.99,
                'imageUrl' => 'https://example.com/images/sonywh1000xm5.jpg',
            ],
            [
                'name' => 'Dell XPS 13',
                'description' => 'Powerful and compact laptop for professionals.',
                'price' => 1199.99,
                'imageUrl' => 'https://example.com/images/dellxps13.jpg',
            ],
        ];

        foreach ($products as $product) {
            Product::create($product);
        }
    }
}
