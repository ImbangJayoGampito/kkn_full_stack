import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:client/utils/error_handling.dart';
import 'package:dio/dio.dart';

class PaginatedResponse<T> {
  final int total;
  final int perPage;
  final int currentPage;
  final int lastPage;
  final String? currentPageUrl;
  final String? firstPageUrl;
  final String? lastPageUrl;
  final String? nextPageUrl;
  final String? prevPageUrl;
  final String path;
  final int? from;
  final int? to;
  final List<T> data;

  PaginatedResponse({
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
    required this.currentPageUrl,
    required this.firstPageUrl,
    required this.lastPageUrl,
    required this.nextPageUrl,
    required this.prevPageUrl,
    required this.path,
    required this.from,
    required this.to,
    required this.data,
  });
  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginatedResponse(
      total: json['total'],
      perPage: json['per_page'],
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      currentPageUrl: json['current_page_url'],
      firstPageUrl: json['first_page_url'],
      lastPageUrl: json['last_page_url'],
      nextPageUrl: json['next_page_url'],
      prevPageUrl: json['prev_page_url'],
      path: json['path'],
      from: json['from'],
      to: json['to'],
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
