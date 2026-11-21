import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'repositories/auth_repository.dart';
import 'screens/auth_gate.dart';
import 'state/auth_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const StartupTeamBuilderApp());
}

class StartupTeamBuilderApp extends StatelessWidget {
  const StartupTeamBuilderApp({super.key});

  @override
  Widget build(BuildContext context) {
    // One AuthState for the whole app, created once here.
    return ChangeNotifierProvider(
      create: (_) => AuthState(AuthRepository()),
      child: MaterialApp(
        title: 'Startup Team Builder',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1B5E3A)),
        ),
        home: const AuthGate(),
      ),
    );
  }
}