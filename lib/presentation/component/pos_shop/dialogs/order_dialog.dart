import 'package:essenciacompany_mobile/core/cart_service.dart';
import 'package:essenciacompany_mobile/domain/shop_requests.dart';
import 'package:essenciacompany_mobile/presentation/component/pos_shop/dialogs/payment_confirm_dialog.dart';
import 'package:essenciacompany_mobile/presentation/view/scanner_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  String? _ticket;
  Map<String, dynamic>? _walletUser;

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
    if (_nameController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Name is required',
          gravity: ToastGravity.CENTER,
          backgroundColor: const Color(0xFFF36A30),
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    if (_invoice == 'Email' && _emailController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Email is required when invoice is sent to email',
          gravity: ToastGravity.CENTER,
          backgroundColor: const Color(0xFFF36A30),
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    if (_invoice == 'Phone' && _phoneController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Phone is required when invoice is sent to phone',
          gravity: ToastGravity.CENTER,
          backgroundColor: const Color(0xFFF36A30),
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }

    Map<String, dynamic> orderData = {
      'user_id': _walletUser != null ? _walletUser!['id'] : null,
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
      cartService.resetCart();
      setState(() {});
      Navigator.of(context).pop();
      showDialog(
          context: context, builder: (context) => const PaymentConfirmDialog());
    }
  }

  _makeQrPayment() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ScannerView(onScan: (data) {
        setState(() {
          _ticket = data;
        });
        Navigator.pop(context);
      });
    }));
    final res = await getUserFromQr(qrCode: _ticket);
    if (res['success']) {
      final userData = res['data'];
      setState(() {
        _walletUser = userData;
        _nameController.text = userData['name'] ?? _nameController.text;
        _emailController.text = userData['email'] ?? _emailController.text;
        _phoneController.text =
            userData['contact_number'] ?? _phoneController.text;
        _vatController.text = userData['vatNumber'] ?? _vatController.text;
      });
    }
  }

  _resetQr() {
    setState(() {
      _ticket = null;
      _walletUser = null;
      _nameController.text = '';
      _emailController.text = '';
      _phoneController.text = '';
      _vatController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(12),
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
              if (_paymentMethod == 'Wallet' && _walletUser != null)
                GestureDetector(
                  onTap: _resetQr,
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          border: Border.all(
                              color: const Color(0xFFF2500B), width: 4)),
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Reset',
                          style:
                              TextStyle(color: Color(0xFFF2500B), fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      )),
                )
              else if (_paymentMethod == 'Wallet')
                GestureDetector(
                  onTap: _makeQrPayment,
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          border: Border.all(
                              color: const Color(0xFFF2500B), width: 4)),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.qr_code_scanner,
                              size: 32, color: Color(0xFFF2500B)),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Pay with QR Code',
                            style: TextStyle(
                                color: Color(0xFFF2500B), fontSize: 20),
                            textAlign: TextAlign.center,
                          )
                        ],
                      )),
                ),
              if (_paymentMethod == 'Wallet' && _walletUser != null)
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      if (_walletUser != null &&
                          _walletUser!['name'] != null &&
                          _walletUser!['name']!.isNotEmpty)
                        Text(
                          '${_walletUser!['name']}',
                          style: const TextStyle(
                              color: Color(0xFFF2500B), fontSize: 30),
                          textAlign: TextAlign.start,
                        ),
                      if (_walletUser != null &&
                          _walletUser!['email'] != null &&
                          _walletUser!['email']!.isNotEmpty)
                        Text(
                          '${_walletUser!['email']}',
                          style: const TextStyle(
                              color: Color(0xFF676767), fontSize: 16),
                          textAlign: TextAlign.start,
                        ),
                      if (_walletUser != null &&
                          _walletUser!['balance'] != null)
                        Text(
                          'Є${_walletUser!['balance']}',
                          style: const TextStyle(
                              color: Color(0xFFF2500B), fontSize: 26),
                          textAlign: TextAlign.start,
                        ),
                    ]),
              const SizedBox(height: 20),
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
                    /* GestureDetector(
                        onTap: () {},
                        child: const Image(
                          image: NetworkImage(
                              'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ad/Flag_of_Portugal_%28alternate%29.svg/1200px-Flag_of_Portugal_%28alternate%29.svg.png'),
                          width: 30,
                          fit: BoxFit.fitWidth,
                        )), */
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
                                items: <String>['Card', 'Cash', 'Wallet']
                                    .map((String value) {
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
