<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use App\Models\User;
use Laravel\Sanctum\PersonalAccessToken;
class AuthController extends Controller
{
    public function restore(Request $request)
    {
        $plainToken = $request->bearerToken();

        if (!$plainToken) {
            return response()->json(["message" => "No token provided"], 401);
        }

        $token = PersonalAccessToken::findToken($plainToken);

        if (!$token) {
            return response()->json(["message" => "Invalid token"], 401);
        }

        // is it expired?
        if ($token->expires_at && $token->expires_at->isPast()) {
            $token->delete();
            return response()->json(["message" => "Token expired"], 401);
        }

        $user = $token->tokenable; // User

        if (!$user) {
            $token->delete();
            return response()->json(["message" => "Invalid User Bearer!"], 401);
        }

        $userNoPass = $user->only(["id", "username", "email"]);
        return response()->json([
            "message" => "Token revoked",
            "user" => $userNoPass,
        ]);
    }

    // Register a new user
    public function register(Request $request)
    {
        $request->validate([
            "username" => "required|string|max:255|unique:users",
            "email" => "required|email|unique:users",
            "password" => "required|string|min:6",
        ]);

        $user = User::create([
            "username" => $request->username,
            "email" => $request->email,
            "password" => Hash::make($request->password),
        ]);
        $token = $user->createToken(
            "api_token",
            ["*"], 
            now()->addDays(7), 
        )->plainTextToken;
        $user->assignRole("user");

        $userNoPass = $user->only(["id", "username", "email"]);
        return response()->json([
            "user" => $userNoPass,
            "token" => $token,
        ]);
    }

    // Login user
    public function login(Request $request)
    {
        $request->validate([
            "username" => "required|string",
            "password" => "required|string",
        ]);

        $user = User::where("username", $request->username)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json(["message" => "Invalid credentials"], 401);
        }

        $token = $user->createToken("api_token")->plainTextToken;
        $userNoPass = $user->only(["id", "username", "email"]);
        return response()->json([
            "user" => $userNoPass,
            "token" => $token,
        ]);
    }

    // Logout user (revoke token)
    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json(["message" => "Logged out"]);
    }
}
