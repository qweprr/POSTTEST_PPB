import 'package:flutter/material.dart';

import '../models/product.dart';

// ---------------------------------------------------------------------------
// KONSEP DI LUAR MODUL: Provider (ChangeNotifier)
// ---------------------------------------------------------------------------
// CartProvider menyimpan state global (daftar produk, stok, isi keranjang).
// Setiap kali state berubah kita memanggil notifyListeners(), lalu semua
// widget yang memakai context.watch / Consumer / context.select otomatis
// di-build ulang. Ini menggantikan "lifting state up" + callback manual
// yang sebelumnya dilakukan dengan setState() di MainNavigation.
// ---------------------------------------------------------------------------
class CartProvider extends ChangeNotifier {
  // Daftar produk (stok awal). Stok akan berkurang saat masuk keranjang.
  final List<Product> products = [
    Product(
      id: 'jersey-home',
      name: 'Jersey Home',
      category: 'Football',
      price: 249000,
      stock: 10,
      icon: Icons.checkroom,
    ),
    Product(
      id: 'jersey-away',
      name: 'Jersey Away',
      category: 'Football',
      price: 279000,
      stock: 8,
      icon: Icons.checkroom,
    ),
    Product(
      id: 'jersey-basketball',
      name: 'Jersey Basketball',
      category: 'Basketball',
      price: 259000,
      stock: 6,
      icon: Icons.sports_basketball,
    ),
    Product(
      id: 'jersey-indonesia',
      name: 'Jersey Indonesia',
      category: 'Football',
      price: 299000,
      stock: 5,
      icon: Icons.flag,
    ),
    Product(
      id: 'jersey-running',
      name: 'Jersey Running',
      category: 'Running',
      price: 219000,
      stock: 7,
      icon: Icons.directions_run,
    ),
  ];

  // Isi keranjang: id produk -> jumlah yang dibeli.
  final Map<String, int> cartQuantities = {};

  // State turunan: dihitung dari cartQuantities, tidak disimpan terpisah.
  int get totalItems =>
      cartQuantities.values.fold(0, (total, qty) => total + qty);

  // State turunan: dipakai tombol Checkout (aktif hanya jika > 0).
  int get grandTotal => products.fold(0, (total, product) {
        return total + product.price * (cartQuantities[product.id] ?? 0);
      });

  // Produk yang sedang ada di keranjang.
  List<Product> get cartProducts =>
      products.where((p) => cartQuantities.containsKey(p.id)).toList();

  // Jumlah produk tertentu di keranjang.
  int quantityOf(Product product) => cartQuantities[product.id] ?? 0;

  // Tambah ke keranjang sebanyak [quantity]; stok produk ikut berkurang.
  // Mengembalikan jumlah yang benar-benar berhasil ditambahkan.
  int addToCart(Product product, {int quantity = 1}) {
    final added = quantity.clamp(0, product.stock).toInt();
    if (added == 0) return 0;

    product.stock -= added;
    cartQuantities[product.id] = quantityOf(product) + added;
    notifyListeners(); // beri tahu semua widget yang memantau state ini
    return added;
  }

  // Ubah jumlah di keranjang. Batas atas = jumlah sekarang + sisa stok.
  void changeQuantity(Product product, int quantity) {
    final current = quantityOf(product);
    final maxQuantity = current + product.stock;
    final next = quantity.clamp(1, maxQuantity).toInt();

    product.stock += current - next; // sesuaikan stok dengan selisihnya
    cartQuantities[product.id] = next;
    notifyListeners();
  }

  // Hapus produk dari keranjang; stoknya dikembalikan.
  void removeFromCart(Product product) {
    final current = cartQuantities.remove(product.id) ?? 0;
    product.stock += current;
    notifyListeners();
  }

  // Checkout: kosongkan keranjang (stok tetap berkurang karena sudah dibeli).
  // Mengembalikan total pembayaran untuk ditampilkan di halaman sukses.
  int checkout() {
    final total = grandTotal;
    cartQuantities.clear();
    notifyListeners();
    return total;
  }
}
