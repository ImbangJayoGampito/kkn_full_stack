import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:client/utils/error_handling.dart';
import 'package:client/config/app_config.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final int stock; // new
  final String? imageUrl; // nullable now
  final List<ProductImage> images; // map images array

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    this.imageUrl,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: double.parse(json['price'].toString()),
      stock: json['stock'] ?? 0,
      imageUrl: json['imageUrl'], // nullable
      images:
          (json['images'] as List<dynamic>?)
              ?.map((i) => ProductImage.fromJson(i))
              .toList() ??
          [],
    );
  }

  static Future<Result<List<Product>, String>> fetchProducts({
    required String endpoint,
    required String token,
    Duration timeout = AppConfig.timeout,
  }) async {
    try {
      debugPrint('tosendProduct $token');
      final headers = {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

      debugPrint('Sending GET $endpoint with headers: $headers');

      final response = await http
          .get(Uri.parse(endpoint), headers: headers)
          .timeout(timeout);
      debugPrint('Response code: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      final body = response.body.trim();

      // Detect HTML error pages
      if (body.startsWith('<!DOCTYPE html>')) {
        return Err<List<Product>, String>(
          'Server returned HTML instead of JSON. Possible invalid token.',
        );
      }
      final Map<String, dynamic> data =
          json.decode(body) as Map<String, dynamic>;

      StatusCode statusCode = StatusCode(code: response.statusCode);

      return statusCode.processStatus<List<Product>, String>(
        json: data,
        onSuccess: (json) {
          // json is a List<dynamic> already
          var json = data['data'] as List;
          return json
              .map((e) => Product.fromJson(e as Map<String, dynamic>))
              .toList();
        },
      );
    } catch (e) {
      return Err<List<Product>, String>(e.toString());
    }
  }
}

class ProductImage {
  final int id;
  final String url;
  final String alt;
  final String title;

  ProductImage({
    required this.id,
    required this.url,
    required this.alt,
    required this.title,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'],
      url: json['url'],
      alt: json['alt'] ?? '',
      title: json['title'] ?? '',
    );
  }
}
