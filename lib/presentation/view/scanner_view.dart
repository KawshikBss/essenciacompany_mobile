import 'package:essenciacompany_mobile/presentation/component/scanner_widget.dart';
import 'package:flutter/material.dart';

class ScannerView extends StatefulWidget {
  const ScannerView({super.key});

  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ScannerWidget(onScan: (dynamic) {}));
  }
}
