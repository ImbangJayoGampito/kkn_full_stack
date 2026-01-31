<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use App\Http\Requests\StoreAuthRequest;

class AuthController extends Controller
{
    // Register a new user
    public function register(Request $request)
    {
        $authStoreRequest = new StoreAuthRequest();
        $validator = Validator::make($request->all(), $authStoreRequest->rules(), $authStoreRequest->message());

        if ($validator->fails()) {
            return response()->json(["message" => "Gagal Validasi!", "errors" => $validator->errors()], 422);
        }

        $user = User::create([
            'username' => $request->username,
            'email' => $request->email,
            'password' => Hash::make($request->password),
        ]);

        $token =  $token = $user->createToken(
            "api_token",
            ["*"],
            now()->addDays(7),
        )->plainTextToken;
        $user->assignRole("user");

        return response()->json(['user' => $user, 'token' => $token], 201);
    }
    public function update(Request $request)
    {
        /** @var \Modules\Core\App\Models\User $user */
        $user = Auth::user();
        if (!$user) {
            return response()->json(['message' => 'Kamu tidak diizinkan!'], 404);
        }
        $authStoreRequest = new StoreAuthRequest();
        $validator = Validator::make($request->all(), $authStoreRequest->rules(), $authStoreRequest->message());
        if ($validator->fails()) {
            return response()->json(["message" => "Gagal Validasi!", "errors" => $validator->errors()], 422);
        }
        $user->username = $request->username;
        $user->email = $request->email;
        $oldPassword = $request->password;
        $newPassword = $request->new_password;
        if (!Hash::check($oldPassword, $user->password)) {
            return response()->json(['message' => 'Password lama tidak sesuai!'], 400);
        }
        $user->password = Hash::make($newPassword);
        $user->save();
        return response()->json(['message' => 'Profil berhasil diperbarui!'], 200);
    }

    // Login a user
    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email_or_username' => 'required|string',  // Single field for email or username
            'password' => 'required|string|min:6',
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 400);
        }
        $field = filter_var($request->email_or_username, FILTER_VALIDATE_EMAIL) ? 'email' : 'username';
        if (Auth::attempt([$field => $request->email_or_username, 'password' => $request->password])) {
            /** @var \Modules\Core\App\Models\User $user */
            $user = Auth::user();
            $token =  $token = $user->createToken(
                "api_token",
                ["*"],
                now()->addDays(7),
            )->plainTextToken;
            $user->assignRole("user");

            return response()->json(['user' => $user, 'token' => $token], 200);
        }

        return response()->json(['message' => 'Credensial yang Tidak Berhasil!'], 401);
    }

    // Logout the user (revoke the token)
    public function logout(Request $request)
    {
        /** @var \Modules\Core\App\Models\User $user */
        $user = Auth::user();
        if (!$user) {
            return response()->json(['message' => 'Kamu tidak diizinkan!'], 404);
        }
        $user->currentAccessToken()->delete();

        return response()->json(['message' => 'Log out sukses!'], 200);
    }

    // Get the authenticated user's profile
    public function profile(Request $request)
    {
        /** @var \Modules\Core\App\Models\User $user */
        $user = Auth::user();
        if (!$user) {
            return response()->json(['message' => 'Kamu tidak diizinkan!'], 404);
        }
        return response()->json($user, 200);
    }
}
