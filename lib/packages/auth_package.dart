import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopify/models/httpException.dart';

class AuthPackage with ChangeNotifier {
  String? _token;

  DateTime? expiry;
  String? userId;

  Timer? authTimer;

  String? get token {
    if (expiry != null && _token != null && expiry!.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  bool get isAuth {
    return token != null;
  }

  Future<void> signUp(String? email, String? password) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyA1_S8q8DZZm19-tqrA90JSjj281vZYccY');
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      userId = responseData['localId'];
      expiry = DateTime.now().add(Duration(seconds: responseData['expiresIn']));
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> login(String? email, String? password) async {
    var url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyA1_S8q8DZZm19-tqrA90JSjj281vZYccY');
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      userId = responseData['localId'];
      expiry = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      autoLogout();
      notifyListeners();
      final pref = await SharedPreferences.getInstance();
      final data = json.encode({
        'token': _token,
        'expiry': expiry!.toIso8601String(),
        'userId': userId,
      });
      pref.setString('userData', data);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> logOut() async {
    _token = null;
    expiry = null;
    userId = null;
    if (authTimer != null) {
      authTimer!.cancel();
      authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void autoLogout() {
    if (authTimer != null) {
      authTimer!.cancel();
    }
    final timeToExpiry = expiry!.difference(DateTime.now()).inSeconds;
    authTimer = Timer(Duration(seconds: timeToExpiry), logOut);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    String data = prefs.getString('userData') as String;
    final extractedUserData = json.decode(data) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData['expiry']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    userId = extractedUserData['userId'];
    expiry = expiryDate;
    notifyListeners();
    autoLogout();
    return true;
  }
}
