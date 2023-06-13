import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? _user;
  Map<String, dynamic>? _userData;

  User? get user => _user;
  Map<String, dynamic>? get userData => _userData;

  late StreamSubscription<DocumentSnapshot>? _subscription;

  void init() {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        _user = user;
        _subscription = _db
            .collection('users')
            .doc(user.uid)
            .snapshots()
            .listen((snapshot) {
          _userData = snapshot.data();
          notifyListeners();
        });
      } else {
        _user = null;
        _userData = null;
        _subscription?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
