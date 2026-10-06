import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../widgets/product_card.dart';

// StatefulWidget: halaman Home. State lokalnya adalah kategori yang dipilih.
class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.onShopNow});

  // Callback ke AppShell untuk pindah tab (lifting state up).
  final VoidCallback onShopNow;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // State: kategori terpilih. null berarti semua kategori.
  String? selectedCategory;

  // Pilih kategori; menekan kategori yang sama lagi akan membatalkan filter.
  void selectCategory(String category) {
    setState(() {
      selectedCategory = selectedCategory == category ? null : category;
    });
  }

  @override
  Widget build(BuildContext context) {
    // context.watch: halaman di-build ulang saat stok/produk berubah.
    final products = context.watch<CartProvider>().products;

    // State turunan: daftar produk hasil filter kategori.
    final visibleProducts = products.where((product) {
      return selectedCategory == null || product.category == selectedCategory;
    }).toList();

    // Scaffold: kerangka halaman.
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      // SafeArea: hindari area notch / status bar.
      body: SafeArea(
        // SingleChildScrollView: halaman bisa di-scroll.
        child: SingleChildScrollView(
          // Padding: jarak tepi halaman.
          child: Padding(
            padding: const EdgeInsets.all(20),
            // Column: susun konten ke bawah.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row: judul di kiri, ikon tas di kanan.
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Column: sapaan + nama toko.
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text: sapaan.
                        Text(
                          'Selamat Datang!',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Text: nama toko.
                        const Text(
                          'JerseyStore',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    // Container: kotak putih berisi ikon.
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      // Icon: ikon tas belanja.
                      child: const Icon(Icons.shopping_bag_outlined, size: 26),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Container: banner promo.
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.red.shade700,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  // Row: teks promo + ikon bola.
                  child: Row(
                    children: [
                      // Expanded: teks mengisi sisa lebar.
                      Expanded(
                        // Column: judul, deskripsi, tombol.
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text: judul banner.
                            const Text(
                              'Jersey Terbaru',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            // Text: deskripsi banner.
                            const Text(
                              'Dapatkan diskon hingga 30%',
                              style: TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 14),
                            // ElevatedButton: pindah ke tab Explore.
                            ElevatedButton(
                              onPressed: widget.onShopNow,
                              child: const Text('Belanja Sekarang'),
                            ),
                          ],
                        ),
                      ),
                      // Icon: dekorasi bola.
                      const Icon(
                        Icons.sports_soccer,
                        color: Colors.white,
                        size: 65,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                // Text: judul bagian kategori.
                const Text(
                  'Kategori',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 14),
                // Row: tiga kategori sama lebar.
                Row(
                  children: [
                    // Expanded: membagi lebar sama rata.
                    Expanded(
                      child: _categoryItem(Icons.sports_soccer, 'Football'),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _categoryItem(
                        Icons.sports_basketball,
                        'Basketball',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _categoryItem(Icons.directions_run, 'Running'),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                // Text: judul daftar produk, berubah mengikuti state filter.
                Text(
                  selectedCategory == null
                      ? 'Jersey Populer'
                      : 'Jersey $selectedCategory',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                // GridView.builder: grid 2 kolom; shrinkWrap + tanpa scroll
                // sendiri karena sudah berada di dalam SingleChildScrollView.
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: visibleProducts.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    mainAxisExtent: 260,
                  ),
                  itemBuilder: (context, index) {
                    // ProductCard: satu kartu produk.
                    return ProductCard(product: visibleProducts[index]);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Item kategori yang bisa ditekan; tampilannya berubah saat terpilih.
  Widget _categoryItem(IconData icon, String title) {
    final isSelected = selectedCategory == title;

    // InkWell: area yang bisa ditekan dengan efek ripple.
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => selectCategory(title),
      // Container: kotak kategori, warna mengikuti state isSelected.
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red.shade700 : Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        // Column: ikon di atas, teks di bawah.
        child: Column(
          children: [
            // Icon: ikon kategori.
            Icon(
              icon,
              size: 28,
              color: isSelected ? Colors.white : Colors.red.shade700,
            ),
            const SizedBox(height: 8),
            // Text: nama kategori.
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
