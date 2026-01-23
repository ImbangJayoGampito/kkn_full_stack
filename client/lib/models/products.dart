import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:client/utils/error_handling.dart';

class Product {
  String id;
  String name;
  String description;
  double price;
  String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      imageUrl: json['imageUrl'],
    );
  }
  static Future<Result<List<Product>, String>> fetchProducts({
    required String endpoint,
    required String token,
  }) async {
    try {
      debugPrint('tosendProduct $token');
      final headers = {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

      debugPrint('Sending GET $endpoint with headers: $headers');

      final response = await http.get(Uri.parse(endpoint), headers: headers);
      debugPrint('Response code: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      final body = response.body.trim();

      // Detect HTML error pages
      if (body.startsWith('<!DOCTYPE html>')) {
        return Err<List<Product>, String>(
          'Server returned HTML instead of JSON. Possible invalid token.',
        );
      }
      var data = json.decode(body);

      StatusCode statusCode = StatusCode(code: response.statusCode);

      return statusCode.processStatus<List<Product>, String>(
        json: data,
        onSuccess: (json) {
          // json is a List<dynamic> already
          final productsJson = json as List<dynamic>;
          return productsJson
              .map((e) => Product.fromJson(e as Map<String, dynamic>))
              .toList();
        },
      );
    } catch (e) {
      return Err<List<Product>, String>(e.toString());
    }
  }
}
