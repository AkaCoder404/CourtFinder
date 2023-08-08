import 'package:flutter/material.dart';
import 'package:courtfinder/theme/pallete.dart';

class AuthField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String type;
  const AuthField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: type == "password" ? true : false,
      style: const TextStyle(color: Pallete.blackColor),
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Pallete.orangeColor,
            width: 3,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Pallete.blackColor,
          ),
        ),
        contentPadding: const EdgeInsets.all(22),
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 18, color: Pallete.blackColor),
      ),
    );
  }
}
