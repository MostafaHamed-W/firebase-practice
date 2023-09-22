import 'package:auth_buttons/auth_buttons.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/core/constants.dart';

import 'package:firebase_practice/views/auth/widgets/auth_button.dart';
import 'package:firebase_practice/views/auth/widgets/auth_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Loginview extends StatefulWidget {
  const Loginview({super.key});

  @override
  State<Loginview> createState() => _LoginviewState();
}

class _LoginviewState extends State<Loginview> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // to avoid errors that happens because googleUser is null value when user
    // dismiss the login google windows without loging in
    if (googleUser == null) {
      return;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.pushReplacementNamed(context, 'home');
  }

  Future signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    if (loginResult == null) {
      return;
    }

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken?.token ?? '');

    // Once signed in, return the UserCredential
    FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    Navigator.pushReplacementNamed(context, 'home');
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              Form(
                key: formState,
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'assets/images/login_image.svg',
                      height: width * 0.65,
                    ),
                    const Text(
                      'Welcome back!',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Log in to your existant account of CarPart',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 30),
                    AuthTextField(
                      hintText: 'Email',
                      prefixIcon: Icons.person,
                      obsecureText: false,
                      controller: emailController,
                      validator: (value) {
                        if (value == '') {
                          return 'Email cannot be empty!';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    AuthTextField(
                      hintText: 'Password',
                      prefixIcon: Icons.lock_open,
                      obsecureText: true,
                      controller: passwordController,
                      validator: (value) {
                        if (value == '') {
                          return 'Password cannot be empty!';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                    AuthButton(
                      text: 'LOG IN',
                      onPress: () async {
                        if (formState.currentState!.validate()) {
                          try {
                            final credential =
                                await FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text,
                            );
                            if (credential.user!.emailVerified) {
                              Navigator.pushReplacementNamed(context, 'home');
                            } else {
                              credential.user!.sendEmailVerification();
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Email not verified',
                                desc:
                                    'Please verify your email first.\na message of verification link has sent to your email',
                              ).show();
                            }
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Wrong User',
                                desc: 'No user found for that email.',
                              ).show();
                            } else if (e.code == 'wrong-password') {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Wrong Password',
                                desc: 'Wrong password provided for that user.',
                              ).show();
                            }
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Or connect using',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FacebookAuthButton(
                          text: 'Facebook',
                          onPressed: signInWithFacebook,
                          style: const AuthButtonStyle(
                            elevation: 0,
                            width: 120,
                            separator: 10,
                            iconSize: 16,
                            // buttonColor: Color(0xFFf04235),
                            iconColor: Colors.white,
                            textStyle: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ),
                        GoogleAuthButton(
                          text: 'Google',
                          onPressed: signInWithGoogle,
                          style: const AuthButtonStyle(
                            elevation: 0,
                            width: 120,
                            separator: 10,
                            margin: EdgeInsets.zero,
                            iconSize: 16,
                            buttonColor: Color(0xFFf04235),
                            iconColor: Colors.white,
                            textStyle: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 25),
                      child: InkWell(
                        onTap: () => Navigator.of(context).pushReplacementNamed('signup'),
                        child: RichText(
                          text: const TextSpan(
                            text: "Don't have an account?\t",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: 'Sign Up',
                                style: TextStyle(color: kMainColor, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
