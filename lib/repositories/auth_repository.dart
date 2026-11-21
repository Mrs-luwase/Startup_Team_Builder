import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/app_user.dart';


class AuthFailure implements Exception {
  final String message;
  AuthFailure(this.message);
}

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;


  Stream<String?> uidChanges() =>
      _auth.authStateChanges().map((user) => user?.uid);

  Future<AppUser?> getProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromMap(uid, doc.data()!);
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_friendly(e.code));
    }
  }

  Future<AppUser> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = cred.user!.uid;
      try {
        await _db.collection('users').doc(uid).set({
          'name': name,
          'role': role,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } catch (_) {

        // Don't leave an account with no profile behind.
        await cred.user!.delete();
        throw AuthFailure('Could not save your profile. Please try again.');
      }
      return AppUser(uid: uid, name: name, role: role);
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_friendly(e.code));
    }
  }

  Future<void> signOut() => _auth.signOut();

  String _friendly(String code) {
    switch (code) {
      case 'invalid-email':
        return 'That email address looks wrong.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email or password is incorrect.';
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'network-request-failed':
        return 'No internet connection. Please try again.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a moment.';
      default:
        return 'Something went wrong ($code). Please try again.';
    }
  }
}