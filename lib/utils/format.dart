// Mengubah angka menjadi format rupiah, contoh: 249000 -> Rp249.000
String formatRupiah(int value) {
  final text = value.toString();
  final buffer = StringBuffer();

  for (int i = 0; i < text.length; i++) {
    // Sisipkan titik setiap 3 digit dari belakang.
    if (i > 0 && (text.length - i) % 3 == 0) {
      buffer.write('.');
    }
    buffer.write(text[i]);
  }

  return 'Rp${buffer.toString()}';
}
