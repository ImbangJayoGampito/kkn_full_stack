<?php

namespace App\Services;

use App\Models\Business;
use App\Models\Employee;
use App\Models\User;
use Illuminate\Support\Facades\DB;
use Exception;

class BusinessService
{
    public static function createBusiness(
        float $longitude,
        float $latitude,
        string $name,
        string $address,
        string $phone,
        string $type,
        User $user
    ): Business {
        return DB::transaction(function () use (
            $longitude,
            $latitude,
            $name,
            $address,
            $phone,
            $type,
            $user
        ) {
            // 1. Create Business
            $business = Business::create([
                'longitude' => $longitude,
                'latitude' => $latitude,
                'name' => $name,
                'address' => $address,
                'phone' => $phone,
                'type' => $type,
                'user_id' => $user->id,
            ]);

            // 2. Create Owner Role
            $roleOwner = EmployeeRoleService::createEmployeeRole(
                'Pemilik',
                'Pemilik UMKM',
                'Mengurus bisnis',
                true,
                $business->id
            );

            // 3. Add Owner as Employee
            $ownerEmployee = new Employee([
                'user_id' => $user->id,
                'role_id' => $roleOwner->id,
                'start_date' => now(),
                'salary' => 0.00,
            ]);
            EmployeeService::createEmployeeFromAdmin($user, $roleOwner, $ownerEmployee);

            return $business;
        });
    }

    public static function createBusinessWithEmployees(
        float $longitude,
        float $latitude,
        string $name,
        string $address,
        string $phone,
        string $type,
        User $user
    ): Business {
        return DB::transaction(function () use (
            $longitude,
            $latitude,
            $name,
            $address,
            $phone,
            $type,
            $user
        ) {
            // 1. Create Business + Owner Employee
            $business = self::createBusiness(
                $longitude,
                $latitude,
                $name,
                $address,
                $phone,
                $type,
                $user
            );

            // 2. Create Secondary User
            $employeeUser = UserService::registerUser(
                "employee{$business->id}",
                "employee{$business->id}@example.com",
                'password'

            );

            // 3. Create Employee Role for Secondary
            $roleEmployee = EmployeeRoleService::createEmployeeRole(
                'Pegawai',
                'Pegawai UMKM',
                'Mengurus bisnis',
                false,
                $business->id
            );

            // 4. Add Secondary Employee
            $secondaryEmployee = new Employee([
                'user_id' => $employeeUser->id,
                'role_id' => $roleEmployee->id,
                'start_date' => now(),
                'salary' => 0.00,
            ]);
            EmployeeService::createEmployeeFromAdmin($employeeUser, $roleEmployee, $secondaryEmployee);

            return $business;
        });
    }
}
