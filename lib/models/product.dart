import 'package:flutter/widgets.dart';

// Model data produk jersey.
// "stock" dibuat tidak final karena nilainya berubah (state) setiap kali
// produk dimasukkan / dikeluarkan dari keranjang.
class Product {
  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.icon,
  });

  final String id; // identitas unik produk (kunci keranjang)
  final String name;
  final String category;
  final int price;
  int stock; // state: berkurang saat ditambah ke keranjang
  final IconData icon;
}
