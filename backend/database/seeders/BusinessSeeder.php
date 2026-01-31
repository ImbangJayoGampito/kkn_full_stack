<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Services\BusinessService;
use App\Services\UserService;

class BusinessSeeder extends Seeder
{
    public function run()
    {
        for ($i = 0; $i < 20; $i++) {
            $owner = UserService::registerUser(
                "owner{$i}",
                "business_owner{$i}@example.com",
                'password'
            );

            for ($j = 0; $j < 2; $j++) {
                // Correct latitude: -90 to +90
                $latitude = mt_rand(-90000000, 90000000) / 1e6;

                // Correct longitude: -180 to +180
                $longitude = mt_rand(-180000000, 180000000) / 1e6;

                BusinessService::createBusinessWithEmployees(
                    $longitude,
                    $latitude,
                    "Business {$i}-{$j}",
                    "Address for Business {$i}-{$j}",
                    "Phone{$i}{$j}",
                    'kantor',
                    $owner
                );
            }
        }
    }
}
