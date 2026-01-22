import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:client/models/products.dart';
import 'package:client/widgets/error.dart';
import 'package:client/models/user.dart';
import 'package:flutter/foundation.dart';

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
      elevation: 4,
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${formatRupiah(product.price)}',
                  style: const TextStyle(fontSize: 16, color: Colors.green),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) =>
                            ProductDetailWidget(product: product),
                      ),
                    );
                  },
                  icon: Icon(Icons.search),
                  label: Text('Details'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
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
        backgroundColor: Colors.orange,
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
  Future<List<Product>>? _futureProducts;
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

    // Only fetch products after token is ready
    setState(() {
      _futureProducts = Product.fetchProducts(
        endpoint: widget.apiUri,
        token: _token,
      );
    });
  }
  @override
  Widget build(BuildContext context) {

    if (_futureProducts == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return FutureBuilder<List<Product>>(
      future: _futureProducts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: ErrorView(error: snapshot.error));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No products found.'));
        }

        final products = snapshot.data!;
        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            return ProductCard(product: products[index]);
          },
        );
      },
    );
  }
}
