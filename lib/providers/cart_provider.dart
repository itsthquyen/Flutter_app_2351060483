import '../models/product_model.dart';

class CartItem {
  ProductModel product;
  int quantity;

  CartItem(this.product, this.quantity);
}

class CartProvider {
  static final List<CartItem> _items = [];

  static List<CartItem> get items => _items;

  static void add(ProductModel product) {
    final index = _items.indexWhere((e) => e.product.id == product.id);
    if (index == -1) {
      _items.add(CartItem(product, 1));
    } else {
      _items[index].quantity++;
    }
  }

  static void increase(int index) {
    _items[index].quantity++;
  }

  static void decrease(int index) {
    if (_items[index].quantity > 1) {
      _items[index].quantity--;
    }
  }

  static double get total {
    return _items.fold(
        0, (sum, e) => sum + e.product.price * e.quantity);
  }

  static void clear() {
    _items.clear();
  }
}
