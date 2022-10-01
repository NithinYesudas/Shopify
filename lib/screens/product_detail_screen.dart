import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify/packages/order_package.dart';
import 'package:shopify/packages/product_package.dart';
import 'package:shopify/widgets/favorite_icon.dart';

class ProductDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as String;
    final product = Provider.of<ProductProvider>(context, listen: false);
    final loadedProduct = product.findbyId(id);
    final mediaquery = MediaQuery.of(context).size;
    final orderProvider = Provider.of<OrderPackage>(context, listen: false);

    TextStyle titleStyle = TextStyle(
        fontFamily: 'dmsansbold',
        fontSize: MediaQuery.of(context).size.height * .027);
    TextStyle subStyle =
        TextStyle(fontFamily: 'dmsansregular', color: Colors.black87);
    const divider = Divider(thickness: 6);

    return Scaffold(
        body: SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: SizedBox(),
            backgroundColor: Colors.green[700],
            expandedHeight: mediaquery.height * .6,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(

              background: Container(
                  height: mediaquery.height * .6,
                  child: Stack(
                    children: [
                      Container(
                        height: mediaquery.height * .6,
                        child: Hero(
                          tag: loadedProduct.id,
                          child: Image.network(
                            loadedProduct.imageUrl,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Align(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.grey[300],
                                child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: Colors.grey[700],
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                              CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.grey[300],
                                  child: FavoriteIcon(loadedProduct)),
                            ],
                          ),
                          alignment: Alignment.topLeft,
                        ),
                      ),
                    ],
                  )),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: mediaquery.height * .07,
                width: mediaquery.width,
                child: ListTile(
                  title: Text(
                    loadedProduct.title,
                    style: titleStyle,
                  ),
                  subtitle: Text(
                    loadedProduct.description,
                    style: subStyle,
                  ),
                ),
              ),
              // Divider(height: 0,),
              SizedBox(
                height: mediaquery.height * .09,
                child: ListTile(
                  title: Row(
                    children: [
                      Text(
                        '\$ ' + loadedProduct.price.toString(),
                        style: TextStyle(
                          fontFamily: 'dmsansbold',
                          fontSize: MediaQuery.of(context).size.height * .027,
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
                  subtitle: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      'Inclusive of taxes',
                      style: TextStyle(
                          color: Colors.green[700],
                          fontFamily: 'dmsansregular'),
                    ),
                  ),
                ),
              ),
              divider,

              ListTile(
                title: Text(
                  'Easy 30 days returns and exchanges',
                  style: const TextStyle(fontFamily: 'dmsansbold'),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'Choose to return or exchange within 30 days, if there is an issue with the product',
                    style: const TextStyle(
                        fontFamily: 'dmsanslight', color: Colors.black87),
                  ),
                ),
              ),
              divider,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      onPressed: () {
                        product.cartAdder(loadedProduct);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: Duration(seconds: 2),
                            backgroundColor: Colors.black87,
                            action: SnackBarAction(
                              label: 'Undo',
                              textColor: Colors.orange[700],
                              onPressed: () {
                                product.cartRemover(loadedProduct);
                              },
                            ),
                            content: Text(
                              'Added to cart..!',
                              style: TextStyle(fontFamily: 'dmsansregular'),
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: mediaquery.width * .05),
                        child: Text(
                          'Add to Cart',
                          style: TextStyle(
                              fontFamily: 'dmsansbold',
                              fontSize: mediaquery.height * .022,
                              color: Colors.orange[700]),
                        ),
                      )),
                  // SizedBox(
                  //   width: mediaquery.width * .007,
                  // ),
                  ElevatedButton(
                    onPressed: () {
                      orderProvider.orderPlaced([loadedProduct],
                          loadedProduct.price * loadedProduct.quantity);
                      Navigator.of(context).pushNamed('order');
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.orange[700])),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: mediaquery.width * .1),
                      child: Text(
                        'Buy now',
                        style: TextStyle(
                            fontFamily: 'dmsansbold',
                            fontSize: mediaquery.height * .025),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: mediaquery.height*.8,)
            ]),
          ),

        ],
      ),
    ));
  }
}
