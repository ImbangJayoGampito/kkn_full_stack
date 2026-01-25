<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use App\Models\User;
use Laravel\Sanctum\PersonalAccessToken;

class HelperController
{
    static function authenticateFromToken(Request $request)
    {
        $message = "";
        $plainToken = $request->bearerToken();

        if (!$plainToken) {
            return ['user' => null, 'code' => 401, 'message' => 'No Bearer Token!'];
        }

        $token = PersonalAccessToken::findToken($plainToken);

        if (!$token) {
            return ['user' => null, 'code' => 401, 'message' => "Invalid token"];
        }

        // is it expired?
        if ($token->expires_at && $token->expires_at->isPast()) {
            $token->delete();
            return ['user' => null, 'code' => 401, 'message' => "Token expired"];
        }

        $user = $token->tokenable; // User

        if (!$user) {
            $token->delete();
            return ['user' => null, 'code' => 401, 'message' => "Invalid User Bearer!"];
        }
        return ['user' => $user, 'code' => 200, 'message' => 'Success!'];
    }
}
