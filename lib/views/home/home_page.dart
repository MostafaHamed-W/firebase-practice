import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../auth/widgets/auth_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    String? currentUserEmail = FirebaseAuth.instance.currentUser?.email ?? 'unknown email';
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.grey[200],
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 15, top: 15),
                  child: IconButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      await signOut(context);
                      setState(() {
                        isLoading = true;
                      });
                    },
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            body: SizedBox(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  Column(
                    children: [
                      SvgPicture.asset(
                        'assets/images/login_image.svg',
                        height: width * 0.65,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Logged in successfully',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 7.0),
                          Icon(Icons.verified, color: Colors.green),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        'Welcome $currentUserEmail',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 70),
                      const Text(
                        'You can log out and try another method',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      AuthButton(
                        text: 'LOG OUT',
                        onPress: () async {
                          setState(() {
                            isLoading = true;
                          });
                          await signOut(context);
                          setState(() {
                            isLoading = false;
                          });
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(
            color: Colors.grey.withOpacity(0.6),
            child: Visibility(
              visible: isLoading,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> signOut(BuildContext context) async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    await FirebaseAuth.instance.signOut();
    // ignore: use_build_context_synchronously
    Navigator.pushReplacementNamed(context, 'login');
    googleSignIn.disconnect();
  }
}
