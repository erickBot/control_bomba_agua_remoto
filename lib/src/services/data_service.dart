import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_view_app/src/models/user_model.dart';
import 'package:flutter_view_app/src/utils/shared_preferences.dart';

class DataService {
  // FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference? _ref;
  final _prefs = SharedPref();
  User? user;

  DataService() {
    _ref = FirebaseDatabase.instance.ref('Estacion1');
  }

  Future<void> setData(
      User user, Map<String, dynamic> sensors, BuildContext context) async {
    await _ref!.child(user.id).set({
      "SENSORS": sensors,
    });
  }

  Future<void> updateData(
      User user, Map<String, dynamic> sensors, BuildContext context) async {
    await _ref!.child(user.id).update({
      "SENSORS": sensors,
    });
  }

  Future<DatabaseReference> getData(User user) async {
    return _ref!.child('${user.id}/SENSORS');
  }
}
