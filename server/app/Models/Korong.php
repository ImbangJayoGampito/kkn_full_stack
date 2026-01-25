<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Korong extends Model
{
    use HasFactory;

    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'korong';

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    protected $fillable = [
        'name',
        'address',
        'phone',
        'email',
        'description',
        'coordinates',
        'wali_korong_id',
    ];

    /**
     * Get the wali korong that owns this korong.
     */
    public function waliKorong(): BelongsTo
    {
        return $this->belongsTo(User::class, 'wali_korong_id');
    }
}
