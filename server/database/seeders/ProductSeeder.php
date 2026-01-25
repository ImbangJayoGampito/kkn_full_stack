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
                "name" => "Apple iPhone 15",
                "description" => "Latest iPhone model with amazing features.",
                "price" => 999.99,
                "imageUrl" => "https://example.com/images/iphone15.jpg",
            ],
            [
                "name" => "Samsung Galaxy S23",
                "description" => "High-end Android smartphone from Samsung.",
                "price" => 899.99,
                "imageUrl" => "https://example.com/images/galaxys23.jpg",
            ],
            [
                "name" => "Sony WH-1000XM5",
                "description" => "Noise-canceling wireless headphones.",
                "price" => 349.99,
                "imageUrl" => "https://example.com/images/sonywh1000xm5.jpg",
            ],
            [
                "name" => "Dell XPS 13",
                "description" =>
                    "Powerful and compact laptop for professionals.",
                "price" => 1199.99,
                "imageUrl" => "https://example.com/images/dellxps13.jpg",
            ],

            // 30 additional products
            [
                "name" => "Google Pixel 8",
                "description" => "Flagship Google phone with stock Android.",
                "price" => 799.99,
                "imageUrl" => "https://example.com/images/pixel8.jpg",
            ],
            [
                "name" => "MacBook Pro 16",
                "description" =>
                    "Apple laptop with M2 chip and stunning display.",
                "price" => 2499.99,
                "imageUrl" => "https://example.com/images/macbookpro16.jpg",
            ],
            [
                "name" => "Amazon Echo Dot",
                "description" => "Smart speaker with Alexa.",
                "price" => 49.99,
                "imageUrl" => "https://example.com/images/echodot.jpg",
            ],
            [
                "name" => "Bose QuietComfort Earbuds",
                "description" => "High-quality noise-canceling earbuds.",
                "price" => 279.99,
                "imageUrl" => "https://example.com/images/boseqc.jpg",
            ],
            [
                "name" => 'iPad Pro 12.9"',
                "description" => "Powerful tablet with Liquid Retina display.",
                "price" => 1099.99,
                "imageUrl" => "https://example.com/images/ipadpro12.jpg",
            ],
            [
                "name" => "HP Spectre x360",
                "description" => "Convertible laptop with sleek design.",
                "price" => 1299.99,
                "imageUrl" => "https://example.com/images/hpspectre.jpg",
            ],
            [
                "name" => "Samsung Galaxy Tab S8",
                "description" => "High-performance Android tablet.",
                "price" => 699.99,
                "imageUrl" => "https://example.com/images/galaxytabs8.jpg",
            ],
            [
                "name" => "Apple Watch Series 9",
                "description" => "Smartwatch with health tracking features.",
                "price" => 399.99,
                "imageUrl" => "https://example.com/images/applewatch9.jpg",
            ],
            [
                "name" => "Fitbit Charge 6",
                "description" => "Fitness tracker with long battery life.",
                "price" => 149.99,
                "imageUrl" => "https://example.com/images/fitbitcharge6.jpg",
            ],
            [
                "name" => "Microsoft Surface Pro 9",
                "description" => "Versatile 2-in-1 laptop and tablet.",
                "price" => 999.99,
                "imageUrl" => "https://example.com/images/surfacepro9.jpg",
            ],
            [
                "name" => "Nintendo Switch OLED",
                "description" =>
                    "Portable gaming console with vibrant OLED screen.",
                "price" => 349.99,
                "imageUrl" => "https://example.com/images/switcholed.jpg",
            ],
            [
                "name" => "PlayStation 5",
                "description" => "Next-gen gaming console from Sony.",
                "price" => 499.99,
                "imageUrl" => "https://example.com/images/ps5.jpg",
            ],
            [
                "name" => "Xbox Series X",
                "description" => "Powerful gaming console from Microsoft.",
                "price" => 499.99,
                "imageUrl" => "https://example.com/images/xboxsx.jpg",
            ],
            [
                "name" => "Logitech MX Master 3",
                "description" => "Advanced wireless mouse for productivity.",
                "price" => 99.99,
                "imageUrl" => "https://example.com/images/mxmaster3.jpg",
            ],
            [
                "name" => "Razer BlackWidow V4",
                "description" =>
                    "Mechanical gaming keyboard with RGB lighting.",
                "price" => 179.99,
                "imageUrl" => "https://example.com/images/blackwidowv4.jpg",
            ],
            [
                "name" => "Canon EOS R6",
                "description" => "Professional full-frame mirrorless camera.",
                "price" => 2499.99,
                "imageUrl" => "https://example.com/images/canoneosr6.jpg",
            ],
            [
                "name" => "Nikon Z6 II",
                "description" => "High-performance mirrorless camera.",
                "price" => 1999.99,
                "imageUrl" => "https://example.com/images/nikonz6ii.jpg",
            ],
            [
                "name" => "DJI Mini 3 Pro",
                "description" => "Compact drone with 4K camera.",
                "price" => 759.99,
                "imageUrl" => "https://example.com/images/djimini3.jpg",
            ],
            [
                "name" => "GoPro Hero 11",
                "description" => "Action camera for adventure filming.",
                "price" => 399.99,
                "imageUrl" => "https://example.com/images/goprohero11.jpg",
            ],
            [
                "name" => "Samsung Galaxy Buds 2 Pro",
                "description" => "High-end true wireless earbuds.",
                "price" => 229.99,
                "imageUrl" => "https://example.com/images/galaxybuds2.jpg",
            ],
            [
                "name" => "Anker PowerCore 26800",
                "description" => "High-capacity portable charger.",
                "price" => 99.99,
                "imageUrl" => "https://example.com/images/ankerpowercore.jpg",
            ],
            [
                "name" => "Sony PlayStation VR2",
                "description" => "Next-gen VR headset for PlayStation 5.",
                "price" => 549.99,
                "imageUrl" => "https://example.com/images/psvr2.jpg",
            ],
            [
                "name" => "Apple AirPods Pro 2",
                "description" => "Noise-canceling true wireless earbuds.",
                "price" => 249.99,
                "imageUrl" => "https://example.com/images/airpodspro2.jpg",
            ],
            [
                "name" => "Samsung Smart Monitor M8",
                "description" => "Smart 4K monitor with built-in apps.",
                "price" => 399.99,
                "imageUrl" => "https://example.com/images/smartmonitorm8.jpg",
            ],
            [
                "name" => "Kindle Paperwhite 2023",
                "description" => "E-reader with adjustable warm light.",
                "price" => 149.99,
                "imageUrl" => "https://example.com/images/kindlepaperwhite.jpg",
            ],
            [
                "name" => "Asus ROG Zephyrus G14",
                "description" => "Gaming laptop with powerful Ryzen CPU.",
                "price" => 1499.99,
                "imageUrl" => "https://example.com/images/rogzephyrusg14.jpg",
            ],
            [
                "name" => "LG 27GN950-B",
                "description" => "4K gaming monitor with 144Hz refresh rate.",
                "price" => 799.99,
                "imageUrl" => "https://example.com/images/lg27gn950.jpg",
            ],
            [
                "name" => "Corsair K100 RGB",
                "description" =>
                    "High-end mechanical keyboard with macro keys.",
                "price" => 229.99,
                "imageUrl" => "https://example.com/images/corsairk100.jpg",
            ],
            [
                "name" => "SteelSeries Arctis 7",
                "description" => "Wireless gaming headset with clear audio.",
                "price" => 149.99,
                "imageUrl" => "https://example.com/images/arctis7.jpg",
            ],
            [
                "name" => "Seagate Backup Plus 5TB",
                "description" => "External hard drive for extra storage.",
                "price" => 119.99,
                "imageUrl" => "https://example.com/images/seagate5tb.jpg",
            ],
            [
                "name" => "WD My Passport 4TB",
                "description" => "Portable external storage drive.",
                "price" => 109.99,
                "imageUrl" => "https://example.com/images/wd4tb.jpg",
            ],
            [
                "name" => "Samsung Odyssey G9",
                "description" =>
                    "Ultra-wide gaming monitor with 240Hz refresh.",
                "price" => 1499.99,
                "imageUrl" => "https://example.com/images/odysseyg9.jpg",
            ],
            [
                "name" => "Roku Streaming Stick 4K+",
                "description" => "Streaming device with 4K HDR support.",
                "price" => 59.99,
                "imageUrl" => "https://example.com/images/rokustick4k.jpg",
            ],
        ];

        foreach ($products as $product) {
            Product::create($product);
        }
    }
}
