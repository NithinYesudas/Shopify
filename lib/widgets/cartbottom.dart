import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify/packages/order_package.dart';
import 'package:shopify/packages/product_package.dart';

class CartBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<ProductProvider>(context);
    final cart = provider.cart;
    final mediaquery = MediaQuery.of(context).size;
    print("cart: " + cart.toString());
    return Container(
      height: mediaquery.height * .07,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          blurRadius: 2,
          spreadRadius: .8,
          color: Colors.black38,
        )
      ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
              child: Row(
            children: [
              Text(
                'Cart Total: ',
                style: TextStyle(
                    fontFamily: 'dmsansregular',
                    fontSize: mediaquery.height * .023),
              ),
              Text(
                '\$' + provider.totalSum.toStringAsFixed(2),
                style: TextStyle(
                    fontFamily: 'dmsansregular',
                    color: Colors.orange[700],
                    fontSize: mediaquery.height * .025),
              )
            ],
          )),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.orange[700])),
            onPressed: () async{
              await Provider.of<OrderPackage>(context,listen: false).orderPlaced(cart, provider.totalSum);
              provider.clearCart();
              print('cart: '+ cart.toString());
              Navigator.of(context).pushNamed('order');

            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: mediaquery.width * .03),
              child: Text(
                'Place Order',
                style: TextStyle(
                    fontFamily: 'dmsansregular',
                    fontSize: mediaquery.height * .024),
              ),
            ),
          )
        ],
      ),
    );
  }
}
