import 'package:auth_buttons/auth_buttons.dart';
import 'package:firebase_practice/core/constants.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

class Loginview extends StatelessWidget {
  const Loginview({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                Column(
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
                    TextFormField(
                      // style: const TextStyle(color: kMainColor),
                      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      // style: const TextStyle(color: kMainColor),
                      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                        prefixIcon: const Icon(Icons.lock_open),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
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
                    TextButton(
                      onPressed: () {},
                      child: Container(
                        width: width * 0.45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: kMainColor,
                          borderRadius: BorderRadius.circular(
                            25,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'LOG IN',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
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
                          onPressed: () {},
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
                          onPressed: () {},
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
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
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
        ],
      ),
    );
  }
}
