import 'package:essenciacompany_mobile/core/cart_service.dart';
import 'package:essenciacompany_mobile/domain/shop_requests.dart';
import 'package:essenciacompany_mobile/presentation/component/pos_shop/dialogs/payment_confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDialog extends StatefulWidget {
  final List<dynamic> products;
  const OrderDialog({super.key, this.products = const []});

  @override
  State<OrderDialog> createState() => _OrderDialogState();
}

class _OrderDialogState extends State<OrderDialog> {
  bool _withdraw = false;
  String _invoice = 'Phone';
  String _paymentMethod = 'Card';
  CartService cartService = CartService();

  _toggleWithdraw() {
    setState(() {
      _withdraw = !_withdraw;
    });
  }

  _handleInvoice(String? value) {
    if (value == null) return;
    setState(() {
      _invoice = value;
    });
  }

  _handlePaymentMethod(String? value) {
    if (value == null) return;
    setState(() {
      _paymentMethod = value;
    });
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _vatController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _vatController.dispose();
    super.dispose();
  }

  submitOrder() async {
    final products = widget.products.map((item) {
      return {
        'id': item['item']['id'],
        'quantity': item['quantity'],
        'price': item['item']['price']
      };
    }).toList();
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _vatController.text.isEmpty) {
      return;
    }

    Map<String, dynamic> orderData = {
      "extras": products,
      'billing': {
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'vatNumber': _vatController.text,
      },
      "payment_method": _paymentMethod,
      "send_message": _invoice == "Phone" ? true : false,
      "send_email": _invoice == "Email" ? true : false,
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    final res = await createOrder(orderData, token: token);
    if (res['success']) {
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _vatController.clear();
      Navigator.of(context).pop();
      showDialog(
          context: context, builder: (context) => const PaymentConfirmDialog());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Finalize Order',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xff28badf),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _nameController,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter name',
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xff28badf),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _emailController,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter email',
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 30),
                decoration: BoxDecoration(
                  color: const Color(0xff28badf),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: () {},
                        child: const Image(
                          image: NetworkImage(
                              'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ad/Flag_of_Portugal_%28alternate%29.svg/1200px-Flag_of_Portugal_%28alternate%29.svg.png'),
                          width: 30,
                          fit: BoxFit.fitWidth,
                        )),
                    Expanded(
                        child: TextField(
                      controller: _phoneController,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter phone',
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ))
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xff28badf),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _vatController,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter VAT number',
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Payment',
                        style: TextStyle(
                            fontSize: 18,
                            color: Color(0xff28badf),
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xff28badf),
                                      width: 4)),
                              child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                isDense: true,
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.arrow_downward_sharp,
                                  size: 18,
                                ),
                                items: <String>[
                                  'Card',
                                  'Cash',
                                ].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: _handlePaymentMethod,
                                hint: const Text(
                                  'Card',
                                ),
                                value: _paymentMethod,
                              ))),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                              onTap: _toggleWithdraw,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xff28badf),
                                        width: 4)),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Withdraw',
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        _withdraw
                                            ? Icons.check_box_outlined
                                            : Icons.check_box_outline_blank,
                                        size: 18,
                                      )
                                    ]),
                              )),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Invoice',
                        style: TextStyle(
                            fontSize: 18,
                            color: Color(0xffec6031),
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 10),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color(0xffec6031), width: 4)),
                          child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                            isDense: true,
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.arrow_downward_sharp,
                              size: 18,
                            ),
                            items: <String>[
                              'Phone',
                              'Email',
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: _handleInvoice,
                            hint: const Text(
                              'Phone',
                            ),
                            value: _invoice,
                          ))),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: submitOrder,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xff28badf),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Finish',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
