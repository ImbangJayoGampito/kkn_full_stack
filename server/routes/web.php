<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/{any}', function (Request $request, $any = null) {
    $req = $request->path();
    $direct = public_path($req);
    $inWeb = public_path('web/' . $req);

    if ($req !== '' && file_exists($direct) && is_file($direct)) {
        return response()->file($direct);
    }

    if ($req !== '' && file_exists($inWeb) && is_file($inWeb)) {
        return response()->file($inWeb);
    }

    return response()->file(public_path('web/index.html'));
})->where('any', '.*');
