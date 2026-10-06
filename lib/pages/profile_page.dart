import 'package:flutter/material.dart';

// StatefulWidget: halaman profil. State lokalnya adalah status switch
// notifikasi.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // State: notifikasi promo aktif / tidak.
  bool notificationsOn = true;

  @override
  Widget build(BuildContext context) {
    // Scaffold: kerangka halaman.
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      // AppBar: judul halaman.
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      // SingleChildScrollView: halaman bisa di-scroll.
      body: SingleChildScrollView(
        // Padding: jarak tepi.
        child: Padding(
          padding: const EdgeInsets.all(20),
          // Column: avatar, nama, menu.
          child: Column(
            children: [
              // CircleAvatar: foto profil (ikon).
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.red,
                child: Icon(Icons.person, size: 55, color: Colors.white),
              ),
              const SizedBox(height: 14),
              // Text: nama pengguna.
              const Text(
                'JerseyStore User',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              // Text: email.
              Text(
                'user@jerseystore.com',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 30),
              // Card: daftar menu.
              Card(
                // Column: menu disusun ke bawah.
                child: Column(
                  children: [
                    // ListTile: menu informasi akun.
                    const ListTile(
                      leading: Icon(Icons.person_outline),
                      title: Text('Informasi Akun'),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                    // Divider: garis pemisah.
                    const Divider(height: 1),
                    // ListTile: menu alamat.
                    const ListTile(
                      leading: Icon(Icons.location_on_outlined),
                      title: Text('Alamat Pengiriman'),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                    const Divider(height: 1),
                    // ListTile: menu riwayat.
                    const ListTile(
                      leading: Icon(Icons.receipt_long_outlined),
                      title: Text('Riwayat Pesanan'),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                    const Divider(height: 1),
                    // SwitchListTile: switch notifikasi; onChanged -> setState
                    // mengubah state notificationsOn.
                    SwitchListTile(
                      secondary: const Icon(Icons.notifications_outlined),
                      title: const Text('Notifikasi Promo'),
                      value: notificationsOn,
                      onChanged: (value) {
                        setState(() => notificationsOn = value);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
