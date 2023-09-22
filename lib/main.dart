import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/views/auth/login.dart';
import 'package:firebase_practice/views/auth/signup.dart';
import 'package:flutter/material.dart';
import 'views/home/home_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen(
      (User? user) {
        if (user == null) {
          print('====================User is currently signed out!');
        } else {
          print('====================User is signed in!');
        }
      },
    );
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        'signup': (context) => const SignupView(),
        'login': (context) => const Loginview(),
        'home': (context) => const HomePage(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: (FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser!.emailVerified)
          ? const HomePage()
          : const Loginview(),
    );
  }
}
