import 'package:client/config/app_config.dart';
import 'package:client/utils/error_handling.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:client/models/products.dart';
import 'package:client/widgets/error.dart';
import 'package:client/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:client/widgets/search.dart';
import 'package:client/models/page.dart';
import 'package:client/widgets/product.dart';

class ProductList extends StatefulWidget {
  final String apiUri;
  const ProductList({super.key, required this.apiUri});
  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  String _token = '';

  @override
  Widget build(BuildContext context) {
    return PaginatedSearchCard<Product>(
      fromJsonT: Product.fromJson,
      endpoint: AppConfig.productsEndpoint,
      searchBuilder: (product) => SearchItem(
        widgetBuilder: (context) => ProductCard(product: product),
        textsInside: [
          product.name,
          product.description,
          product.price.toString(),
        ],
      ),
    );
  }
}
