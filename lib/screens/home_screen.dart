import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/auth_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthState>().user!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Team Builder'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () => context.read<AuthState>().signOut(),
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Welcome, ${user.name}\nYou are a ${user.role}.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}