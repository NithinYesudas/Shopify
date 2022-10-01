import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify/packages/product_package.dart';
import 'package:shopify/widgets/favorite_icon.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductProvider>(
      context,
    );
    final products = product.products;
    final mediaquery = MediaQuery.of(context).size;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.of(context)
                .pushNamed('product_details', arguments: products[index].id);
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: .5, color: Colors.grey.shade300),
            ),
            height: mediaquery.height * .5,
            child: Column(
              children: [
                Container(
                  height: mediaquery.height * .18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                  ),
                  child: Hero(
                    tag: products[index].id,
                    child: FadeInImage(
                      placeholder: AssetImage('assets/images/product.png'),
                      image: NetworkImage(products[index].imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 3),
                    height: mediaquery.height * .09,
                    child: GridTileBar(
                      title: Text(
                        products[index].title,
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            fontFamily: 'dmsansbold'),
                      ),
                      trailing: FavoriteIcon(products[index]),
                      subtitle: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          products[index].description,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontFamily: 'dmsansregular',
                          ),
                        ),
                      ),
                    )),
                Row(
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      products[index].price.toString(),
                      style: TextStyle(fontFamily: 'dmsansbold', fontSize: 15),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      '50% off',
                      style: TextStyle(
                          color: Colors.orange[700], fontFamily: 'dmsansbold'),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: .75),
    );
  }
}
