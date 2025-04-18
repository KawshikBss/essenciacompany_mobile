import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
              onTap: () {},
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
              onTap: () {
                Navigator.pushNamed(context, '/pos/orders');
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
