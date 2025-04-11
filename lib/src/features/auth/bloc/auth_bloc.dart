import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:notes_app/src/features/auth/bloc/auth_event.dart';
import 'package:notes_app/src/features/auth/bloc/auth_state.dart' as auth_s;
import 'package:notes_app/src/features/auth/data/repositories/auth_service.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, auth_s.AuthState> {
  AuthBloc({required this.authService}) : super(auth_s.AuthInitial()) {
    on<AuthCheckStatus>(_onAuthCheckStatus);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }
  final AuthService authService;

  Future<void> _onAuthCheckStatus(
    AuthCheckStatus event,
    Emitter<auth_s.AuthState> emit,
  ) async {
    emit(auth_s.AuthLoading());

    if (authService.accessToken != null) {
      emit(auth_s.AuthAuthenticated());
    } else {
      emit(auth_s.AuthUnauthenticated());
    }
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<auth_s.AuthState> emit,
  ) async {
    emit(auth_s.AuthLoading());

    try {
      final success = await authService.login(event.email, event.password);

      if (success) {
        emit(auth_s.AuthAuthenticated());
      } else {
        emit(auth_s.AuthFailure('Invalid email or password'));
      }
    } on Exception catch (e) {
      emit(auth_s.AuthFailure(e.toString()));
    }
  }

  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<auth_s.AuthState> emit,
  ) async {
    emit(auth_s.AuthLoading());

    try {
      final success = await authService.register(event.email, event.password);

      if (success) {
        emit(auth_s.AuthAuthenticated());
      } else {
        emit(auth_s.AuthFailure('Registration failed'));
      }
    } catch (e) {
      emit(auth_s.AuthFailure(e.toString()));
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<auth_s.AuthState> emit,
  ) async {
    if (state is auth_s.AuthLoading) return;
    emit(auth_s.AuthLoading());
    log('Rozpoczeto wylogowanie');
    try {
      await authService.signOut();
      log('Wylogowanie zakonczone');
      emit(auth_s.AuthUnauthenticated());
    } catch (e) {
      emit(auth_s.AuthFailure('LOgout failed: $e'));
    }
  }
}
