<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Relations\HasOne;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use Spatie\Permission\Traits\HasRoles;
use Illuminate\Database\Eloquent\Relations\HasMany;

class User extends Authenticatable
{
    use HasApiTokens, HasRoles, Notifiable;

    protected $fillable = [
        'username',
        'email',
        'password',
        'phone',
    ];

    protected $hidden = [
        'password',
        'remember_token',
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

    // One-to-one relationship with WaliKorong (User has one WaliKorong)
    public function waliKorong(): HasOne
    {
        return $this->hasOne(WaliKorong::class);
    }

    // One-to-one relationship with WaliNagari (User has one WaliNagari)
    public function waliNagari(): HasOne
    {
        return $this->hasOne(WaliNagari::class);
    }

    public function productTransactions(): HasMany
    {
        return $this->hasMany(ProductTransaction::class);
    }
}
