import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopify/packages/order_package.dart';

class OrderItem extends StatefulWidget {
  final Order order;
  final int index;

  OrderItem(this.order, this.index);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context).size;
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInToLinear,
      height: isExpanded?min(
          (widget.order.products.length * mediaquery.height * .14)+mediaquery.height*.125
          ,
          (mediaquery.height * 5)+mediaquery.height*.15):mediaquery.height*.125,
      child: Card(
          margin: EdgeInsets.all(10),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              ListTile(
                title: Text(
                  'Total Amount: \$ ${widget.order.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontFamily: 'dmsansbold',
                    fontSize: mediaquery.height * .023,
                  ),
                ),
                subtitle: Text(
                  DateFormat.MEd().format(widget.order.time),
                  style: TextStyle(fontFamily: 'dmsansregular'),
                ),
                trailing: IconButton(
                  icon: Icon(isExpanded
                      ? Icons.expand_less_rounded
                      : Icons.expand_more_outlined),
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                ),
              ),

                Expanded(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeInToLinear,



                    height: isExpanded?min(
                        widget.order.products.length * mediaquery.height * .14,
                        mediaquery.height * 5):0,

                    child: ListView(
                      children: [
                        ...widget.order.products.map((product) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed('product_details',
                                  arguments: product.id.toString());
                            },
                            child: Container(
                              color: Colors.white,
                              height: mediaquery.height * .14,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: mediaquery.height * .125,
                                        width: mediaquery.width * .3,
                                        margin: EdgeInsets.only(left: 5),
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                fit: BoxFit.fitHeight,
                                                image:
                                                    NetworkImage(product.imageUrl))),
                                      ),
                                      SizedBox(
                                        height: mediaquery.height * .125,
                                        width: mediaquery.width * .63,
                                        child: ListTile(
                                          title: Text(product.title,
                                              style: TextStyle(
                                                  fontFamily: 'dmsansbold',
                                                  fontSize:
                                                      mediaquery.height * .023)),
                                          subtitle: Text('Qty: ${product.quantity}',
                                              style: TextStyle(
                                                  fontFamily: 'dmsansregular')),
                                          trailing: Text(
                                              '\$ ${(product.quantity * product.price).toStringAsFixed(2)}',
                                              style: TextStyle(
                                                  fontFamily: 'dmsansbold',
                                                  fontSize: mediaquery.height * .023,
                                                  color: Colors.orange[700])),
                                        ),
                                      )
                                    ],
                                  ),
                                  const Divider(
                                    height: 4,
                                  )
                                ],
                              ),
                            ),
                          );
                        }).toList()
                      ],
                    ),
                  ),
                )
            ],
          ),
        ),
    );
  }
}
