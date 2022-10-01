import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify/packages/auth_package.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context).size;
    final textStyle =
        TextStyle(fontFamily: 'dmsansbold', fontSize: mediaquery.height * .023);
    Widget listTile(String text, IconData icon, String route) {
      return SizedBox(
        height: mediaquery.height * .06,
        child: ListTile(
          onTap: () {
            Navigator.of(context).pushNamed(route);
          },
          title: Text(
            text,
            style: textStyle,
          ),
          leading: Icon(
            icon,
            color: Colors.black87,
          ),
        ),
      );
    }

    return Drawer(
      child: Column(
        children: [
          Container(
            height: mediaquery.height * .3,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        'https://thumbs.dreamstime.com/b/rustic-welcome-sign-red-flower-hanging-distressed-antique-green-door-weathered-rose-bud-teal-blue-wooden-fence-43915475.jpg'))),
          ),
          listTile('Home', Icons.home_outlined, 'home'),
          listTile('My Wishlist', Icons.favorite_border_outlined, 'cart'),
          listTile('My cart', Icons.shopping_cart_outlined, 'cart'),
          listTile('My Orders', Icons.shopping_bag_outlined, 'order'),
          listTile("Manage Products", Icons.mode_edit_outline_outlined,
              'user_products'),
          SizedBox(
            height: mediaquery.height * .06,
            child: ListTile(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                Provider.of<AuthPackage>(context, listen: false).logOut();
              },
              title: Text(
                "Logout",
                style: textStyle,
              ),
              leading: Icon(
                Icons.logout_outlined,
                color: Colors.black87,
              ),
            ),
          )
        ],
      ),
    );
  }
}
