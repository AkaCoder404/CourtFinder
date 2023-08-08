import 'package:flutter/material.dart';
import 'package:courtfinder/theme/pallete.dart';

class RoundedRectangleButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const RoundedRectangleButton({
    super.key,
    required this.onTap,
    required this.label,
    this.backgroundColor = Pallete.orangeColor,
    this.textColor = Pallete.blackColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Chip(
        label: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        backgroundColor: backgroundColor,
        labelPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 5,
        ),
      ),
    );
  }
}
