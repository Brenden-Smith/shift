import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shift/providers/company.dart';
import 'package:shift/screens/home.dart';
import 'package:shift/screens/login.dart';
import 'package:shift/screens/schedule.dart';
import 'package:shift/screens/settings.dart';
import 'package:shift/screens/team.dart';
import 'package:shift/providers/user.dart';
import 'firebase_options.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  usePathUrlStrategy();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => UserDataProvider()..init()),
    ChangeNotifierProvider(create: (context) => CompanyDataProvider()..init()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shift',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green.shade500),
        useMaterial3: true,
      ),
      home: const MainPage(),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            return PageRouteBuilder(
              pageBuilder: (_, __, ___) => const HomePage(),
              settings: settings,
            );

          case '/settings':
            return PageRouteBuilder(
              pageBuilder: (_, __, ___) => const SettingsPage(),
              settings: settings,
            );
          case '/team':
            return PageRouteBuilder(
              pageBuilder: (_, __, ___) => const TeamPage(),
              settings: settings,
            );
          case '/schedule':
            return PageRouteBuilder(
              pageBuilder: (_, __, ___) => const SchedulePage(),
              settings: settings,
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const MainPage(),
              settings: settings,
            );
        }
      },
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const HomePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
