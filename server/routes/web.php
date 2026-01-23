<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get("/{any}", function (Request $request, $any = null) {
    $req = $request->path();
    $path = $request->path();

    // If the path starts with "api", let API routes handle it
    if (str_starts_with($path, "api")) {
        abort(404); // or let it fall through to API routes
    }
    $direct = public_path($req);
    $inWeb = public_path("web/" . $req);

    if ($req !== "" && file_exists($direct) && is_file($direct)) {
        return response()->file($direct);
    }

    if ($req !== "" && file_exists($inWeb) && is_file($inWeb)) {
        return response()->file($inWeb);
    }

    return response()->file(public_path("web/index.html"));
})->where("any", ".*");
