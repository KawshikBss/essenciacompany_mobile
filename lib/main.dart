import 'package:essenciacompany_mobile/presentation/view/auth/login_view.dart';
import 'package:essenciacompany_mobile/presentation/view/scanner_view.dart';
import 'package:essenciacompany_mobile/presentation/view/zone/select_zone_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginView(),
      routes: {
        '/login': (context) => const LoginView(),
        '/select_zone': (context) => const SelectZoneView(),
        '/scan-ticket': (context) => const ScannerView(),
      },
    );
  }
}
