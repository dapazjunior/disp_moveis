import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_mapas/views/login_view.dart';
import 'package:app_mapas/views/map_view.dart'; // Importe a MapView

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginView()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'Sair',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bem-vindo!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            if (user != null)
              Text(
                'Você está logado como: ${user.email}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // CORREÇÃO: Navegar para a MapView
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MapView()),
                );
              },
              child: const Text('Ir para Mapas'),
            ),
          ],
        ),
      ),
    );
  }
}