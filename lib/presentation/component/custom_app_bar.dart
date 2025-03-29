import 'package:flutter/material.dart';

class CustomAppBar {
  static showCustomAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /* const Image(
                image: AssetImage('assets/logo.png'),
                height: 60,
                fit: BoxFit.fitHeight,
              ), */
              Builder(
                builder: (context) {
                  return IconButton(
                    icon: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x8FF36A30),
                            spreadRadius: 0,
                            blurRadius: 3,
                            offset: Offset(2, 2),
                          )
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.menu),
                      ),
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    iconSize: 32,
                  );
                },
              ),
            ],
          )),
    );
  }
}
