<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class WaliNagari extends Model
{
    protected $fillable = [
        'name', 'email', 'phone', 'user_id'
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function nagaris(): HasMany
    {
        return $this->hasMany(Nagari::class, 'wali_nagari_id');
    }
}
