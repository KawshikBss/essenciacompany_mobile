import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerWidget extends StatefulWidget {
  final Function(dynamic) onScan;
  const ScannerWidget({super.key, required this.onScan});

  @override
  State<ScannerWidget> createState() => _ScannerWidgetState();
}

class _ScannerWidgetState extends State<ScannerWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: MobileScanner(
      controller: MobileScannerController(
        detectionSpeed: DetectionSpeed.noDuplicates,
        returnImage: true,
      ),
      onDetect: widget.onScan,
    ));
  }
}
