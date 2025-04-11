import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_app/src/core/di/di.dart';
import 'package:notes_app/src/features/auth/bloc/auth_bloc.dart';
import 'package:notes_app/src/features/auth/bloc/auth_event.dart';
import 'package:notes_app/src/features/auth/bloc/auth_state.dart' as auth_s;
import 'package:notes_app/src/features/auth/ui/screens/login_screen.dart';
import 'package:notes_app/src/features/auth/ui/screens/register_screen.dart';
import 'package:notes_app/src/features/notes/ui/screens/notes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GoRouter _router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/notes',
      builder: (context, state) => const Notes(),
    ),
  ],
  redirect: (context, state) {
    final authState = context.read<AuthBloc>().state;
    final isAuthenticated = authState is auth_s.AuthAuthenticated;
    final isGoingToLogin = state.matchedLocation == '/login';
    if (!isAuthenticated && !isGoingToLogin) {
      return '/login';
    }
    if (isAuthenticated && isGoingToLogin) {
      return '/notes';
    }
    return null;
  },
);

void main() async {
  await dotenv.load();

  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: dotenv.get('SUPABASE_URL'),
    anonKey: dotenv.get('API_KEY'),
  );

  await configureDependecies();

  final authBloc = getIt<AuthBloc>()..add(AuthCheckStatus());
  runApp(
    MyApp(
      authBloc: authBloc,
      localeOverride: const Locale('pl'),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    required this.authBloc,
    super.key,
    this.localeOverride,
  });
  final AuthBloc authBloc;
  final Locale? localeOverride;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: authBloc),
      ],
      child: MaterialApp.router(
        routerConfig: _router,
        builder: (context, child) {
          return BlocListener<AuthBloc, auth_s.AuthState>(
            listener: (context, state) {
              // if (state is auth_s.AuthUnauthenticated) {
              //   context.go('/login');
              // } else if (state is auth_s.AuthAuthenticated) {
              //   context.go('/notes');
              // }
            },
            child: child,
          );
        },
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: localeOverride,
        theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      ),
    );
  }
}
