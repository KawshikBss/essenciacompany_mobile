import 'dart:convert';

import 'package:essenciacompany_mobile/core/cart_service.dart';
import 'package:essenciacompany_mobile/domain/shop_requests.dart';
import 'package:essenciacompany_mobile/presentation/component/custom_app_bar.dart';
import 'package:essenciacompany_mobile/presentation/component/pos_shop/dialogs/order_dialog.dart';
import 'package:essenciacompany_mobile/presentation/component/pos_shop/product_item.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PosShopView extends StatefulWidget {
  const PosShopView({super.key});

  @override
  State<PosShopView> createState() => _PosShopViewState();
}

class _PosShopViewState extends State<PosShopView> {
  List<dynamic> _eventsList = [];
  List<dynamic> _productsList = [];
  String? _selectedEvent;
  String? _pos;
  bool _showSearchbar = false;
  final TextEditingController _searchController = TextEditingController();

  toggleSearchBar() {
    setState(() {
      _showSearchbar = !_showSearchbar;
    });
  }

  CartService cartService = CartService();

  @override
  void initState() {
    super.initState();
    loadData();
    _searchController.addListener(() {
      refetchExtras();
    });
  }

  loadData() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final user = jsonDecode(_prefs.getString('user') ?? '{}');
    setState(() {
      _productsList = [];
      _pos = user['pos']['name'] ?? 'Essencia Company';
    });
    final token = _prefs.getString('token');
    final events = await getEvents(token: token);
    if (events['success']) {
      setState(() {
        _eventsList = events['data'];
      });
      try {
        setState(() {
          _selectedEvent = '${events['data'][0]['id']}';
        });
      } catch (err) {
        print(err.toString());
      }
    }
    final res = await getProducts(
        token: token, eventId: _selectedEvent, query: _searchController.text);
    if (res['success']) {
      setState(() {
        _productsList = res['data'];
      });
    }
  }

  refetchExtras() async {
    cartService.resetCart();
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final token = _prefs.getString('token');
    final res = await getProducts(
        token: token, eventId: _selectedEvent, query: _searchController.text);
    if (res['success']) {
      setState(() {
        _productsList = res['data'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        extendBodyBehindAppBar: true,
        appBar: CustomAppBar.showPosAppBar(context,
            title: '$_pos',
            onRefresh: loadData,
            showSearchbar: _showSearchbar,
            toggleSearchbar: toggleSearchBar,
            searchController: _searchController),
        body: SafeArea(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 16),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black45,
                                offset: Offset(0, 2),
                                blurRadius: 5)
                          ]),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          isExpanded: true,
                          isDense: true,
                          items: _eventsList.isNotEmpty
                              ? _eventsList
                                  .map((eventItem) => DropdownMenuItem(
                                      child: Text(eventItem['name']),
                                      onTap: () {
                                        setState(() {
                                          _selectedEvent = '${eventItem['id']}';
                                        });
                                        refetchExtras();
                                      }))
                                  .toList()
                              : [],
                          onChanged: (_) {},
                        ),
                      ),
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                      child: Column(
                        children: [
                          for (int i = 0; i < _productsList.length; i++)
                            ProductItem(
                              index: i,
                              name: _productsList[i]['name'] ?? '',
                              price: double.tryParse(
                                      '${_productsList[i]['price']}') ??
                                  0.00,
                              quantity: cartService.getItem(
                                      _productsList[i]['id'])['quantity'] ??
                                  0,
                              addItem: () {
                                cartService.addItem(_productsList[i]);
                                setState(() {});
                              },
                              updateQuantity: (qty) {
                                cartService.updateQuantity(
                                    _productsList[i], qty);
                                setState(() {});
                              },
                            ),
                        ],
                      ),
                    )),
                    Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 20),
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
                                    onTap: () {
                                      if (cartService.items.isEmpty) {
                                        Fluttertoast.showToast(
                                            msg: 'Cart is empty',
                                            gravity: ToastGravity.TOP,
                                            backgroundColor:
                                                const Color(0xFFF36A30),
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                        return;
                                      }
                                      showDialog(
                                          context: context,
                                          builder: (context) => OrderDialog(
                                                products: cartService.items,
                                                eventId: _selectedEvent,
                                              ));
                                    },
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
                ))));
  }
}
