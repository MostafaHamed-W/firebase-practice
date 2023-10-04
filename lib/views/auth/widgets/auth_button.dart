import 'package:flutter/material.dart';

import '../../../core/constants.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    this.onPress,
    required this.text,
  });

  final String text;
  final void Function()? onPress;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return TextButton(
      onPressed: onPress,
      child: Container(
        width: width * 0.45,
        height: 45,
        decoration: BoxDecoration(
          color: kMainColor,
          borderRadius: BorderRadius.circular(
            25,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
