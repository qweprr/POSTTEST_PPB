import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/app_shell.dart';
import 'providers/cart_provider.dart';

void main() {
  runApp(
    // ChangeNotifierProvider (package provider): membuat satu CartProvider
    // dan membagikannya ke seluruh widget di bawahnya (semua halaman).
    ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: const JerseyStoreApp(),
    ),
  );
}

// StatelessWidget: root aplikasi, tidak punya state sendiri.
class JerseyStoreApp extends StatelessWidget {
  const JerseyStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp: pembungkus aplikasi (tema, judul, halaman awal).
    return MaterialApp(
      title: 'JerseyStore',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const AppShell(),
    );
  }
}
