<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Services\UserService;

class UserSeeder extends Seeder
{
    public function run()
    {
        for ($i = 0; $i < 30; $i++) {
            UserService::registerUser("User {$i}", "user{$i}@example.com", 'password');
        }
    }
}
