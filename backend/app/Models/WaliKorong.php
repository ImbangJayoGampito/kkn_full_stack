<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class WaliKorong extends Model
{
    protected $fillable = [
        'name', 'email', 'phone', 'user_id'
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function korongs(): HasMany
    {
        return $this->hasMany(Korong::class, 'wali_korong_id');
    }
}
