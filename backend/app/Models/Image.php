<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\MorphTo;

class Image extends Model
{
    protected $fillable = [
        'image_url', 'image_alt', 'image_title'
    ];

    public function imageable(): MorphTo
    {
        return $this->morphTo();
    }
}
