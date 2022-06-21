import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:tech_shop/models/http_exception.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;

  bool get isAuthenticated => token != null;

  String get userId => _userId!;

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token!;
    }
    return null;
  }

  Future<void> _authenticate(String email, String password, String url) async {
    try {
      print(1);
      final response = await post(Uri.parse(url),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      print(_userId);
      notifyListeners();
    } catch (error) {
      print(error.toString());
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyA9w8T3SpYnTNBpgOKH8PuIuSQvX9Nu7zw';

    return _authenticate(email, password, url);
  }

  Future<void> login(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyA9w8T3SpYnTNBpgOKH8PuIuSQvX9Nu7zw';
    return _authenticate(email, password, url);
  }
}
