import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../utils/format.dart';

// StatelessWidget: kartu produk (grid di Home). Tidak punya state sendiri,
// datanya (stok, harga) berasal dari Product milik CartProvider.
class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    // Tombol aktif hanya jika stok > 0 (state turunan dari product.stock).
    final inStock = product.stock > 0;

    // Card: kartu dengan bayangan.
    return Card(
      elevation: 2,
      // Padding: jarak dalam kartu.
      child: Padding(
        padding: const EdgeInsets.all(12),
        // Column: susun isi kartu ke bawah.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container: kotak abu-abu tempat ikon produk.
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              // Icon: gambar ikon jersey.
              child: Icon(product.icon, size: 50, color: Colors.grey.shade700),
            ),
            // SizedBox: spasi vertikal.
            const SizedBox(height: 10),
            // Text: nama produk.
            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            // Text: harga produk.
            Text(
              formatRupiah(product.price),
              style: TextStyle(
                color: Colors.red.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            // Text: sisa stok (ikut berubah saat state stok berubah).
            Text(
              'Stok: ${product.stock}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            // Spacer: dorong tombol ke bagian bawah kartu.
            const Spacer(),
            // SizedBox: membuat tombol selebar kartu.
            SizedBox(
              width: double.infinity,
              // ElevatedButton: onPressed = null membuat tombol nonaktif.
              // Ini contoh state turunan seperti di modul (stock > 0).
              child: ElevatedButton(
                onPressed: inStock
                    ? () {
                        // context.read: panggil aksi provider (tanpa watch).
                        context.read<CartProvider>().addToCart(product);
                        showAddedSnackBar(context, product.name);
                      }
                    : null,
                child: Text(inStock ? 'Tambah' : 'Habis'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Menampilkan notifikasi singkat setelah produk masuk keranjang.
void showAddedSnackBar(BuildContext context, String name, {int qty = 1}) {
  // ScaffoldMessenger: pengelola SnackBar untuk Scaffold terdekat.
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      // SnackBar: pesan sementara di bagian bawah layar.
      SnackBar(
        content: Text('$qty × $name ditambahkan ke keranjang'),
        duration: const Duration(seconds: 1),
      ),
    );
}
