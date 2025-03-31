import 'package:essenciacompany_mobile/core/cart_service.dart';
import 'package:essenciacompany_mobile/domain/shop_requests.dart';
import 'package:essenciacompany_mobile/presentation/component/layout/pos_layout.dart';
import 'package:essenciacompany_mobile/presentation/component/pos_shop/product_item.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PosShopView extends StatefulWidget {
  const PosShopView({super.key});

  @override
  State<PosShopView> createState() => _PosShopViewState();
}

class _PosShopViewState extends State<PosShopView> {
  List<dynamic> _productsList = [
    {'id': 0, 'name': 'Product name', 'price': 6.00, 'quantity': 0},
    {'id': 1, 'name': 'Product name', 'price': 5.00, 'quantity': 0},
    {'id': 2, 'name': 'Product name', 'price': 8.00, 'quantity': 0},
    {'id': 3, 'name': 'Product name', 'price': 3.00, 'quantity': 0},
    {'id': 4, 'name': 'Product name', 'price': 7.00, 'quantity': 0},
    {'id': 5, 'name': 'Product name', 'price': 2.00, 'quantity': 0}
  ];

  CartService cartService = CartService();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final token = _prefs.getString('token');
    final res = await getProducts(token: token);
    print(res);
    if (res['success']) {
      setState(() {
        _productsList = res['data'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PosLayout(
        title: 'POS name',
        onRefresh: loadData,
        child: Column(
          children: [
            for (int i = 0; i < _productsList.length; i++)
              ProductItem(
                index: i,
                name: _productsList[i]['name'] ?? '',
                price: _productsList[i]['price'] ?? 0.00,
                quantity:
                    cartService.getItem(_productsList[i]['id'])['quantity'] ??
                        0,
                addItem: () {
                  cartService.addItem(_productsList[i]);
                  setState(() {});
                },
                updateQuantity: (qty) {
                  cartService.updateQuantity(_productsList[i], qty);
                  setState(() {});
                },
              ),
            Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                    color: const Color(0xff737373),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black,
                          offset: Offset(2, 2),
                          blurRadius: 5)
                    ]),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.shopping_cart,
                        size: 40,
                        color: Colors.white,
                      ),
                      Text(
                        '${cartService.totalItems} Items',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w900),
                      ),
                      // SizedBox.expand(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${cartService.totalPrice}€',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w900),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xff28badf),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'PAY',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900),
                              ),
                            ),
                          ),
                        ],
                      )
                    ]))
          ],
        ));
  }
}
