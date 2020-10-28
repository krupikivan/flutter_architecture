import 'package:equatable/equatable.dart';
import 'package:flutter_architecture/constants/enums.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthStatusChanged extends AuthEvent {
  const AuthStatusChanged(this.status);

  final AuthStatus status;

  @override
  List<Object> get props => [status];
}

class AuthLogoutRequested extends AuthEvent {}
