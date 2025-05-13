import 'package:essenciacompany_mobile/presentation/view/pos/check_qr_view.dart';
import 'package:essenciacompany_mobile/presentation/view/scanner_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class PosMenuDialog extends StatefulWidget {
  const PosMenuDialog({super.key});

  @override
  State<PosMenuDialog> createState() => _PosMenuDialogState();
}

class _PosMenuDialogState extends State<PosMenuDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(
          child: Text(
        'Menu Pos',
        style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
      )),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ScannerView(onScan: (code) async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CheckQrView(
                                            qrCode: code,
                                          )));
                            })));
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xff28badf),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Check QrCode',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900),
                ),
              )),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                final token = prefs.getString('token');
                Uri url = Uri.parse(
                    'https://events.essenciacompany.com/app/pos/$token/reports');
                await launchUrl(url, mode: LaunchMode.inAppWebView);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xff28badf),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Orders',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900),
                ),
              )),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/pos/shop');
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xff28badf),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Shop',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900),
                ),
              )),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
              onTap: () async {
                SharedPreferences _prefs =
                    await SharedPreferences.getInstance();
                await _prefs.remove('token');
                await _prefs.remove('user');
                Navigator.pushNamed(context, '/login');
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xff28badf),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Exit Pos',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900),
                ),
              )),
        ],
      ),
    );
  }
}
