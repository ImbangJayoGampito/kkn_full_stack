import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:client/config/app_config.dart';
import 'package:client/utils/error_handling.dart';
import 'package:flutter/foundation.dart';

class User {
  final int id;
  final String username;
  final String email;
  const User({required this.id, required this.username, required this.email});

  // Factory constructor to create a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
    );
  }

  static const _storage = FlutterSecureStorage();
  static Future<Result<User>> loginUser({
    required String username,
    required String password,
    required String endpoint,
  }) async {
    final url = Uri.parse(endpoint);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['token'] != null) {
          // Use AppConfig.SessionToken as key
          await _storage.write(
            key: AppConfig.sessionToken,
            value: data['token'],
          );
        } else {
          return const Err('Token missing in response');
        }

        return Ok(User.fromJson(data['user']));
      } else {
        return Err('Login failed: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      return Err(e);
    }
  }

  static Future<Result<User>> registerUser({
    required String username,
    required String password,
    required String email,
    required String endpoint,
  }) async {
    final url = Uri.parse(endpoint);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
          'email': email,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        // Save token securely
        if (data['token'] != null) {
          await _storage.write(
            key: AppConfig.sessionToken,
            value: data['token'],
          );
        } else {
          return const Err('Token missing in response');
        }

        // Return success result
        return Ok(User.fromJson(data['user']));
      } else {
        // Return error result
        return Err('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      return Err(e);
    }
  }

  static Future<String?> getToken() async {
    final token = await _storage.read(key: AppConfig.sessionToken);

    return token;
  }

  /// Logout (delete token)
  static Future<bool> logout() async {
    try {
      await _storage.delete(key: AppConfig.sessionToken);
      return true;
    } catch (e) {
      return false;
    }
  }
}
