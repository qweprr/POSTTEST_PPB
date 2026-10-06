import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../utils/format.dart';
import '../widgets/cart_product_card.dart';

// StatelessWidget: halaman keranjang. Semua state-nya ada di CartProvider,
// jadi halaman ini cukup "mendengarkan" lewat Consumer.
class CartPage extends StatelessWidget {
  const CartPage({super.key, required this.onCheckout});

  // Dipanggil saat tombol Checkout ditekan (ditangani AppShell).
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    // Scaffold: kerangka halaman.
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      // AppBar: judul halaman.
      appBar: AppBar(
        title: const Text(
          'Keranjang',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      // Consumer: build ulang bagian ini setiap CartProvider berubah.
      body: Consumer<CartProvider>(
        builder: (context, cart, _) {
          final cartProducts = cart.cartProducts;

          // Keranjang kosong -> tampilkan pesan.
          if (cartProducts.isEmpty) {
            // Center: posisikan di tengah layar.
            return const Center(
              // Column: ikon + teks.
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon: ikon keranjang kosong.
                  Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  // Text: pesan keranjang kosong.
                  Text(
                    'Keranjang masih kosong',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }

          // Column: daftar item di atas, ringkasan total di bawah.
          return Column(
            children: [
              // Expanded: daftar mengisi ruang yang tersisa.
              Expanded(
                // ListView.builder: daftar item keranjang.
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: cartProducts.length,
                  itemBuilder: (context, index) {
                    final product = cartProducts[index];
                    final quantity = cart.quantityOf(product);

                    // CartProductCard: satu item keranjang.
                    return CartProductCard(
                      key: ValueKey(product.id),
                      product: product,
                      quantity: quantity,
                      // batas jumlah = jumlah sekarang + sisa stok
                      maxQuantity: quantity + product.stock,
                      onQuantityChanged: (value) =>
                          cart.changeQuantity(product, value),
                      onRemove: () => cart.removeFromCart(product),
                    );
                  },
                ),
              ),
              // Container: panel total di bawah.
              Container(
                padding: const EdgeInsets.all(20),
                color: Colors.white,
                // Column: baris total + tombol checkout.
                child: Column(
                  children: [
                    // Row: label dan nilai total.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Text: label.
                        const Text('Total Belanja'),
                        // Text: total, state turunan dari isi keranjang.
                        Text(
                          formatRupiah(cart.grandTotal),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // SizedBox: tombol selebar layar.
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      // ElevatedButton: aktif hanya bila grandTotal > 0
                      // (state turunan seperti contoh di modul).
                      child: ElevatedButton.icon(
                        onPressed: cart.grandTotal > 0 ? onCheckout : null,
                        icon: const Icon(Icons.shopping_cart_checkout),
                        label: const Text('Checkout'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
