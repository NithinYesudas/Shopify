import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify/models/product.dart';
import 'package:shopify/packages/order_package.dart';
import 'package:shopify/packages/product_package.dart';

class CartButtons extends StatefulWidget {
  final Product product;

  CartButtons(this.product);

  @override
  _CartButtonsState createState() => _CartButtonsState();
}

class _CartButtonsState extends State<CartButtons> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderPackage>(context, listen: false);
    final provider = Provider.of<ProductProvider>(context, listen: false);
    final products = provider.cart;
    final mediaquery = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (ctx) {
                    return AlertDialog(
                      title: Text('Are you sure.?',
                          style: TextStyle(fontFamily: 'dmsansbold')),
                      content: Text('Do you really want to remove this item..?',
                          style: TextStyle(fontFamily: 'dmsanslight')),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'No',
                              style: TextStyle(
                                  fontFamily: 'dmsansbold',
                                  color: Colors.orange[700]),
                            )),
                        TextButton(
                            onPressed: ()  {
                               provider.cartRemover(widget.product);
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Yes',
                              style: TextStyle(
                                  fontFamily: 'dmsansbold',
                                  color: Colors.green[700]),
                            ))
                      ],
                    );
                  });
            },
            child: Padding(
              padding: EdgeInsets.only(right: mediaquery.width * .02),
              child: Text(
                'Remove',
                style: TextStyle(
                    fontFamily: 'dmsansregular',
                    fontSize: mediaquery.height * .022,
                    color: Colors.orange[700]),
              ),
            )),
        isLoading?Center(child: CircularProgressIndicator(),): ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.orange[700])),
          onPressed: () async{
            setState(() {
              isLoading = true;
            });

            await orderProvider.orderPlaced(
              [widget.product],
              widget.product.price * widget.product.quantity,
            );
            setState(() {
              isLoading = false;
            });

            Navigator.of(context).pushNamed('order');
            provider.cartRemover(widget.product);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mediaquery.width * .02),
            child: Text(
              'Buy Now',
              style: TextStyle(
                  fontFamily: 'dmsansregular',
                  fontSize: mediaquery.height * .022),
            ),
          ),
        )
      ],
    );
  }
}
