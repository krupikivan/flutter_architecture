import 'dart:async';

abstract class Repository {
  Future<void> authenticate();

  void signOut();

  Future<void> signUp({String email, String password});

  Future<bool> isAuthenticated();

  String getEmail();

  bool hasToken();
}
