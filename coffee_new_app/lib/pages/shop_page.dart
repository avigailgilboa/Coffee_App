// import 'dart:ffi';

import 'package:coffee_new_app/models/coffee.dart';
import 'package:coffee_new_app/models/coffee_shop.dart';
import 'package:coffee_new_app/pages/coffee_order_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/coffee_tile.dart';

class ShopPage extends StatefulWidget {
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  void goToCoffeepage(Coffee coffee) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CoffeeOrderPage(coffee: coffee),
      ),
    );
  }
  Widget build(BuildContext context) {
    return Consumer<CoffeeShop>(
      builder: (context, value, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 25, top: 25),
            child: Text(
              "How do you like your coffee?",
              style: TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: value.coffeeShop.length,
              itemBuilder: (context, index) {
                Coffee eachCoffee = value.coffeeShop[index];
                return CoffeeTile(
                  coffee: eachCoffee,
                  onPressed:()=> goToCoffeepage(eachCoffee),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
