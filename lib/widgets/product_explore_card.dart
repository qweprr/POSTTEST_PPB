import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../utils/format.dart';
import 'product_card.dart';

// StatefulWidget: kartu produk di halaman Explore. Punya state lokal berupa
// jumlah yang ingin dibeli (quantity) dan TextEditingController-nya.
class ProductExploreCard extends StatefulWidget {
  const ProductExploreCard({super.key, required this.product});

  final Product product;

  @override
  State<ProductExploreCard> createState() => _ProductExploreCardState();
}

class _ProductExploreCardState extends State<ProductExploreCard> {
  // Controller untuk membaca/menulis isi TextField jumlah.
  late final TextEditingController quantityController;

  // State lokal: jumlah yang akan ditambahkan ke keranjang.
  int quantity = 1;

  // initState: dijalankan SEKALI saat State dibuat -> siapkan controller.
  @override
  void initState() {
    super.initState();
    quantityController = TextEditingController(text: '$quantity');
  }

  // dispose: dijalankan saat widget dibuang -> bebaskan controller
  // agar tidak terjadi kebocoran memori.
  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }

  // Validasi input jumlah: tolak bukan angka / < 1, batasi maksimal stok.
  void updateQuantity(String value) {
    final parsed = int.tryParse(value);
    if (parsed == null || parsed < 1) return;

    final clamped = parsed.clamp(1, widget.product.stock).toInt();
    setState(() {
      quantity = clamped;
    });

    // Jika angka dikoreksi (melebihi stok), samakan teks di TextField.
    if (clamped != parsed) {
      quantityController.text = '$clamped';
      quantityController.selection = TextSelection.collapsed(
        offset: quantityController.text.length,
      );
    }
  }

  // Tambah ke keranjang lalu kembalikan jumlah ke 1.
  void addToCart() {
    final added = context.read<CartProvider>().addToCart(
          widget.product,
          quantity: quantity,
        );
    if (added == 0) return;

    showAddedSnackBar(context, widget.product.name, qty: added);

    setState(() {
      quantity = 1;
      quantityController.text = '$quantity';
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    // Card: kartu produk.
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      // Padding: jarak dalam kartu.
      child: Padding(
        padding: const EdgeInsets.all(14),
        // Column: baris info produk di atas, baris jumlah di bawah.
        child: Column(
          children: [
            // Row: gambar di kiri, detail di kanan.
            Row(
              children: [
                // Container: kotak ikon produk.
                Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  // Icon: ikon jersey.
                  child: Icon(
                    product.icon,
                    size: 40,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(width: 14),
                // Expanded: detail mengisi sisa lebar baris.
                Expanded(
                  // Column: nama, kategori, harga, stok.
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text: nama produk.
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Text: kategori.
                      Text(
                        product.category,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 4),
                      // Text: harga.
                      Text(
                        formatRupiah(product.price),
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Text: sisa stok.
                      Text(
                        'Stok: ${product.stock}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Row: input jumlah + tombol tambah.
            Row(
              children: [
                // Text: label.
                const Text(
                  'Jumlah:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                // SizedBox: membatasi lebar TextField.
                SizedBox(
                  width: 70,
                  // TextField: input jumlah; onChanged memanggil
                  // updateQuantity setiap kali pengguna mengetik.
                  child: TextField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    onChanged: updateQuantity,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                ),
                // Spacer: dorong tombol ke kanan.
                const Spacer(),
                // ElevatedButton: nonaktif bila stok habis.
                ElevatedButton(
                  onPressed: product.stock > 0 ? addToCart : null,
                  child: const Text('Tambah'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
