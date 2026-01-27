import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:client/utils/error_handling.dart';
import 'package:dio/dio.dart';

class PaginatedResponse<T> {
  final int currentPage;
  final int pageSize;
  final int totalItems;
  final int totalPages;
  final List<T> data;

  PaginatedResponse({
    required this.currentPage,
    required this.pageSize,
    required this.totalItems,
    required this.totalPages,
    required this.data,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginatedResponse(
      currentPage: json['currentPage'],
      pageSize: json['pageSize'],
      totalItems: json['totalItems'],
      totalPages: json['totalPages'],
      data: (json['data'] as List)
          .map((item) => fromJsonT(item as Map<String, dynamic>))
          .toList(),
    );
  }
  static Future<Result<PaginatedResponse<T>, String>> fetch<T>({
    required String endpoint,
    String? token,
    Duration timeout = const Duration(seconds: 10),
    Map<String, String>? queryParameters,
    required T Function(Map<String, dynamic>) fromJsonT,
  }) async {
    try {
      final dio = Dio(
        BaseOptions(
          connectTimeout: Duration(milliseconds: timeout.inMilliseconds),
          receiveTimeout: Duration(milliseconds: timeout.inMilliseconds),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      final response = await dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: Options(responseType: ResponseType.json),
      );

      var data = response.data;
      StatusCode statusCode = StatusCode(code: response.statusCode ?? 404);
      return statusCode.processStatus<PaginatedResponse<T>, String>(
        json: data,
        onSuccess: (json) {
          return PaginatedResponse.fromJson(
            json as Map<String, dynamic>,
            fromJsonT,
          );
        },
      );
    } catch (e) {
      return Err<PaginatedResponse<T>, String>(e.toString());
    }
  }
}
