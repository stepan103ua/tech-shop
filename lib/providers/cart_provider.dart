import 'package:flutter/cupertino.dart';
import 'package:tech_shop/models/cart.dart';

class CartProvider with ChangeNotifier {
  Map<String, Cart> _cartItems = {};

  Map<String, Cart> get cartItems => {..._cartItems};

  int get itemCount {
    var totalItemsCount = 0;
    cartItems.forEach((key, value) => totalItemsCount += value.count);
    return totalItemsCount;
  }

  double get totalAmount {
    var total = 0.0;
    _cartItems.forEach(
        (key, value) => total += value.pricePerProduct * (value.count));
    return total;
  }

  double totalProductTypePrice(String id) {
    if (!_cartItems.containsKey(id) || _cartItems[id] == null) return 0;
    var cartItem = _cartItems[id]!;
    return cartItem.pricePerProduct * cartItem.count;
  }

  void addItem(String id, String title, String imageUrl, double price) {
    if (_cartItems.containsKey(id)) {
      _cartItems[id]!.count++;
    } else {
      var newCartItem = Cart(
          id: DateTime.now().toUtc().toString(),
          title: title,
          imageUrl: imageUrl,
          pricePerProduct: price);
      _cartItems.putIfAbsent(id, () => newCartItem);
    }
    notifyListeners();
  }

  void removeItem(String itemId) {
    _cartItems.remove(itemId);
    notifyListeners();
  }

  void decreaseItemCount(String itemId) {
    if (!_cartItems.containsKey(itemId)) return;
    _cartItems[itemId]!.count--;
    if (_cartItems[itemId]!.count <= 0) _cartItems.remove(itemId);
    notifyListeners();
  }

  void increaseItemCount(String itemId) {
    if (!_cartItems.containsKey(itemId)) return;
    _cartItems[itemId]!.count++;
    notifyListeners();
  }

  void clear() {
    _cartItems.clear();
    notifyListeners();
  }
}
