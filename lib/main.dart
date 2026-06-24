import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:app_mapas/firebase_options.dart'; // Importe este
import 'package:app_mapas/views/login_view.dart'; // Importe este

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Mapas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginView(), // Alterado para LoginView
      debugShowCheckedModeBanner: false,
    );
  }
}
