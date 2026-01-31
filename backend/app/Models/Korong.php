<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Korong extends Model
{
    protected $fillable = [
        'name', 'address', 'phone', 'email', 'description', 'wali_korong_id', 'nagari_id'
    ];

    public function waliKorong(): BelongsTo
    {
        return $this->belongsTo(WaliKorong::class, 'wali_korong_id');
    }

    public function nagari(): BelongsTo
    {
        return $this->belongsTo(Nagari::class, 'nagari_id');
    }
}
