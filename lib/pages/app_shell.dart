import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import 'cart_page.dart';
import 'checkout_success_page.dart';
import 'explore_page.dart';
import 'home_page.dart';
import 'profile_page.dart';

// StatefulWidget: cangkang aplikasi. State-nya adalah tab yang sedang aktif.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  // State: indeks tab yang sedang dipilih (0 Home, 1 Explore, 2 Cart, 3 Profile).
  int currentIndex = 0;

  // setState() memberi tahu Flutter bahwa state berubah -> build() diulang.
  void selectPage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  // Dipanggil CartPage saat tombol Checkout ditekan.
  void handleCheckout() {
    // context.read: ambil provider SEKALI tanpa ikut memantau perubahan
    // (cocok dipakai di dalam event handler).
    final total = context.read<CartProvider>().checkout();

    // Navigator.push: pindah ke halaman sukses checkout.
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CheckoutSuccessPage(total: total)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // context.select: hanya rebuild bila totalItems berubah (untuk badge).
    final totalItems = context.select<CartProvider, int>((c) => c.totalItems);

    // Scaffold: kerangka halaman (body + bottom navigation).
    return Scaffold(
      // IndexedStack: menampilkan satu halaman sesuai index, tetapi state
      // halaman lain (misal teks pencarian) tetap tersimpan.
      body: IndexedStack(
        index: currentIndex,
        children: [
          // HomePage: tombol "Belanja Sekarang" memindahkan tab ke Explore.
          HomePage(onShopNow: () => selectPage(1)),
          const ExplorePage(),
          CartPage(onCheckout: handleCheckout),
          const ProfilePage(),
        ],
      ),
      // BottomNavigationBar: menu navigasi bawah.
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: selectPage,
        items: [
          // Item tab Home.
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          // Item tab Explore.
          const BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          // Item tab Cart: Badge menampilkan jumlah barang (state turunan).
          BottomNavigationBarItem(
            icon: Badge(
              label: Text('$totalItems'),
              isLabelVisible: totalItems > 0,
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            activeIcon: Badge(
              label: Text('$totalItems'),
              isLabelVisible: totalItems > 0,
              child: const Icon(Icons.shopping_cart),
            ),
            label: 'Cart',
          ),
          // Item tab Profile.
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
