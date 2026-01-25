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
    final theme = Theme.of(context);

    return Card(
      color: Theme.of(context).colorScheme.surfaceVariant,
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
