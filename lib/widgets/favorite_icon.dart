import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:shopify/models/product.dart';
import 'package:shopify/packages/product_package.dart';
class FavoriteIcon extends StatefulWidget {
  final Product loadedProduct;
 FavoriteIcon( this.loadedProduct);

  @override
  _FavoriteIconState createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon> {
  bool isLoading = false;
 Future<void> onTap() async {
   final product = Provider.of<ProductProvider>(context,listen: false);
   isLoading = true;
   await product.favoriteAdder(widget.loadedProduct);
   setState(() {
     isLoading = false;
   });
}
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductProvider>(context);
    return isLoading==true?Center(child: Padding(
      padding: const EdgeInsets.all(10),
      child: CircularProgressIndicator(color: Colors.green[700],),
    ),):IconButton(
      icon: Icon(
        product.favoriteFinder(widget.loadedProduct)?Icons.favorite:Icons.favorite_border_sharp,
        color: Colors.green[700],
      ),
      onPressed: (){
        setState(() {
          onTap();
        });

        });
       }

  }

