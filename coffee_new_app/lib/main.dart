import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:coffee_new_app/pages/login_page.dart';
import 'package:provider/provider.dart';
import 'package:coffee_new_app/models/coffee_shop.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
   runApp(
    ChangeNotifierProvider(
      create: (context) => CoffeeShop(),
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
debugShowCheckedModeBanner: false,
      title: 'Login Demo',
      home: LoginPage(),
    );
  }
}



// import 'package:flutter/material.dart';

// import 'package:coffee_new_app/pages/cart_page.dart';
// import 'package:coffee_new_app/pages/coffee_order_page.dart';
// import 'package:coffee_new_app/models/coffee.dart';

// void main() {
//   runApp(
//     ChangeNotifierProvider(
//       create: (context) => CoffeeShop(),
//       child: MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       home: CoffeeOrderPage(
//         coffee: Coffee(
//           name: "Latte",
//           price: 4.50,
//           imagePath: "lib/images/latte.png",
//         ),
//       ),
//       routes: {
//         '/cart': (context) => CartPage(),
//       },
//     );
//   }
// }

