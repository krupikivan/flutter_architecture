import 'dart:async';

import 'package:flutter_architecture/constants/enums.dart';
import 'package:flutter_architecture/data/repositories/preferences.dart';
import 'package:meta/meta.dart';

class AuthRepository {
  final _controller = StreamController<AuthStatus>();
  final _prefs = Preferences();

  Stream<AuthStatus> get status async* {
    /**
     * We check if has token saved to decide if 
     * user is authenticated or not
     */
    if (_prefs.token.isNotEmpty) {
      yield AuthStatus.authenticated;
      yield* _controller.stream;
    } else {
      yield AuthStatus.unauthenticated;
      yield* _controller.stream;
    }
  }

  Future<void> logIn({
    @required String username,
    @required String password,
  }) async {
    assert(username != null);
    assert(password != null);
    /**
     * Calling API to authenticate
     */
    await Future.delayed(
      const Duration(milliseconds: 300),
      () => _controller.add(AuthStatus.authenticated),
    );
  }

  void logOut() {
    _prefs.clear();
    _controller.add(AuthStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}
