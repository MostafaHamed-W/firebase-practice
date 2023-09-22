import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomePage'),
        actions: [
          IconButton(
            onPressed: () async {
              GoogleSignIn googleSignIn = GoogleSignIn();
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, 'login');
              googleSignIn.disconnect();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
