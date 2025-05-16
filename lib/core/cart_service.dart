class CartService {
  List<Map<String, dynamic>> items = [];
  int totalItems = 0;
  double totalPrice = 0.00;

  CartService();

  updateCart() {
    totalItems = items.length;
    totalPrice = 0;
    for (var element in items) {
      totalPrice += element['itemTotal'];
    }
  }

  bool addItem(Map<String, dynamic> item) {
    if (!item.containsKey('id')) return false;
    final exists = items.indexWhere((element) => element['id'] == item['id']);
    if (exists < 0) {
      final newItem = {
        'id': item['id'],
        'quantity': 1,
        'item': item,
        'price': item['price'],
        'itemTotal': item['price']
      };
      items.add(newItem);
    } else {
      int newQty = items[exists]['quantity'] + 1;
      int price = items[exists]['price'];
      int newPrice = newQty * price;
      items[exists]['quantity'] = newQty;
      items[exists]['itemTotal'] = newPrice;
    }
    updateCart();
    return true;
  }

  bool updateQuantity(Map<String, dynamic> item, int qty) {
    if (!item.containsKey('id')) return false;
    final exists = items.indexWhere((element) => element['id'] == item['id']);
    if (exists < 0 || items[exists]['quantity'] < 1) return false;
    if (items[exists]['quantity'] == 1) {
      items.removeAt(exists);
    } else {
      int newQty = items[exists]['quantity'] + qty;
      double price = double.tryParse('${items[exists]['price']}') ?? 0.0;
      double newPrice = newQty * price;
      items[exists]['quantity'] = newQty;
      items[exists]['itemTotal'] = newPrice;
    }
    updateCart();
    return true;
  }

  Map<String, dynamic> getItem(id) {
    final product = items.indexWhere((item) => item['id'] == id);
    return product >= 0 ? items[product] : {};
  }

  void resetCart() {
    items = [];
    totalItems = 0;
    totalPrice = 0.00;
  }
}
