import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:notes_app/blocs/auth/auth_bloc.dart';
import 'package:notes_app/blocs/auth/auth_event.dart';
import 'package:notes_app/di.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:notes_app/widgets/login_screen.dart';
import 'package:notes_app/widgets/notes.dart';
import 'package:notes_app/widgets/register_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: dotenv.get("SUPABASE_URL"),
    anonKey: dotenv.get("API_KEY"),
  );

  await configureDependecies();

  final authBloc = getIt<AuthBloc>();
  authBloc.add(AuthCheckStatus());

  final initialRoute = Supabase.instance.client.auth.currentSession != null
      ? '/notes'
      : '/login';
  runApp(MyApp(
    initialRoute: initialRoute,
    authBloc: authBloc,
    localeOverride: const Locale('pl'),
  ));
}

class MyApp extends StatelessWidget {
  final AuthBloc authBloc;
  final String initialRoute;
  final Locale? localeOverride;
  const MyApp(
      {super.key,
      required this.initialRoute,
      required this.authBloc,
      this.localeOverride});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(
          value: authBloc,
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: localeOverride,
        initialRoute: initialRoute,
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/notes': (context) => Notes(),
        },
        theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      ),
    );
  }
}
