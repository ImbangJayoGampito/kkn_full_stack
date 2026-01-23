import 'package:client/utils/error_handling.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:client/models/products.dart';
import 'package:client/widgets/error.dart';
import 'package:client/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:client/widgets/search.dart';

String formatRupiah(double value) {
  final parts = value.toStringAsFixed(2).split('.');
  final digits = parts[0];
  final buffer = StringBuffer();

  for (int i = 0; i < digits.length; i++) {
    final reversedIndex = digits.length - i - 1;
    buffer.write(digits[reversedIndex]);
    if ((i + 1) % 3 == 0 && i + 1 != digits.length) {
      buffer.write('.');
    }
  }

  final formatted = buffer.toString().split('').reversed.join();
  return 'Rp. $formatted,${parts[1]}';
}

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.arrow_drop_down_circle),
            title: Text(product.name),
            subtitle: Text(
              '${formatRupiah(product.price)}',
              style: TextStyle(color: Colors.green.withOpacity(1)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              product.description,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.start,
            ),
          ),
          Divider(
            color: Colors.grey.shade300, // line color
            thickness: 1, // line thickness
            height: 20, // space around the line
          ),
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailWidget(product: product),
                    ),
                  );
                },
                child: const Text('DETAIL'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProductDetailWidget extends StatelessWidget {
  final Product product;
  const ProductDetailWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details for ${product.name}"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              product.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${formatRupiah(product.price)}',
              style: const TextStyle(fontSize: 20, color: Colors.green),
            ),
            const SizedBox(height: 16),
            Text(product.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // Memicu aksi belanja (dilanjuti)
              },
              icon: const Icon(Icons.shopping_cart),
              label: const Text('Add to Cart'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductList extends StatefulWidget {
  final String apiUri;
  const ProductList({super.key, required this.apiUri});
  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  Future<Result<List<Product>, String>>? _futureProducts;
  List<SearchItem> _searchWidgets = [];

  String _token = '';
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final token = await User.getToken();
    // debugPrint('Got token $token');
    setState(() {
      _token = token ?? '';
    });
    var productsToSet = Product.fetchProducts(
      endpoint: widget.apiUri,
      token: _token,
    );
    Result<List<Product>, String> productFuture = await productsToSet;
    if (productFuture is Ok<List<Product>, String>) {
      _searchWidgets = productFuture.value.map((product) {
        return SearchItem(
          widgetBuilder: (context) => ProductCard(product: product),
          textsInside: [
            product.name,
            product.description,
            product.price.toString(),
          ],
        );
      }).toList();
    }
    // Only fetch products after token is ready
    setState(() {
      _futureProducts = productsToSet;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_futureProducts == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return FutureBuilder<Result<List<Product>, String>>(
      future: _futureProducts!,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: ErrorView(error: snapshot.error));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No products found.'));
        }

        final result = snapshot.data!;

        switch (result) {
          case Ok<List<Product>, String>(value: final products):
            if (products.isEmpty) {
              return const Center(child: Text('No products found.'));
            }
            return SearchCard(items: _searchWidgets);

          case Err<List<Product>, String>(error: final error):
            return Center(child: ErrorView(error: error.toString()));

          // Fallback — Dart requires exhaustiveness
          default:
            return const Center(child: Text('Unexpected result '));
        }
      },
    );
  }
}
