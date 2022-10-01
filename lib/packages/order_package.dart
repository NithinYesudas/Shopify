import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopify/models/product.dart';
import 'package:http/http.dart' as http;

class Order {
  final id;
  final List<Product> products;
  final double amount;
  final DateTime time;

  Order({
    required this.products,
    required this.amount,
    required this.id,
    required this.time,
  });
}

class OrderPackage with ChangeNotifier {
  var token;
  var userId;

  OrderPackage(this.token, this.userId, this._orderItems);

  List<Order> _orderItems = [];

  List<Order> get orderItems {
    return [..._orderItems];
  }

  Future<void> orderPlaced(
    List<Product> product,
    double total,
  ) async {
    final url = Uri.parse(
        'https://shopify-d974d-default-rtdb.firebaseio.com/users/$userId/orders.json?auth=$token');
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'time': DateTime.now().toIso8601String(),
          'products': product.map((element) {
            return {
              'id': element.id,
              'title': element.title,
              'imageUrl': element.imageUrl,
              'description': element.description,
              'price': element.price,
              'quantity': element.quantity
            };
          }).toList()
        }));
    _orderItems.insert(
        0,
        Order(
            id: json.decode(response.body)['name'],
            products: product,
            amount: total,
            time: DateTime.now()));

    notifyListeners();
  }

  Future<void> fetchOrders() async {
    final url = Uri.parse(
        'https://shopify-d974d-default-rtdb.firebaseio.com/users/$userId/orders.json?auth=$token');
    final response = await http.get(url);

    List<Order> tempOrder = [];
    if (json.decode(response.body) == null) {
      return;
    }

    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    extractedData.forEach((key, value) {
      tempOrder.insert(
          0,
          Order(
              products: (value['products'] as List<dynamic>).map((product) {
                return Product(
                    title: product['title'],
                    id: product['id'],
                    quantity: product['quantity'],
                    description: product['description'],
                    imageUrl: product['imageUrl'],
                    price: product['price']);
              }).toList(),
              amount: value['amount'],
              id: key,
              time: DateTime.parse(value['time'])));
    });
    _orderItems = tempOrder;
    notifyListeners();
  }
}
