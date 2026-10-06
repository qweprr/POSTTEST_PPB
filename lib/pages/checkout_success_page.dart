import 'package:flutter/material.dart';

import '../utils/format.dart';

// StatelessWidget: halaman sukses setelah checkout. Hanya menampilkan
// total yang dikirim lewat constructor.
class CheckoutSuccessPage extends StatelessWidget {
  const CheckoutSuccessPage({super.key, required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    // Scaffold: kerangka halaman.
    return Scaffold(
      backgroundColor: Colors.white,
      // SafeArea: hindari area notch.
      body: SafeArea(
        // Center: isi di tengah layar.
        child: Center(
          // Padding: jarak tepi.
          child: Padding(
            padding: const EdgeInsets.all(24),
            // Column: ikon, teks, tombol.
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // CircleAvatar: lingkaran hitam berisi ikon centang.
                const CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.black,
                  child: Icon(Icons.check, size: 55, color: Colors.white),
                ),
                const SizedBox(height: 20),
                // Text: label.
                const Text('Total', style: TextStyle(fontSize: 22)),
                const SizedBox(height: 6),
                // Text: total pembayaran.
                Text(
                  formatRupiah(total),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                // SizedBox: tombol selebar layar.
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  // FilledButton: kembali ke aplikasi.
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Kembali'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
