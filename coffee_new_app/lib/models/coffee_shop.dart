import 'package:flutter/material.dart';
import 'package:coffee_new_app/models/coffee.dart';

class CoffeeShop extends ChangeNotifier {
  final List<Coffee> _shop = [
    Coffee(
      name: "Long Black",
      price: 4.50,
      imagePath: "lib/images/black.png",
    ),
    Coffee(
      name: "Latte",
      price: 4.50,
      imagePath: "lib/images/latte.png",
    ),
    Coffee(
      name: "Espresso",
      price: 6.50,
      imagePath: "lib/images/espresso.png",
    ),
    Coffee(
      name: "Iced Coffee",
      price: 5.50,
      imagePath: "lib/images/iced_coffee.png",
    ),
  ];

  List<Coffee> get coffeeShop => _shop;

  List<Coffee> _userCart = [];

  List<Coffee> get userCart => _userCart;

  void addProduct(Coffee coffee) {
    _shop.add(coffee);
    notifyListeners();
  }

  void removeProduct(Coffee coffee) {
    _shop.remove(coffee);
    notifyListeners();
  }

  void addItemToCart(Coffee coffee, int quantity) {
    Coffee existingCoffee = _userCart.firstWhere(
      (item) => item.name == coffee.name,
      orElse: () => Coffee(
        name: coffee.name,
        price: coffee.price,
        imagePath: coffee.imagePath,
        quantity: 0,
      ),
    );

    if (!_userCart.contains(existingCoffee)) {
      _userCart.add(existingCoffee);
    }
    existingCoffee.quantity += quantity;
    notifyListeners();
  }

  void removeFromCart(Coffee coffee) {
    _userCart.remove(coffee);
    notifyListeners();
  }

  void clearCart() {
    _userCart.clear();
    notifyListeners();
  }

  int get totalQuantity =>
      _userCart.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      _userCart.fold(0, (sum, item) => sum + (item.price * item.quantity));
}
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:coffee_new_app/models/coffee.dart';

// class CoffeeShop extends ChangeNotifier {
//   final List<Coffee> _shop = [];
//   final List<Coffee> _userCart = [];
//   final CollectionReference _productsCollection =
//       FirebaseFirestore.instance.collection('products');

//   CoffeeShop() {
//     _fetchProducts();
//   }

//   List<Coffee> get coffeeShop => _shop;
//   List<Coffee> get userCart => _userCart;

//   void _fetchProducts() {
//     _productsCollection.snapshots().listen((snapshot) {
//       _shop.clear();
//       snapshot.docs.forEach((doc) {
//         final data = doc.data() as Map<String, dynamic>;
//         _shop.add(Coffee(
//           name: data['name'],
//           price: data['price'],
//           imagePath: data['imagePath'],
//         ));
//       });
//       notifyListeners();
//     });
//   }

//   Future<void> addProduct(Coffee coffee) async {
//     await _productsCollection.add({
//       'name': coffee.name,
//       'price': coffee.price,
//       'imagePath': coffee.imagePath,
//     });
//   }

//   Future<void> removeProduct(Coffee coffee) async {
//     final snapshot = await _productsCollection
//         .where('name', isEqualTo: coffee.name)
//         .get();
//     for (var doc in snapshot.docs) {
//       await doc.reference.delete();
//     }
//   }

//   void addItemToCart(Coffee coffee, int quantity) {
//     Coffee existingCoffee = _userCart.firstWhere(
//       (item) => item.name == coffee.name,
//       orElse: () => Coffee(
//         name: coffee.name,
//         price: coffee.price,
//         imagePath: coffee.imagePath,
//         quantity: 0,
//       ),
//     );

//     if (!_userCart.contains(existingCoffee)) {
//       _userCart.add(existingCoffee);
//     }
//     existingCoffee.quantity += quantity;
//     notifyListeners();
//   }

//   void removeFromCart(Coffee coffee) {
//     _userCart.remove(coffee);
//     notifyListeners();
//   }

//   void clearCart() {
//     _userCart.clear();
//     notifyListeners();
//   }

//   int get totalQuantity =>
//       _userCart.fold(0, (sum, item) => sum + item.quantity);

//   double get totalPrice =>
//       _userCart.fold(0, (sum, item) => sum + (item.price * item.quantity));
// }
