import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyDataProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Map<String, dynamic>? _data;
  Map<String, dynamic>? get data => _data;
  String? _id;
  String? get id => _id;


  late StreamSubscription<DocumentSnapshot>? _subscription;

  void init() {
    _auth.authStateChanges().listen((user) async {
      if (user != null) {
        final userData = await _db.collection('users').doc(user.uid).get();
        _subscription = _db
            .collection('companies')
            .doc(userData.data()?["company"])
            .snapshots()
            .listen((snapshot) {
          _data = snapshot.data();
          _id = snapshot.id;
          notifyListeners();
        });
      } else {
        _id = null;
        _data = null;
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
