import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify/helpers/custom_route.dart';
import 'package:shopify/packages/product_package.dart';
import 'package:shopify/screens/cart_screen.dart';
import 'package:shopify/widgets/appDrawer.dart';
import 'package:shopify/widgets/badge.dart';

import 'package:shopify/widgets/product_item.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isInit = true;
  bool isLoading = false;

  @override
  void didChangeDependencies() {


    if (isInit) {
      isLoading = true;
      Provider.of<ProductProvider>(context,listen: false).fetchCart();
      Provider.of<ProductProvider>(context,listen: false).fetchFavorite();
      Provider.of<ProductProvider>(context, listen: false)
          .fetchData()
          .catchError((error) {
            print('Home page error');
            print(error);
        return showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('An error occurred while fetching data..!'),
                content: Text('Something went wrong'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Ok'))
                ],
              );
            });
      }).then((value) => setState(() {
                isLoading = false;
              }));
    }

    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print('home page build running');
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        actions: [
          Consumer<ProductProvider>(
            builder: (ctx, provider, child) => Badge(
                child: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(CustomRoute(builder: (ct)=>CartScreen()));
                    },
                    icon: Icon(Icons.shopping_cart)),
                value: provider.cart.length),
          ),
          PopupMenuButton(
              onSelected: ( selectednumber) {
                if (selectednumber == 1) {
                  Navigator.of(context).pushNamed('cart');
                }
                else{
                  Navigator.of(context).pushNamed('favorite_screen');
                }
              },
              itemBuilder: (_) => [
                    PopupMenuItem(value: 0, child: Text('My Wishlist')),
                    PopupMenuItem(value: 1, child: Text('My Cart'))
                  ])
        ],
        backgroundColor: Colors.green,
        title: Text(
          'Shopify',
          style: TextStyle(fontFamily: 'dmsansbold'),
        ),
      ),
      body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                  color: Colors.green[700],
                ))
               :

         ProductItem()));

  }
}
