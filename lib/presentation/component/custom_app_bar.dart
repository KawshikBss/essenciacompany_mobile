import 'package:flutter/material.dart';

class CustomAppBar {
  static showCustomAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(
                      Icons.menu,
                      // size: 30,
                      shadows: [
                        BoxShadow(
                          color: Color(0x8FF36A30),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: Offset(1, 1),
                        )
                      ],
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

  static showPosAppBar(BuildContext context,
      {String? title, Function? onRefresh}) {
    return AppBar(
      automaticallyImplyLeading: false,
      forceMaterialTransparency: true,
      flexibleSpace: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          color: Colors.blueGrey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title ?? 'POS',
                style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      if (onRefresh != null) {
                        onRefresh();
                      }
                    },
                    icon: const Icon(Icons.loop),
                    color: Colors.white,
                    iconSize: 30,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search),
                    color: Colors.white,
                    iconSize: 30,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert),
                    color: Colors.white,
                    iconSize: 30,
                  ),
                ],
              )
            ],
          )),
    );
  }
}
