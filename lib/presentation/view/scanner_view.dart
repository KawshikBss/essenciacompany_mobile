import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum Option { checkin, checkout }

class ScannerView extends StatefulWidget {
  const ScannerView({super.key});

  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> {
  Option _selectedOption = Option.checkin;

  void _selectOption(Option option) {
    setState(() {
      _selectedOption = option;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    height: 162,
                    width: 162,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          _selectOption(Option.checkin);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedOption == Option.checkin
                              ? Color(0xFFF36A30)
                              : Color(0x66F36A30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(color: Colors.black),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 35, vertical: 12),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 24,
                            ),
                            Image.asset('assets/checkin.png'),
                            const SizedBox(
                              height: 11,
                            ),
                            Text(
                              'CHECK IN',
                              style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      ),
                    )),
                const SizedBox(
                  width: 23,
                ),
                SizedBox(
                    height: 162,
                    width: 164,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () => _selectOption(Option.checkout),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedOption == Option.checkout
                              ? Color(0xFFF36A30)
                              : Color(0x66F36A30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: const BorderSide(color: Colors.grey),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 24,
                            ),
                            Image.asset('assets/checkout.png'),
                            const SizedBox(
                              height: 11,
                            ),
                            Text(
                              'CHECK OUT',
                              style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Scan Ticket',
              style: GoogleFonts.roboto(
                textStyle: TextStyle(fontSize: 45, fontWeight: FontWeight.w200),
              ),
            ),
            const SizedBox(
              height: 21,
            ),
            GestureDetector(
                onTap: () {},
                child: Image.asset(
                  'assets/scan.png',
                  width: 241,
                  height: 241,
                )),
            const SizedBox(
              height: 15,
            ),
            Text(
              'DOOR 1',
              style: GoogleFonts.roboto(
                textStyle: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
