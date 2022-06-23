import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tech_shop/models/http_exception.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  bool get isAuthenticated => token != null;

  String? get userId => _userId;

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
      print(password);
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
      autoLogout();
      notifyListeners();
      final sharedPreferences = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String(),
      });
      sharedPreferences.setString('userData', userData);
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

  Future<bool> tryAutoLogin() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    if (!sharedPreferences.containsKey('userData') ||
        sharedPreferences.getString('userData') == null) return false;

    final extractedUserData =
        json.decode(sharedPreferences.getString('userData')!)
            as Map<String, dynamic>;

    final expiryDate = DateTime.tryParse(extractedUserData['expiryDate']);
    if (expiryDate == null || expiryDate.isBefore(DateTime.now())) return false;

    final token = extractedUserData['token'] as String?;
    final userId = extractedUserData['userId'] as String?;

    if (token == null || userId == null) return false;

    _token = token;
    _userId = userId;
    _expiryDate = expiryDate;

    notifyListeners();

    autoLogout();

    return true;
  }

  void logout() async {
    _token = null;
    _expiryDate = null;
    _userId = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove('userData');
  }

  void autoLogout() {
    if (_authTimer != null) _authTimer!.cancel();
    if (_expiryDate == null) {
      logout();
      return;
    }
    var secondsLeft = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: secondsLeft), logout);
  }
}
