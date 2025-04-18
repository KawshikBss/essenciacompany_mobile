import 'package:essenciacompany_mobile/presentation/view/auth/login_view.dart';
import 'package:essenciacompany_mobile/presentation/view/checkin_checkout/checkin_checkout_view.dart';
import 'package:essenciacompany_mobile/presentation/view/enter_code_view.dart';
import 'package:essenciacompany_mobile/presentation/view/pos/orders_view.dart';
import 'package:essenciacompany_mobile/presentation/view/pos/pos_shop_view.dart';
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
      home: const CheckinCheckoutView(),
      routes: {
        '/login': (context) => const LoginView(),
        '/enter-code': (context) => const EnterCodeView(),
        '/pos/shop': (context) => const PosShopView(),
        '/pos/orders': (context) => const OrdersView(),
      },
    );
  }
}
