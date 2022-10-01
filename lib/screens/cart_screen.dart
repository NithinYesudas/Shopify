import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify/packages/product_package.dart';
import 'package:shopify/widgets/cart_item.dart';
import 'package:shopify/widgets/cartbottom.dart';

class CartScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    final mediaquery = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('order');
              },
              icon: Icon(Icons.shopping_bag))
        ],
        title: Text(
          'My Cart',
          style: TextStyle(fontFamily: 'dmsansbold'),
        ),
      ),
      body: FutureBuilder(
        future:
            Provider.of<ProductProvider>(context, listen: false).fetchCart(),
        builder: (ctx, data) {
          if (data.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.green[700],
              ),
            );
          } else if (data.error != null) {
            return Center(
              child: Text('An error occured'),
            );
          } else {
            return Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: mediaquery.height * .8215,
                  child: Consumer<ProductProvider>(
                    builder: (ctx, provider, child) {
                      return provider.cart.isEmpty?Center(child: Text("Your cart is currently empty"),):ListView.builder(
                          itemCount: provider.cart.length,
                          itemBuilder: (ctx, index) =>
                              CartItem(provider.cart[index]));
                    },
                  ),
                ),
                CartBottom()
              ],
            );
          }
        },
      ),
    );
  }
}
