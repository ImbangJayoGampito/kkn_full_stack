<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Spatie\Permission\Models\Role;
use Spatie\Permission\Models\Permission;

class RoleSeeder extends Seeder
{
    public function run()
    {
        // Permissions for Wali Korong
        $adminPermissions = [
            'manage business',
            'manage user',
            'manage product',
            'manage transaction',
        ];

        // Permissions for Wali Nagari (additional permissions)
        $superPermissions = [
            'edit nagari',
            'view nagari',
            'manage korong',
        ];

        // Create permissions for both 'web' and 'api' guards
        foreach (array_merge($adminPermissions, $superPermissions) as $permission) {
            // Create the permission for both web and api guards
            Permission::firstOrCreate(['name' => $permission, 'guard_name' => 'web']);
            Permission::firstOrCreate(['name' => $permission, 'guard_name' => 'api']);
        }

        // Create Wali Korong role and assign permissions for 'web' and 'api' guards
        $waliKorongRole = Role::firstOrCreate(['name' => 'wali korong']);
        $waliKorongRole->givePermissionTo($adminPermissions);  // Assign Wali Korong permissions

        // Create Wali Nagari role and assign both Wali Korong's + extra permissions
        $waliNagariRole = Role::firstOrCreate(['name' => 'wali nagari']);
        $waliNagariRole->givePermissionTo(array_merge(
            $adminPermissions,  // Permissions for Wali Korong
            $superPermissions    // Additional permissions for Wali Nagari
        ));

        // Create User role (basic role for regular users, without additional permissions)
        $userRole = Role::firstOrCreate(['name' => 'user']);
    }
}
