import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final usersRef = FirebaseFirestore.instance.collection('users');
  final categoriesRef = FirebaseFirestore.instance.collection('categories');
  String firebaseUser = FirebaseAuth.instance.currentUser.uid;
}