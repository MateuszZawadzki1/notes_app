import "package:equatable/equatable.dart";

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  AuthLoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;

  AuthRegisterRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthLogutRequested extends AuthEvent {}

class AuthCheckStatus extends AuthEvent {}
