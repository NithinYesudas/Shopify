import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify/packages/order_package.dart';
import 'package:shopify/widgets/appDrawer.dart';
import 'package:shopify/widgets/order_item.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({Key? key}) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {

  bool isInit = true;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    if (isInit) {
      isLoading = true;
      Provider.of<OrderPackage>(context, listen: false).fetchOrders().then((
          value) {
        setState(() {
          isLoading = false;
        });
      });
    }


    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final package = Provider.of<OrderPackage>(context, listen: false);
    final orders = package.orderItems;
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.green[700],
          title: Text(
            'Your Orders',
            style: TextStyle(fontFamily: 'dmsansbold'),
          ),
        ),
        body: isLoading == true
            ? Center(child: CircularProgressIndicator(),)
            : orders.isEmpty ? Center(child: Text('No Orders Yet'),):ListView
            .builder(
          itemBuilder: (_, index) => OrderItem(orders[index], index),
          itemCount: orders.length,
        ));
  }
}
