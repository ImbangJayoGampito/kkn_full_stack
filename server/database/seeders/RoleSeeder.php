<?php
namespace Database\Seeders;
use Illuminate\Database\Seeder;
use Spatie\Permission\Models\Role;

class RoleSeeder extends Seeder
{
    public function run()
    {
        Role::create(["name" => "admin"]);
        Role::create(["name" => "wali_nagari"]);
        Role::create(["name" => "wali_korong"]);
        Role::create(["name" => "user"]);
    }
}
