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
  static Future<Result<User, String>> loginUser({
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
          return Err<User, String>('Token missing in response');
        }

        return Ok(User.fromJson(data['user']));
      } else {
        return Err('Login failed: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      return Err<User, String>(e.toString());
    }
  }

  static Future<Result<User, String>> registerUser({
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
          return Err<User, String>('Token missing in response');
        }

        // Return success result
        return Ok(User.fromJson(data['user']));
      } else {
        // Return error result
        return Err('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      return Err<User, String>(e.toString());
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

  static Future<Result<User, String>> restoreFromSession({
    required String token,
    required String endpoint,
  }) async {
    try {
      debugPrint('Token $token');
      final response = await http.get(
        Uri.parse(endpoint),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      if (response.body.startsWith('<!DOCTYPE html>')) {
        return Err<User, String>(
          'Server returned HTML instead of JSON. Possible invalid token.',
        );
      }
      final data = jsonDecode(response.body);
      StatusCode code = StatusCode(code: response.statusCode);
      return code.processStatus(
        json: data,
        onSuccess: (json) {
          final userMap = (json as Map<String, dynamic>)['user'];
          return User.fromJson(userMap);
        },
      );
    } catch (e) {
      return Err('Failed to restore ${endpoint} user because ${e}');
    }
  }
}
