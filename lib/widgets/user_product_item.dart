import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify/packages/product_package.dart';

class UserProductItem extends StatelessWidget {
  final int index;

  UserProductItem({required this.index});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final products = provider.userProducts;
    final mediaquery = MediaQuery.of(context).size;
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        title: Text(products[index].title,
            style: TextStyle(
                fontFamily: 'dmsansbold', fontSize: mediaquery.height * .025)),
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          radius: mediaquery.height * .075,
          child: Image.network(
            products[index].imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        trailing: DropdownButtonHideUnderline(
          child: DropdownButton(
            onChanged: (int? value) {
              if (value == 2) {
                provider.removeProduct(products[index]);
              }
              else if(value==1){
                Navigator.of(context).pushNamed('add_product', arguments: {'title': 'Edit Product','product': products[index]});
              }
            },
            items: [
              DropdownMenuItem(
                child: Text(
                  'Edit',
                  style: TextStyle(fontFamily: 'dmsansregular'),
                ),
                value: 1,
              ),
              DropdownMenuItem(
                child: Text('Delete',
                    style: TextStyle(fontFamily: 'dmsansregular')),
                value: 2,
              ),
            ],
            icon: Icon(
              Icons.more_vert_outlined,
            ),
          ),
        ),
        subtitle: Text(products[index].description,
            style: TextStyle(fontFamily: 'dmsansregular')),
      ),
    );
  }
}
