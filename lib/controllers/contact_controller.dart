import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/contact_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ContactController with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Contact> _contacts = [];

  List<Contact> get contacts => _contacts;

  ContactController() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _listenToContacts();
      } else {
        _contacts = [];
        notifyListeners();
      }
    });
  }

  void _listenToContacts() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    _firestore
        .collection('users')
        .doc(userId)
        .collection('contacts')
        .snapshots()
        .listen((snapshot) {
      _contacts = snapshot.docs
          .map((doc) => Contact.fromMap(doc.data(), doc.id))
          .toList();
      notifyListeners();
    });
  }

  Future<void> addContact(Contact contact) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('contacts')
        .doc(contact.id)
        .set(contact.toMap());
  }

  Future<void> updateContact(Contact contact) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('contacts')
        .doc(contact.id)
        .update(contact.toMap());
  }

  Future<void> deleteContact(String contactId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('contacts')
        .doc(contactId)
        .delete();
  }
}