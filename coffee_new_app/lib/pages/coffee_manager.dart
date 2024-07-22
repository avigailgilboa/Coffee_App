
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coffee_new_app/models/coffee_shop.dart';
import 'package:coffee_new_app/models/coffee.dart';

class ManageProductsPage extends StatefulWidget {
  @override
  _ManageProductsPageState createState() => _ManageProductsPageState();
}

class _ManageProductsPageState extends State<ManageProductsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  void _addProduct() {
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _imageController.text.isEmpty) {
      return;
    }

    final newProduct = Coffee(
      name: _nameController.text,
      price: double.tryParse(_priceController.text) ?? 0,
      imagePath: _imageController.text,
    );

    Provider.of<CoffeeShop>(context, listen: false).addProduct(newProduct);

    _nameController.clear();
    _priceController.clear();
    _imageController.clear();
  }

  void _removeProduct(Coffee product) {
    Provider.of<CoffeeShop>(context, listen: false).removeProduct(product);
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<CoffeeShop>(context).coffeeShop;

    return Scaffold(
      appBar: AppBar(
        title: Text("ניהול מוצרים"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "שם מוצר"),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: "מחיר מוצר"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _imageController,
              decoration: InputDecoration(labelText: "נתיב תמונה"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addProduct,
              child: Text("הוסף מוצר"),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    child: ListTile(
                      leading: Image.asset(product.imagePath, height: 50, width: 50),
                      title: Text(product.name),
                      subtitle: Text("\$${product.price}"),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeProduct(product),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
