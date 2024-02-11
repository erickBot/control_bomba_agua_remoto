import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_view_app/src/models/user_model.dart';

class UserService {
  CollectionReference? _ref;
  User? user;

  UserService() {
    _ref = FirebaseFirestore.instance.collection('Users');
  }

  Future<void> create(User user) async {
    String errorMessage;

    try {
      return _ref!.doc(user.id).set(user.toJson());
    } catch (error) {
      errorMessage = error.toString();
    }

    if (errorMessage != null) {
      return Future.error(errorMessage);
    }
  }

  Future<User?> getByUserId(String id) async {
    DocumentSnapshot document = await _ref!.doc(id).get();

    if (document.exists) {
      user = User.fromJson(document.data() as Map<String, dynamic>);
      return user;
    }
    return null;
  }

  //actualizar informacion en firebase
  Future<void> update(Map<String, dynamic> data, String id) {
    return _ref!.doc(id).update(data);
  }

  //obtener datos en tiempo real
  Stream<DocumentSnapshot> getByIdStream(String id) {
    return _ref!.doc(id).snapshots(includeMetadataChanges: true);
  }
}
