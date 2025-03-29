import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppDrawer {
  static showCustomAppDrawer({Map<String, dynamic>? user, Function? onLogout}) {
    return Drawer(
      shadowColor: const Color(0x8FF36A30),
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (user != null)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Image(
                        image: AssetImage('assets/logo.png'),
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Text(
                        '${user['name']} ${user['l_name']}',
                        style: GoogleFonts.roboto(
                          color: const Color(0xFFF36A30),
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${user['email']}',
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                )
              else
                const SizedBox.shrink(),
              GestureDetector(
                onTap: () {
                  if (onLogout != null) onLogout();
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                        color: const Color(0xFFF36A30),
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.logout,
                          size: 32,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Logout',
                          style: GoogleFonts.roboto(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      ],
                    )),
              )
            ],
          )),
    );
  }
}
