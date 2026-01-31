<?php

namespace App\Models;

use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use Spatie\Permission\Traits\HasRoles;
use Illuminate\Database\Eloquent\Relations\HasMany;

class User extends Authenticatable
{
    use HasApiTokens, HasRoles, Notifiable;

    protected $fillable = [
        'name', 'email', 'password', 'phone',
    ];

    protected $hidden = [
        'password', 'remember_token',
    ];

    protected $casts = [
        'email_verified_at' => 'datetime',
    ];

    public function businesses(): HasMany
    {
        return $this->hasMany(Business::class);
    }

    public function employees(): HasMany
    {
        return $this->hasMany(Employee::class);
    }

    public function waliKorongs(): HasMany
    {
        return $this->hasMany(WaliKorong::class);
    }

    public function waliNagaris(): HasMany
    {
        return $this->hasMany(WaliNagari::class);
    }

    public function productTransactions(): HasMany
    {
        return $this->hasMany(ProductTransaction::class);
    }
}
