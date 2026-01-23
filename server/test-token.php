<?php
require 'bootstrap/app.php';

$token = \Laravel\Sanctum\PersonalAccessToken::where('id', 20)->first();

if ($token) {
    echo "Token 20 EXISTS\n";
    echo "User ID: " . $token->tokenable_id . "\n";
    echo "Expires: " . ($token->expires_at ? $token->expires_at->format('Y-m-d H:i:s') : 'Never') . "\n";
    
    $user = $token->tokenable;
    echo "User: " . ($user ? $user->username : 'DELETED') . "\n";
} else {
    echo "Token 20 NOT FOUND\n";
}

// Test with plaintext token
$plainToken = '20|5khfNEcDrOO84L4VwuG0aPdrW9U6Q7Rc64OGYW5rce8f8b12';
$found = \Laravel\Sanctum\PersonalAccessToken::findToken($plainToken);
echo "\nPlaintext token lookup: " . ($found ? "FOUND (ID: " . $found->id . ")" : "NOT FOUND") . "\n";
