import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../widgets/product_explore_card.dart';

// StatefulWidget: halaman Explore. State lokalnya adalah teks pencarian.
class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  // Controller TextField pencarian (untuk tombol clear).
  late final TextEditingController searchController;

  // State: kata kunci pencarian (huruf kecil).
  String searchQuery = '';

  // initState: siapkan controller sekali saat halaman dibuat.
  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  // dispose: bebaskan controller saat halaman dibuang.
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // context.watch: rebuild saat stok berubah.
    final products = context.watch<CartProvider>().products;

    // State turunan: produk yang ditampilkan = stok > 0 dan cocok dengan
    // kata kunci pencarian (sesuai contoh di modul).
    final visibleProducts = products.where((product) {
      return product.stock > 0 &&
          product.name.toLowerCase().contains(searchQuery);
    }).toList();

    // Scaffold: kerangka halaman.
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      // AppBar: judul halaman.
      appBar: AppBar(
        title: const Text(
          'Explore Jersey',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      // SingleChildScrollView: halaman bisa di-scroll.
      body: SingleChildScrollView(
        // Padding: jarak tepi halaman.
        child: Padding(
          padding: const EdgeInsets.all(20),
          // Column: susun konten ke bawah.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text: judul bagian pencarian.
              const Text(
                'Cari Jersey',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              // TextField: onChanged -> setState mengubah searchQuery
              // sehingga daftar produk langsung terfilter.
              TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() => searchQuery = value.toLowerCase());
                },
                decoration: InputDecoration(
                  hintText: 'Cari jersey...',
                  prefixIcon: const Icon(Icons.search),
                  // Tombol clear hanya muncul jika ada teks (state turunan).
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            searchController.clear();
                            setState(() => searchQuery = '');
                          },
                          icon: const Icon(Icons.clear),
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Text: judul hasil, berubah mengikuti searchQuery.
              Text(
                searchQuery.isEmpty
                    ? 'Semua Produk'
                    : 'Hasil untuk "$searchQuery"',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              // Tampilan kosong bila tidak ada produk yang cocok.
              if (visibleProducts.isEmpty)
                // Container: kotak informasi.
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  // Column: ikon + teks.
                  child: const Column(
                    children: [
                      // Icon: ikon pencarian kosong.
                      Icon(Icons.search_off, size: 60, color: Colors.grey),
                      SizedBox(height: 12),
                      // Text: pesan.
                      Text(
                        'Produk tidak ditemukan',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              // ListView.builder: daftar kartu produk (tanpa scroll sendiri).
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: visibleProducts.length,
                itemBuilder: (context, index) {
                  // ProductExploreCard: kartu dengan input jumlah.
                  // Key memastikan state kartu mengikuti produknya.
                  return ProductExploreCard(
                    key: ValueKey(visibleProducts[index].id),
                    product: visibleProducts[index],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
