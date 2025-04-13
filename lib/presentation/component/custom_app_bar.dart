import 'package:essenciacompany_mobile/presentation/component/pos_shop/dialogs/menu_dialog.dart';
import 'package:essenciacompany_mobile/presentation/component/pos_shop/dialogs/pos_menu_dialog.dart';
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
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => const MenuDialog());
                    },
                    icon: const Icon(Icons.more_vert),
                    // color: Colors.white,
                    iconSize: 30,
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
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            const PosMenuDialog(),
                      );
                    },
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
