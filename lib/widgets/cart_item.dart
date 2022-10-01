import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify/models/product.dart';
import 'package:shopify/packages/product_package.dart';

import 'cart_buttons.dart';
class CartItem extends StatelessWidget {
  final Product products;

  CartItem(this.products);

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context).size;
    final provider = Provider.of<ProductProvider>(context);
    //final products = provider.cart;

    return Container(
      margin: EdgeInsets.all(5),
      width: double.infinity,
      height: mediaquery.height * .3,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        child: Dismissible(
          confirmDismiss: (direction){
            return
                showDialog(context: context, builder: (ctx){
                  return
                      AlertDialog(
                        title: Text('Are you sure ?',style: TextStyle(fontFamily: 'dmsansbold')),
                        content: Text('Do you really want to remove this item',style: TextStyle(fontFamily: 'dmsanslight')),
                        actions: [
                          TextButton(onPressed: (){Navigator.of(context).pop(false);}, child: Text('No',style: TextStyle(fontFamily: 'dmsansbold',color: Colors.orange[700]),)),
                          TextButton(onPressed: (){Navigator.of(context).pop(true);}, child: Text('Yes',style: TextStyle(fontFamily: 'dmsansbold',color: Colors.green[700]),))
                        ],
                      );
                });
          },
          direction: DismissDirection.endToStart,
          onDismissed: (dismissDirection) {


              provider.cartRemover(products);

            print(provider.favorites);
          },
          key: ValueKey(products.id),
          background: Container(
            padding: EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
                color: Colors.red[600],
                borderRadius: BorderRadius.circular(10)),
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: mediaquery.width * .3,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            products.imageUrl))),
              ),
              VerticalDivider(),
              Container(
                padding: EdgeInsets.all(10),
                width: (mediaquery.width * .7) - 34,
                height: mediaquery.height * .3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      products.title,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontFamily: 'dmsansbold',
                          fontSize: mediaquery.height * .025),
                    ),
                    SizedBox(
                      height: mediaquery.height * .008,
                    ),
                    Text(
                      products.description,
                      style: TextStyle(
                        fontFamily: 'dmsansregular',
                      ),
                    ),
                    SizedBox(
                      height: mediaquery.height * .01,
                    ),
                    Row(
                      children: [
                        Text(
                          '\$ ' +
                              products.price.toString(),
                          style: TextStyle(
                            fontFamily: 'dmsansbold',
                            fontSize: MediaQuery.of(context)
                                .size
                                .height *
                                .027,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '50% off',
                          style: TextStyle(
                              color: Colors.orange[700],
                              fontFamily: 'dmsansregular'),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: mediaquery.height * .005,
                    ),
                    Text(
                      'Free delivery',
                      style: TextStyle(
                          color: Colors.green[700],
                          fontFamily: 'dmsansregular'),
                    ),
                    SizedBox(
                      height: mediaquery.height * .01,
                    ),
                    Container(
                      height: mediaquery.height * .04,
                      child: Row(
                        children: [
                          Text(
                            'Quantity: ',
                            style: TextStyle(
                                fontFamily: 'dmsansregular',
                                fontSize:
                                mediaquery.height * .022),
                          ),
                          Text(
                            products.quantity.toString(),
                            style: TextStyle(
                                fontFamily: 'dmsansregular',
                                fontSize:
                                mediaquery.height * .022),
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton(
                              onChanged: (int? value) {
                                provider.quantitySelecter(
                                    value!, products);
                              },
                              items: [
                                DropdownMenuItem(
                                  child: Text('1'),
                                  value: 1,
                                ),
                                DropdownMenuItem(
                                  child: Text('2'),
                                  value: 2,
                                ),
                                DropdownMenuItem(
                                  child: Text('3'),
                                  value: 3,
                                ),
                              ],
                              icon: Icon(Icons
                                  .arrow_drop_down_circle_outlined),
                            ),
                          )
                        ],
                      ),
                    ),
                    CartButtons(products)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
