import 'package:equatable/equatable.dart';
import 'package:flutter_architecture/constants/enums.dart';
import 'package:flutter_architecture/data/models/user.dart';
import 'package:flutter_architecture/user_repository.dart';

class AuthState extends Equatable {
  const AuthState._({
    this.status = AuthStatus.unknown,
    this.user,
  });

  const AuthState.unknown() : this._();

  const AuthState.authenticated(User user)
      : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);

  final AuthStatus status;
  final User user;

  @override
  List<Object> get props => [status, user];
}
