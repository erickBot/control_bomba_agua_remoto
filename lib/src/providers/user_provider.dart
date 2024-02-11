import 'package:flutter/material.dart';
import 'package:flutter_view_app/src/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  User? _user;

  User? get currentUser => _user;

  void setCurrentUser(User? user) {
    _user = user;
    notifyListeners();
  }
}
