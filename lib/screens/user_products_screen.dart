import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify/models/product.dart';
import 'package:shopify/packages/product_package.dart';
import 'package:shopify/widgets/user_product_item.dart';

class UserProducts extends StatefulWidget {
  @override
  _UserProductsState createState() => _UserProductsState();
}

class _UserProductsState extends State<UserProducts> {
  bool isLoading = false;

  Future<void> refresh(BuildContext context) async {
    await Provider.of<ProductProvider>(context, listen: false)
        .fetchUserProducts();
  }

  @override
  void initState() {
    isLoading = true;
    Provider.of<ProductProvider>(context, listen: false)
        .fetchUserProducts()
        .catchError((onError) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('An error Occurred')));
    }).then((value) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final products = provider.userProducts;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('add_product', arguments: {
                'title': 'Add product',
                'product': Product(
                    title: '', description: '', price: 0, imageUrl: '', id: '')
              });
            },
            icon: Icon(Icons.add),
          )
        ],
        backgroundColor: Colors.green[700],
        title: const Text(
          'My Products',
          style: TextStyle(fontFamily: 'dmsansbold'),
        ),
      ),
      body: RefreshIndicator(
        color: Colors.orange[700],
        onRefresh: () async {
          await refresh(context);
        },
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.green[700],
                ),
              )
            : provider.userProducts.isEmpty
                ? Center(
                    child: Text("No Products added yet"),
                  )
                : ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (ctx, index) {
                      return UserProductItem(
                        index: index,
                      );
                    }),
      ),
    );
  }
}
