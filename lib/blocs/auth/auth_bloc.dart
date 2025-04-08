import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:notes_app/blocs/auth/auth_event.dart';
import 'package:notes_app/blocs/auth/auth_state.dart' as authS;
import 'package:notes_app/services/auth_service.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, authS.AuthState> {
  final AuthService authService;

  AuthBloc({required this.authService}) : super(authS.AuthInitial()) {
    on<AuthCheckStatus>(_onAuthCheckStatus);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLogutRequested>(_onAuthLogoutRequested);
  }

  Future<void> _onAuthCheckStatus(
    AuthCheckStatus event,
    Emitter<authS.AuthState> emit,
  ) async {
    emit(authS.AuthLoading());

    if (authService.accessToken != null) {
      emit(authS.AuthAuthenticated());
    } else {
      emit(authS.AuthUnauthenticated());
    }
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<authS.AuthState> emit,
  ) async {
    emit(authS.AuthLoading());

    try {
      final success = await authService.login(event.email, event.password);

      if (success) {
        emit(authS.AuthAuthenticated());
      } else {
        emit(authS.AuthFailure("Invalid email or password"));
      }
    } catch (e) {
      emit(authS.AuthFailure(e.toString()));
    }
  }

  Future<void> _onAuthRegisterRequested(
      AuthRegisterRequested event, Emitter<authS.AuthState> emit) async {
    emit(authS.AuthLoading());

    try {
      final success = await authService.register(event.email, event.password);

      if (success) {
        emit(authS.AuthAuthenticated());
      } else {
        emit(authS.AuthFailure("Registration failed"));
      }
    } catch (e) {
      emit(authS.AuthFailure(e.toString()));
    }
  }

  Future<void> _onAuthLogoutRequested(
      AuthLogutRequested event, Emitter<authS.AuthState> emit) async {
    if (state is authS.AuthLoading) return;
    emit(authS.AuthLoading());

    try {
      await authService.signOut();
      log('test');
      emit(authS.AuthUnauthenticated());
    } catch (e) {
      emit(authS.AuthFailure("LOgout failed: ${e.toString()}"));
    }
  }
}
