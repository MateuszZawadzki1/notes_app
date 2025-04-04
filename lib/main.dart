import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:notes_app/blocs/auth/auth_bloc.dart';
import 'package:notes_app/blocs/auth/auth_event.dart';
import 'package:notes_app/cubit/notes_cubit.dart';
import 'package:notes_app/widgets/test_retrofit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:notes_app/services/auth_service.dart';
import 'package:notes_app/widgets/login_screen.dart';
import 'package:notes_app/widgets/notes.dart';
import 'package:notes_app/widgets/register_screen.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: dotenv.get("SUPABASE_URL"),
    anonKey: dotenv.get("API_KEY"),
  );

  final authBloc = AuthBloc(authService: AuthService());
  authBloc.add(AuthCheckStatus());

  final initialRoute = Supabase.instance.client.auth.currentSession != null
      ? '/notes'
      : '/login';
  runApp(MyApp(initialRoute: initialRoute, authBloc: authBloc));
}

class MyApp extends StatelessWidget {
  final AuthBloc authBloc;
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute, required this.authBloc});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(
          value: authBloc,
        ),
      ],
      child: MaterialApp(
        initialRoute: initialRoute,
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/notes': (context) => Notes(),
          '/test_retrofit': (context) => TestRetrofit(),
        },
        theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      ),
    );
  }
}
