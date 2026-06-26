import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  User? get user => _user;
  bool get isAuthenticated => _user != null;

  AuthController() {
    _auth.authStateChanges().listen((User? firebaseUser) {
      _user = firebaseUser;
      notifyListeners();
    });
  }

  Future<String?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // Sucesso
    } on FirebaseAuthException catch (e) {
      return e.message; // Retorna a mensagem de erro
    }
  }

  Future<String?> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return null; // Sucesso
    } on FirebaseAuthException catch (e) {
      return e.message; // Retorna a mensagem de erro
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null; // Sucesso
    } on FirebaseAuthException catch (e) {
      return e.message; // Retorna a mensagem de erro
    }
  }
}