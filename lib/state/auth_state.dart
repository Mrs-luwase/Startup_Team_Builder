import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/app_user.dart';
import '../repositories/auth_repository.dart';

/// The "brain" for sign-in.
class AuthState extends ChangeNotifier {
  final AuthRepository _repo;
  StreamSubscription<String?>? _sub;

  AppUser? _user;
  bool _checking = true;
  bool _busy = false;
  bool _signingUp = false;
  String? _error;

  AuthState(this._repo) {
    _sub = _repo.uidChanges().listen(_onUidChanged);
  }

  AppUser? get user => _user;
  bool get checking => _checking;
  bool get busy => _busy;
  String? get error => _error;

  Future<void> _onUidChanged(String? uid) async {
    if (_signingUp) return; // signUp() sets the user itself
    if (uid == null) {
      _user = null;
    } else {
      try {
        _user = await _repo.getProfile(uid);
        if (_user == null) await _repo.signOut(); // account without profile
      } catch (_) {
        _user = null;
      }
    }
    _checking = false;
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    _busy = true;
    _error = null;
    notifyListeners();
    try {
      await _repo.signIn(email, password);
    } on AuthFailure catch (e) {
      _error = e.message;
    } finally {
      _busy = false;
      notifyListeners();
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    _busy = true;
    _signingUp = true;
    _error = null;
    notifyListeners();
    try {
      _user = await _repo.signUp(
        name: name,
        email: email,
        password: password,
        role: role,
      );
    } on AuthFailure catch (e) {
      _error = e.message;
    } finally {
      _signingUp = false;
      _busy = false;
      notifyListeners();
    }
  }

  Future<void> signOut() => _repo.signOut();

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _sub?.cancel(); // stop listening
    super.dispose();
  }
}