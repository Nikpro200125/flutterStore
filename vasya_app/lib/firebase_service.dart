import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final usersRef = FirebaseFirestore.instance.collection('users');
  final categoriesRef = FirebaseFirestore.instance.collection('categories');
  final suppliersRef = FirebaseFirestore.instance.collection('suppliers');
  final productsRef = FirebaseFirestore.instance.collection('products');
  String firebaseUser = FirebaseAuth.instance.currentUser.uid;
}