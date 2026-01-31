<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Product;
use App\Models\Business;
use Faker\Factory as Faker;

class ProductSeeder extends Seeder
{
    public function run()
    {
        $faker = Faker::create();

        $businesses = Business::all();
        foreach ($businesses as $business) {
            for ($k = 0; $k < 5; $k++) {
                Product::create([
                    'name' => "Product {$business->id}-{$k}",
                    'description' => $faker->sentence,
                    'price' => $faker->randomFloat(2, 1, 10000),
                    'business_id' => $business->id,
                ]);
            }
        }
    }
}
