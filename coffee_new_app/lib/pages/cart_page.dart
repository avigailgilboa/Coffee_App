// import 'package:flutter/material.dart';

// class CartPage extends StatefulWidget {
//   State<CartPage> createState() => _CartPageState();
// }

// class _CartPageState extends State<CartPage> {
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Cart Page"),
//       ),
//     );
//   }
// }

import 'package:coffee_new_app/pages/payment_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coffee_new_app/models/coffee_shop.dart';
import 'package:coffee_new_app/models/coffee.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CoffeeShop>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cart.userCart.length,
                itemBuilder: (context, index) {
                  final item = cart.userCart[index];
                  return Card(
                    child: ListTile(
                      leading:
                          Image.asset(item.imagePath, width: 50, height: 50),
                      title: Text(item.name,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Quantity: ${item.quantity}'),
                          Text(
                              'Total: \$${(item.price * item.quantity).toStringAsFixed(2)}'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          cart.removeFromCart(item);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Quantity: ${cart.totalQuantity}',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'Total Price: \$${cart.totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentPage(
                      onPaymentSuccess: () {
                        // תפקוד להצלחה בתשלום
                        cart.clearCart();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Payment Successful! Cart cleared.'),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
              child: Text(
                'Pay now',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                padding: EdgeInsets.symmetric(vertical: 16),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
