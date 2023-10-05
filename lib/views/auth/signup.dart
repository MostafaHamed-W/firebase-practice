import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/views/auth/widgets/auth_button.dart';
import 'package:firebase_practice/views/auth/widgets/auth_textfield.dart';
import 'package:flutter/material.dart';

import '../../core/constants.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? _firstPassValue = '';
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.grey[200],
            body: SizedBox(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: formState,
                      child: Column(
                        children: [
                          const SizedBox(height: 70),
                          const Text(
                            "Let's Get Started!",
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            "Create an account to CarPart to get all features",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 15),
                          ),
                          const SizedBox(height: 30),
                          const AuthTextField(
                            hintText: 'Name',
                            prefixIcon: Icons.person,
                            obsecureText: false,
                          ),
                          const SizedBox(height: 20),
                          AuthTextField(
                            hintText: 'Email',
                            prefixIcon: Icons.email,
                            obsecureText: false,
                            controller: emailController,
                            validator: (value) {
                              if (value == '') {
                                return 'Email cannot be empty, please Enter a valid email!';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          const AuthTextField(
                            hintText: 'Phone',
                            prefixIcon: Icons.phone_iphone,
                            obsecureText: false,
                          ),
                          const SizedBox(height: 20),
                          AuthTextField(
                            hintText: 'Password',
                            prefixIcon: Icons.lock_open,
                            obsecureText: true,
                            controller: passwordController,
                            validator: (value) {
                              _firstPassValue = value;
                              if (value == '') {
                                return 'Password is empty, please enter valid password!';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          AuthTextField(
                            hintText: 'Confirm Password',
                            prefixIcon: Icons.lock_open,
                            obsecureText: true,
                            validator: (value) {
                              if (value != _firstPassValue) {
                                return "Password didn't match";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          AuthButton(
                            text: 'CREATE',
                            onPress: () async {
                              setState(() {
                                isLoading = true;
                              });
                              if (formState.currentState!.validate()) {
                                try {
                                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );

                                  if (context.mounted) {
                                    Navigator.pushReplacementNamed(context, 'login');
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                } on FirebaseAuthException catch (e) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  if (e.code == 'weak-password') {
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.error,

                                      animType: AnimType.rightSlide,
                                      title: 'Weak Password',
                                      desc: 'the password provided is too weak',
                                      // btnOkOnPress: () {},
                                      // btnOkColor: Colors.red,
                                    ).show();
                                  } else if (e.code == 'email-already-in-use') {
                                    AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.error,
                                            animType: AnimType.rightSlide,
                                            title: 'Email',
                                            desc: 'Email already in use',
                                            btnOkOnPress: () {},
                                            btnOkColor: Colors.red)
                                        .show();
                                  } else {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.error,
                                            animType: AnimType.rightSlide,
                                            title: 'Something went wrong!',
                                            desc: e.message,
                                            btnOkOnPress: () {},
                                            btnOkColor: Colors.red)
                                        .show();
                                  }
                                } catch (e) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  debugPrint(e.toString());
                                }
                              } else {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 25),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 25),
                            child: InkWell(
                              onTap: () => Navigator.of(context).pushReplacementNamed('login'),
                              child: RichText(
                                text: const TextSpan(
                                  text: "Already have an account?\t",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Login here',
                                      style:
                                          TextStyle(color: kMainColor, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
}
