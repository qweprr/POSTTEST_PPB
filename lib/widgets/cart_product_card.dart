import 'package:flutter/material.dart';

import '../models/product.dart';
import '../utils/format.dart';

// StatefulWidget: kartu item di keranjang. State lokalnya adalah
// TextEditingController untuk input jumlah. Nilai jumlah aslinya (quantity)
// milik CartProvider dan dikirim lewat constructor.
class CartProductCard extends StatefulWidget {
  const CartProductCard({
    super.key,
    required this.product,
    required this.quantity,
    required this.maxQuantity,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  final Product product;
  final int quantity;
  final int maxQuantity; // jumlah di keranjang + sisa stok
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;

  @override
  State<CartProductCard> createState() => _CartProductCardState();
}

class _CartProductCardState extends State<CartProductCard> {
  late final TextEditingController quantityController;

  // initState: isi awal TextField sesuai jumlah di keranjang.
  @override
  void initState() {
    super.initState();
    quantityController = TextEditingController(text: '${widget.quantity}');
  }

  // didUpdateWidget: dipanggil saat data dari luar berubah (misal tombol +/-
  // atau perubahan dari provider). Teks TextField disamakan dengan quantity.
  @override
  void didUpdateWidget(covariant CartProductCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.quantity != widget.quantity &&
        quantityController.text != '${widget.quantity}') {
      quantityController.text = '${widget.quantity}';
    }
  }

  // dispose: bebaskan controller saat kartu dibuang dari tree.
  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }

  // Validasi input: tolak bukan angka / < 1, lalu batasi dengan maxQuantity
  // dan teruskan ke provider lewat callback.
  void updateQuantity(String value) {
    final parsed = int.tryParse(value);
    if (parsed == null || parsed < 1) return;

    final clamped = parsed.clamp(1, widget.maxQuantity).toInt();
    widget.onQuantityChanged(clamped);

    // Jika dikoreksi tetapi quantity tidak berubah (sudah maksimal),
    // didUpdateWidget tidak terpanggil, jadi samakan teks secara manual.
    if (clamped != parsed) {
      quantityController.text = '$clamped';
      quantityController.selection = TextSelection.collapsed(
        offset: quantityController.text.length,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Card: kartu item keranjang.
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      // Padding: jarak dalam kartu.
      child: Padding(
        padding: const EdgeInsets.all(14),
        // Row: gambar - detail - tombol hapus.
        child: Row(
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
              child: Icon(widget.product.icon, size: 40),
            ),
            const SizedBox(width: 14),
            // Expanded: detail mengisi sisa lebar.
            Expanded(
              // Column: nama, harga, kontrol jumlah.
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text: nama produk.
                  Text(
                    widget.product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  // Text: harga satuan.
                  Text(
                    formatRupiah(widget.product.price),
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Row: tombol kurang - input - tombol tambah.
                  Row(
                    children: [
                      // IconButton: kurangi jumlah (nonaktif saat jumlah 1).
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: widget.quantity > 1
                            ? () => widget.onQuantityChanged(
                                  widget.quantity - 1,
                                )
                            : null,
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      // SizedBox: membatasi lebar TextField.
                      SizedBox(
                        width: 45,
                        // TextField: ketik jumlah langsung.
                        child: TextField(
                          controller: quantityController,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          onChanged: updateQuantity,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      // IconButton: tambah jumlah (nonaktif saat stok habis).
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: widget.quantity < widget.maxQuantity
                            ? () => widget.onQuantityChanged(
                                  widget.quantity + 1,
                                )
                            : null,
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // IconButton: hapus item dari keranjang.
            IconButton(
              onPressed: widget.onRemove,
              icon: const Icon(Icons.delete_outline, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
