import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_architecture/auth_repository.dart';
import 'package:flutter_architecture/data/repositories/preferences.dart';
import 'package:flutter_architecture/logic/auth/auth.dart';
import 'package:flutter_architecture/user_repository.dart';
import 'package:flutter_architecture/utils/logger.dart';
import 'package:meta/meta.dart';
import 'package:flutter_architecture/constants/enums.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    @required AuthRepository authRepository,
    @required UserRepository userRepository,
  })  : assert(authRepository != null),
        assert(userRepository != null),
        _authRepository = authRepository,
        _userRepository = userRepository,
        super(const AuthState.unknown()) {
    _authStatusSubscription = _authRepository.status.listen(
      (status) => add(AuthStatusChanged(status)),
    );
  }

  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final _prefs = Preferences();

  StreamSubscription<AuthStatus> _authStatusSubscription;

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AuthStatusChanged) {
      yield await _mapAuthStatusChangedToState(event);
    } else if (event is AuthLogoutRequested) {
      _authRepository.logOut();
    }
  }

  @override
  Future<void> close() {
    _authStatusSubscription?.cancel();
    _authRepository.dispose();
    return super.close();
  }

  Future<AuthState> _mapAuthStatusChangedToState(
    AuthStatusChanged event,
  ) async {
    switch (event.status) {
      case AuthStatus.unauthenticated:
        Logger.d("User not authenticated");
        return const AuthState.unauthenticated();
      case AuthStatus.authenticated:
        final user = await _tryGetUser();
        _doLoginOnPreferences(user);
        Logger.d("User authenticated: ${user.id}");
        return user != null
            ? AuthState.authenticated(user)
            : const AuthState.unauthenticated();
      default:
        return const AuthState.unknown();
    }
  }

  Future<User> _tryGetUser() async {
    try {
      final user = await _userRepository.getUser();
      return user;
    } on Exception {
      Logger.e("Exception trying to get user");
      return null;
    }
  }

  _doLoginOnPreferences(User user) {
    _prefs.id = user.id;
    _prefs.token = user.id;
  }
}
