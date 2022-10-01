import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify/helpers/custom_route.dart';
import 'package:shopify/packages/auth_package.dart';
import 'package:shopify/packages/order_package.dart';
import 'package:shopify/packages/product_package.dart';
import 'package:shopify/screens/auth_screen.dart';
import 'package:shopify/screens/cart_screen.dart';
import 'package:shopify/screens/edit_product_screen.dart';
import 'package:shopify/screens/homePage.dart';
import 'package:shopify/screens/order_details_screen.dart';
import 'package:shopify/screens/product_detail_screen.dart';
import 'package:shopify/screens/splash_screen.dart';
import 'package:shopify/screens/user_products_screen.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthPackage()),
      ChangeNotifierProxyProvider<AuthPackage, ProductProvider>(
        update: (ctx, authData, previousData) => ProductProvider(
            authData.token,
            authData.userId,
            previousData!.products,
            previousData.favorites,
            previousData.cart),
        create: (context) {
          return ProductProvider('a', '', [], [], []);
        },
      ),
      ChangeNotifierProxyProvider<AuthPackage, OrderPackage>(
          update: (ctx, authData, previousData) => OrderPackage(
              authData.token, authData.userId, previousData!.orderItems),
          create: (_) => OrderPackage('', '', []))
    ],
    child: Consumer<AuthPackage>(
        builder: (ctx, data, child) => MaterialApp(
          theme: ThemeData(pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: CustomPageTransition()
          }
          )),
              debugShowCheckedModeBanner: false,
              home: data.isAuth
                  ? HomePage()
                  : FutureBuilder(
                      future: data.tryAutoLogin(),
                      builder: (ctx, auth) =>
                          auth.connectionState == ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen()),
              routes: {
                'home': (ctx) => HomePage(),
                'product_details': (ctx) => ProductDetailScreen(),
                'cart': (ctx) => CartScreen(),
                'order': (ctx) => OrderDetails(),
                'user_products': (ctx) => UserProducts(),
                'add_product': (ctx) => EditProduct(),
              },
            )),
  ));
}
