import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopify/models/product.dart';

class ProductProvider with ChangeNotifier {
  var token;
  var userId;

  ProductProvider(
      this.token, this.userId, this._products, this._favorites, this._cart);

  List<Product> _products = [];
  List<Product> _userProducts = [];

  List<Product> get userProducts {
    return [..._userProducts];
  }

  List<Product> get products {
    return [..._products];
  }

  List<Product> _favorites = [];

  List<Product> get favorites {
    return [..._favorites];
  }

  Product findbyId(String id) {
    return products.firstWhere((element) => id == element.id);
  }

  Future<void> fetchData() async {
    final url = Uri.parse(
        'https://shopify-d974d-default-rtdb.firebaseio.com/product.json?auth=$token');
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    final List<Product> loadedProducts = [];
    extractedData.forEach((prodId, prodData) {

      loadedProducts.add(Product(
        id: prodId,
        userId: prodData['userId'],
        title: prodData['title'],
        description: prodData['description'],
        price: prodData['price'],
        isFavorite: prodData['isFavorite'],
        imageUrl: prodData['imageUrl'],
      ));
    });
    _products = loadedProducts;
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    var url = Uri.parse(
        'https://shopify-d974d-default-rtdb.firebaseio.com/product/.json?auth=$token');
    final value = await http.post(url,
        body: json.encode({
          'title': product.title,
          'id': product.id,
          'userId': userId,
          'description': product.description,
          'price': product.price,
          'quantity': product.quantity,
          'imageUrl': product.imageUrl,
        }));

    final newProduct = Product(
      title: product.title,
      id: json.decode(value.body)['name'],
      description: product.description,
      imageUrl: product.imageUrl,
      price: product.price,
    );
    _userProducts.add(newProduct);
    _products.add(newProduct);
    notifyListeners();
  }

  Future<void> updateProduct(Product oldProduct, Product newProduct) async {
    var index = _products.indexWhere((element) => oldProduct.id == element.id);
    final url = Uri.parse(
        'https://shopify-d974d-default-rtdb.firebaseio.com/product/${oldProduct.id}.json?auth=$token');
    await http.patch(url,
        body: json.encode({
          'title': newProduct.title,
          'id': newProduct.id,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
          'price': newProduct.price
        }));
    _products[index] = newProduct;
    if (_favorites.contains(oldProduct)) {
      _favorites.remove(oldProduct);
      _favorites.add(newProduct);
      print(_favorites.toString());
    }
    if (_cart.contains(oldProduct)) {
      _cart.remove(oldProduct);
      _cart.add(newProduct);
      print("cart: " + _cart.toString());
    }
    notifyListeners();
    return Future.value();
  }

  Future<void> removeProduct(Product product) async {

    var urls = Uri.parse(
        'https://shopify-d974d-default-rtdb.firebaseio.com/product/${product.id}.json?auth=$token');
    await http.delete(urls);
    _products.removeWhere((element) {
      return element.id == product.id;
    });
    _userProducts.removeWhere((element) {
      return element.id == product.id;
    });

    notifyListeners();
  }

  Future<void> fetchFavorite() async {
    List<Product> tempList = [];
    final url = Uri.parse(
        'https://shopify-d974d-default-rtdb.firebaseio.com/users/$userId/favorites.json?auth=$token');
    final response = await http.get(url);
    if (json.decode(response.body) == null) return;
    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    extractedData.forEach((key, value) {
      var newProduct = Product(
          title: value['title'],
          id: value['id'],
          description: value['description'],
          imageUrl: value['imageUrl'],
          favId: key,
          price: value['price']);

      tempList.add(newProduct);
    });
    _favorites = tempList;
    notifyListeners();
  }

  bool favoriteFinder(Product product) {
    if (_favorites.any((element) => element.id == product.id)) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> favRemover(Product product) async {
    final url = Uri.parse(
        'https://shopify-d974d-default-rtdb.firebaseio.com/users/$userId/favorites/${product.favId}.json?auth=$token');
    await http.delete(url);
    _favorites.remove(product);

    notifyListeners();
  }

  var favId;

  Future<void> favoriteAdder(Product product) async {
    if (_favorites.any((element) => element.id == product.id)) {
      final url = Uri.parse(
          'https://shopify-d974d-default-rtdb.firebaseio.com/users/$userId/favorites/${product.favId}.json?auth=$token');
      await http.delete(url);
      _favorites.removeWhere((element) => element.id == product.id);
    } else {
      final url = Uri.parse(
          'https://shopify-d974d-default-rtdb.firebaseio.com/users/$userId/favorites.json?auth=$token');

      await http.post(url,
          body: json.encode({
            'title': product.title,
            'id': product.id,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'favId': product.favId,
            'price': product.price
          }));
      _favorites.add(product);
    }
    notifyListeners();
  }

  List<Product> _cart = [];

  List<Product> get cart {
    return [..._cart];
  }

  double get totalSum {
    double sum = 0;
    for (int i = 0; i < _cart.length; i++) {
      sum = sum + _cart[i].price * _cart[i].quantity;
    }

    return sum;
  }

  var cartResponse;

  Future<void> cartAdder(Product product) async {
    if (!_cart.contains(product)) {
      final url = Uri.parse(
          'https://shopify-d974d-default-rtdb.firebaseio.com/users/$userId/cart.json?auth=$token');
      cartResponse = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'id': product.id,
            'price': product.price,
            'quantity': product.quantity
          }));

      _cart.add(product);
    }

    notifyListeners();
  }

  Future<void> fetchCart() async {
    List<Product> tempCart = [];
    final url = Uri.parse(
        'https://shopify-d974d-default-rtdb.firebaseio.com/users/$userId/cart.json?auth=$token');
    var response = await http.get(url);
    if (json.decode(response.body) == null) {
      return;
    }
    var extractedCart = json.decode(response.body) as Map<String, dynamic>;
    extractedCart.forEach((key, value) {
      var newProduct = Product(
          title: value['title'],
          id: value['id'],
          cartId: key,
          description: value['description'],
          imageUrl: value['imageUrl'],
          price: value['price']);
      tempCart.add(newProduct);
    });
    _cart = tempCart;
  }

  Future<void> cartRemover(Product product) async {
    final url = Uri.parse(
        'https://shopify-d974d-default-rtdb.firebaseio.com/users/$userId/cart/${product.cartId}.json?auth=$token');
    await http.delete(url);
    _cart.remove(product);

    notifyListeners();
  }

  Future<void> clearCart() async {
    final url = Uri.parse(
        'https://shopify-d974d-default-rtdb.firebaseio.com/users/$userId/cart.json?auth=$token');
    await http.delete(url);
    _cart.clear();
    notifyListeners();
  }

  Future<void> quantitySelecter(int value, Product product) async {
    final url = Uri.parse(
        'https://shopify-f5de2-default-rtdb.firebaseio.com/users/$userId/cart/${product.cartId}.json?auth=$token');
    await http.patch(url, body: json.encode({'quantity': value}));
    product.quantity = value;

    notifyListeners();
  }

  Future<void> fetchUserProducts() async {
    var url = Uri.parse(
        'https://shopify-d974d-default-rtdb.firebaseio.com/product.json?auth=$token&orderBy="userId"&equalTo="$userId"');
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    List<Product> loadedProducts = [];
    extractedData.forEach((prodId, prodData) {
      loadedProducts.add(Product(
        id: prodId,
        userId: userId,
        title: prodData['title'],
        description: prodData['description'],
        price: prodData['price'],
        isFavorite: prodData['isFavorite'],
        imageUrl: prodData['imageUrl'],
      ));
    });

    _userProducts = loadedProducts;

    notifyListeners();
  }
}
