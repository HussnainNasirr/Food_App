import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'home_screen.dart';
import 'sign_in.dart'; // Import LoginPage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(
        nextPage: FutureBuilder<bool>(
          future: _checkAuthState(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasData && snapshot.data == true) {
              return HomeScreen(); // Navigate to HomeScreen if authenticated
            } else {
              return LoginPage(); // Navigate to LoginPage if not authenticated
            }
          },
        ),
      ),
    );
  }

  Future<bool> _checkAuthState() async {
    final user = FirebaseAuth.instance.currentUser;
    return user != null;
  }
}
